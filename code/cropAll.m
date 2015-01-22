% Crop all JPEG images in a specified directory
%
% Input <fn> should be a plain text file where each line has the
% following format:
%     subdir y1 y2 x1 x2
%
% This function will create a cropped version of each image in
% <dirName>/<subdir>

function[] = cropAll( fn )

% open input file (fn)
fd = fopen( fn, 'r' );
if( fd == -1 )
    fprintf( 'File %s does not exist... aborting\n' );
    return;
end
fclose(fd);

% read dirName (must be JPEG files -- change suffix below for other
% formats)
dirName = '../input';
d1 = dir( sprintf( '%s/*.jpg', dirName ) );
d2 = dir( sprintf( '%s/*.jpeg', dirName ) );
d3 = dir( sprintf( '%s/*.JPG', dirName ) );
d4 = dir( sprintf( '%s/*.JPEG', dirName ) );
d  = [d1 ; d2 ; d3 ; d4];
d  = unique( {d(:).name} );
fprintf( 'Found %d images.\n', numel(d) );

% begin...
for k = 1 : numel(d)
    fprintf( 'processing %d/%d...\n', k, numel(d) );
    im = imread( sprintf( '%s/%s', dirName, d{k} ) );
    fd = fopen( fn, 'r' );
    while(1)
        line = fgetl( fd );
        if( length(line) > 0 ) % skip any blank lines
            if( line == -1  )
                fclose(fd);
                break;
            end
            
            % parse single line of input file (fn)
            [subdir,tail] = strtok( line );
            [y1,tail] = strtok( tail );
            [y2,tail] = strtok( tail );
            [x1,tail] = strtok( tail );
            [x2,tail] = strtok( tail );
            subdir = sprintf( '%s/crop_%s', dirName, subdir ); % write everything into ../input
            y1 = str2num(y1);
            y2 = str2num(y2);
            x1 = str2num(x1);
            x2 = str2num(x2);
            
            % load, crop, and write, if file has not previously been
            % generated (this deals with the case when this code is re-run
            % after a crash)
            if( exist( sprintf('%s/crop_%s',subdir,d{k}), 'file' ) )
                fprintf( 'skipping %s/crop_%s.\n', subdir, d{k} );
            else
                if( k==1 & ~exist( subdir, 'dir' ) )
                    system( sprintf( 'mkdir %s', subdir ) );
                end

                imC = im(y1:y2,x1:x2, :); % crop
                imwrite( imC, sprintf( '%s/crop_%s', subdir, d{k}) );
            end
        end
    end
end

