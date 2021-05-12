
clc;
clear all;

files = dir('*.csv');
outdirname = ('folder/you/want/to/saveyourresults');

for i=1:length(files)
    try 
% define your time range here
dat   = csvread( files(i).name );
dat   = dat(:,2)'; % vertical motion
% define your time range here
dat   = dat(163:522);
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
D = D(mid:mid+10); % assumes that dominant frequency is less than or equal to 10
[val,ind] = max(abs(D));
freq = ind-1; % starting condition
phase = angle(D(ind)); % starting condition

amp    = mean(abs(dat)); % starting conditions
model = fminsearch( 'errorFunc1', [freq phase amp], [], dat ); % optimize
fprintf( 'frequency = %f\n', model(1) );
pause(2);


% plot results
f     = evaluateModel1( model, N );
plot( dat, 'b' );
hold on;
plot( f, 'r' );
axis( [0 N-1 min(dat) max(dat)] );
legend( 'data', 'model' );
hold off;
FRAME = getframe(gcf);
imwrite( uint8(frame2im(FRAME)), sprintf('../%s/%s.png',outdirname,files(i).name) );

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
fun = @evaluateModel1;
beta0 = [freq;phase;amp];
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

% write period/RAE/rsq data to .csv file
  fd = fopen( sprintf('../%s/%s.csv', outdirname, files(i).name), 'w' );
  for i = 1 : length(files)
  fprintf( fd, '%f,%f,%f,%f\n', Period(i), CTP(i), rsq(i), RAE(i) );
  end
  fclose(fd);

catch exception %# Catch the exception
continue       %# Pass control to the next loop iteration
    end
end












 