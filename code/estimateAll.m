% This is the main function for TRiP.
% 
% This function assumes that the folder ../input contains one or more
% sub-directories each of which contains an image stack for one plant.
%
% All output is written to ../output/<subdir>. The output for consists of:
%   1. a .csv file containing 
%   2. a .png image that shows the vertical motion plotted as a function of
%      time.

function[] = estimateAll()

% specify where the input and output data are
indirname = '../cropped/';
outdirname = '../output/';

% get list of cropped image sub-directories
d = dir( sprintf( '%s/crop_*', indirname ) );

% eliminate any '.' files
c = 1;
for k = 1 : numel(d)
    if( d(k).isdir == 1 ) % make sure that this is a directory
        d2(c) = d(k); 
        c = c + 1;
    end
end
d = d2;
fprintf( 'found %d directories.\n', numel(d) );

% estimate motion for each sub-directory
for k = 1 : numel(d)
%     if( exist( sprintf('../%s/%s.csv',outdirname, d(k).name) ,'file' ) )
    if( exist( sprintf('../%s.csv',outdirname, d(k).name) ,'file' ) )    
        fprintf( '%s already exists... skipping.\n', d(k).name );
    else
        try
            [motion_x,motion_y] = estimateMotion( sprintf('%s/%s', indirname,d(k).name) );
        catch ME
            fprintf( 'error estimate motion for %s... skipping.\n' );
            continue;
        end
        
        % write motion data to .csv file
        fd = fopen( sprintf('%s/%s.csv', outdirname, d(k).name), 'w' );
        for j = 1 : length(motion_y)
            fprintf( fd, '%f\n', motion_y(j) );
            % use this if you want horizontal and vertical motion to be output
            % fprintf( fd, '%f,%f\n', motion_x(j), motion_y(j) ); 
        end
        fclose(fd);
        
        % generate motion vs. time plot and save
        figure(1);
        cla;
        hold on;
        plot( motion_y, 'k' );
        hold off;
        legend( 'vertical' );
        xlabel( 'frame' );
        ylabel( 'motion (pixels/frame)' );
        title( d(k).name );
        box on;
        axis tight;
        FRAME = getframe(gcf);
        imwrite( uint8(frame2im(FRAME)), sprintf('%s/%s.png',outdirname,d(k).name) );
    end
end
