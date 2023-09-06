% This function fits a model to the all of the .csv files created by
% estimateAll. Each csv file contains a single column of data -- the 
% vertical motion trace as a function of time. The function modelFit fits 
% a single sinusoid to this motion trace. This fitting proceeds as follows:
%   1. detrend the data
%   2. determine frequency, phase, amplitude of dominant harmonic
%   3. perform non-linear minimization to refine estimate of frequency,
%      phase, amplitude.
%
% This function outputs two things:
%   1. a .txt file in ../output with the estimated frequency
%   2. a .png image in ../output showing the motion trace and model fit
%


function[] = modelFitAll()

d = dir( '../output/*.csv' );
% Allocate arrays for table
Path_Array = {};
Period_Array = {};
CTP_Array = {};
rsq_Array = {};
rae_Array = {};

for k = 1 : numel(d)
    fn    = ['../output/' d(k).name];
    dat   = csvread( fn );
    dat   = dat';
    dat(isnan(dat)) = 0;
    dat   = dat - mean(dat); % zero-mean
    dat   = detrend(dat);
    N     = length(dat);
    
    % compute dominant frequency and phase for starting condition
    D = fftshift( fft(dat) );
%     plot(fft(dat), abs(fft(dat))); grid on
%     plot(D, abs(fft(D))); grid on
    if( mod(length(dat),2) == 0 )
        mid = length(dat)/2 + 1;
    else
        mid = floor(length(dat)/2) + 1;
    end
    D      = D(mid:mid+10); % assumes that dominant frequency is less than or equal to 10
    [val,ind] = max(abs(D));
    freq   = ind-1; % starting condition
    phase  = angle(D(ind)); % starting condition
    amp    = mean(abs(dat)); % starting conditions
    
    % non-linear fitting of frequency, phase, and amplitude

    % Got stuck here on 20230206 -Joan
    model  = fminsearch( 'errorFunc', [freq phase amp], [], dat ); % optimize
    
    % save model fit to ../ouput/fn_model.txt  [WHY????]
%     fnout = strrep( fn, '.csv', '_model.txt' );
%     fdout = fopen( fnout, 'w' );
%     fprintf( fdout, '%f\n', model(1) );
%     fclose( fdout );
    
    % plot results
    fnout = strrep( fn, '.csv', '_model.png' );
    f     = evaluateModel( model, N );
    plot( dat, 'b' );
    hold on;
    plot( f, 'r' );
    % the evaluation right below is needed in case model=[0,0,0]
    model(isnan(model)) = 0;
    if nnz(~model) > 2
        axis( [0 N-1 -1 1] );
    else
        axis( [0 N-1 min(dat) max(dat)] );
    end 
    legend( 'data', 'model' );
    title( sprintf( 'frequency = %f', model(1) ) );
    hold off;
    drawnow;
    FRAME = getframe(gcf);
    imwrite( uint8(frame2im(FRAME)), fnout );
    
    freq = model (1,1);
	Period = N/freq;
	Period = Period/3;
	phase = model (1,2);
	Pjust = 24/Period;
	phi_ang   = phase/Pjust;
	phi   = phi_ang/pi;
	phi  =  phi*12;
	if phi < 0
  	 CTP = (abs(phi)*24)/Period;
	else
   	CTP = 24 - (phi*24)/Period;
    end


	%added the function for RAE
	fun = @evaluateModel;
	beta0 = [freq;phase;amp];
    beta0(isnan(beta0)) = 0;
    dat(isnan(dat)) = 0;
	%fminsearch results as init
	[beta,r,J,MSE] = nlinfit(N,dat,fun,beta0);
	rsq = 1 - sum(r.^2) / sum((dat - mean(dat)).^2);
	%find the jacobian matrics
	ci = nlparci(beta,r,'jacobian',J);
	CI_freq=ci(1,2)-ci(1,1);
	CI=(CI_freq*Period)/freq;
	%calcualtion RAE
	ciAMP = (ci(3,2)-ci(3,1))/2;
	AMP = amp;
	RAE = ciAMP/AMP;
    disp(Period(1))


    % Write data to table
    str = d(k).name;
    Path_Array = [Path_Array, str];
    Period_Array = [Period_Array, Period(1)];
    CTP_Array = [CTP_Array, CTP(1)];
    rsq_Array = [rsq_Array, rsq(1)];
    rae_Array = [rae_Array, RAE(1)];

    end

    % Table to csv
    MyTable = table;
    MyTable.Path = transpose(Path_Array);
    MyTable.Period = transpose(Period_Array);
    MyTable.CTP = transpose(CTP_Array);
    MyTable.rsq = transpose(rsq_Array);
    MyTable.rae = transpose(rae_Array);
    writetable(MyTable,'../output/model_output.csv');

end
