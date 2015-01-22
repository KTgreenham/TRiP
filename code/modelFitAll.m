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
    model  = fminsearch( 'errorFunc', [freq phase amp], [], dat ); % optimize
    
    % save model fit to ../ouput/fn_model.txt
    fnout = strrep( fn, '.csv', '_model.txt' );
    fdout = fopen( fnout, 'w' );
    fprintf( fdout, '%f\n', model(1) );
    fclose( fdout );
    
    % plot results
    fnout = strrep( fn, '.csv', '_model.png' );
    f     = evaluateModel( model, N );
    plot( dat, 'b' );
    hold on;
    plot( f, 'r' );
    axis( [0 N-1 min(dat) max(dat)] );
    legend( 'data', 'model' );
    title( sprintf( 'frequency = %f', model(1) ) );
    hold off;
    drawnow;
    FRAME = getframe(gcf);
    imwrite( uint8(frame2im(FRAME)), fnout );
    
end
    
