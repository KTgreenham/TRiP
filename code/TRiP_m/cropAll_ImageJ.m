% Crop all images in a specified directory
%
% Input <dirName> should be the directory name containing the input images
%
% Input <fn> should be a plain text file where each line has the
% following format:
%     directoryName y1 y2 x1 x2
%
% This function will create a cropped version of each image in <dirName>
% and write it to <directoryName>
%
% e.g., cropAll( '../uncroppedImages', 'cropdata.txt');
%

function[] = cropAll( dirName, fn )

% open input file (fn)
fd = fopen( fn, 'r' );
if( fd == -1 )
    fprintf( 'File %s does not exist... aborting\n' );
    return;
end
fclose(fd);

% read dirName
% d1 = dir( sprintf( '%s/*.JPG', dirName ) );
% d2 = dir( sprintf( '%s/*.jpg', dirName ) );
% d  = [d1 ; d2];
d = dir( sprintf( '%s/*.JPG', dirName ) );

fprintf( 'Found %d images.\n', numel(d) );


% begin...
for k = 1 : numel(d)
    fprintf( 'processing %d/%d...\n', k, numel(d) );
    im = imread( sprintf( '%s/%s', dirName, d(k).name ) );
    fd = fopen( fn, 'r' );
    while(1)
        line = fgetl( fd );
        if( line == -1 )
            fclose(fd);
            break;
        end
     
       
        % parse single line of input file (fn)
        [subdir,tail] = strtok( line );
        [y1,tail] = strtok( tail );
        [y2,tail] = strtok( tail );
        [x1,tail] = strtok( tail );
        [x2,tail] = strtok( tail );
        y1 = str2num(y1);
        y2 = str2num(y2);
        x1 = str2num(x1);
        x2 = str2num(x2);
        
        % load, crop, and write
        if( exist( sprintf('%s/crop_%s',subdir,d(k).name), 'file' ) )
            fprintf( 'skipping %s/crop_%s.\n', subdir, d(k).name );
        else
            if( k==1 & ~exist( subdir, 'dir' ) )
                system( sprintf( 'mkdir %s', subdir ) );
            end
            %transpon imageJ files
y3 = y2;
y4 = y2 +x2;
x3 = y1;
x4 = y1+ x1;
            imC = im(y3:y4,x3:x4, :); % crop
            imwrite( imC, sprintf( '%s/crop_%s', subdir, d(k).name) );
        end
    end
end
