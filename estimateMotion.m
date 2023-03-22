%%% Estimate motion for a series of JPG images in 'dirname'

function[motion_x,motion_y] = estimateMotion( dirname )

GRADIENT_THRESHOLD = 8; % ignore all pixels with gradient less than this
DISPLAY = 0; % display estimated flow fields

% load frames
d1 = dir( sprintf( '%s/*.jpg', dirname ) );
d2 = dir( sprintf( '%s/*.jpeg', dirname ) );
d3 = dir( sprintf( '%s/*.JPG', dirname ) );
d4 = dir( sprintf( '%s/*.JPEG', dirname ) );
d  = [d1 ; d2 ; d3 ; d4];
d  = unique( {d(:).name} );

N = numel(d);
fprintf( 'loading %d frames...\n', N );
c = 1;
for k = 1 : 1 : N
    im = imread( sprintf('%s/%s', dirname, d{k} ) );
    if( k == 1 )
        scale = 60/max(size(im)); % set scale (max dim = 60)
    end
    im = imresize( im, scale, 'bicubic' );
    f(c).orig = im;
    f(c).im = double( rgb2gray(im) );
    c = c + 1;
end
[ydim,xdim] = size( f(1).im );


% compute motion
fprintf( 'computing motion...\n' );
taps = 7;
blur = [1 6 15 20 15 6 1];
blur = blur / sum(blur);
s    = 1; % sub-sample spatially by this amount
N    = numel(f) - (taps-1);
Vx   = zeros( ydim/s, xdim/s, N );
Vy   = zeros( ydim/s, xdim/s, N );
for k = 1 : 1 : N
    [fx,fy,ft] = space_time_deriv( f(k:k+(taps-1)) );
    fx2  = conv2( conv2( fx .* fx, blur', 'same' ), blur, 'same' );
    fy2  = conv2( conv2( fy .* fy, blur', 'same' ), blur, 'same' );
    fxy  = conv2( conv2( fx .* fy, blur', 'same' ), blur, 'same' );
    fxt  = conv2( conv2( fx .* ft, blur', 'same' ), blur, 'same' );
    fyt  = conv2( conv2( fy .* ft, blur', 'same' ), blur, 'same' );
    grad = sqrt( fx.^2 + fy.^2 );
    grad( :, 1:5 ) = 0;
    grad( 1:5, : ) = 0;
    grad( :, xdim-4:xdim ) = 0;
    grad( ydim-4:ydim, : ) = 0;
    
    % compute optical flow
    cx = 1;
    bad = 0;
    for x = 1 : s : xdim
        cy = 1;
        for y = 1 : s : ydim
            M = [fx2(y,x) fxy(y,x) ; fxy(y,x) fy2(y,x)];
            b = [fxt(y,x) ; fyt(y,x)];
            if( cond(M)>1e2 | grad(y,x)<GRADIENT_THRESHOLD )
                Vx(cy,cx,k) = 0;
                Vy(cy,cx,k) = 0;
                bad = bad + 1;
            else
                v = inv(M) * b;
                Vx(cy,cx,k) = v(1);
                Vy(cy,cx,k) = v(2);
            end
            cy = cy + 1;
        end
        cx = cx + 1;
    end
    if( bad/(xdim*ydim) == 1 )
        fprintf( 'WARNING on frame %d: no velocity estimate\n',k );
    end
end

% visualize motion field
taps = 13;
blur = ones(1,taps);
blur = blur / sum(blur);

if( DISPLAY )
    figure(1);
    for k = 1 : N-taps
        vx = zeros(size(Vx,1),size(Vx,2));
        vy = zeros(size(Vy,1),size(Vy,2));
        Vx2 = Vx(:,:,k:k+taps-1);
        Vy2 = Vy(:,:,k:k+taps-1);
        % temporal average
        for j = 1 : length(blur)
            vx = vx + blur(j)*Vx2(:,:,j);
            vy = vy + blur(j)*Vy2(:,:,j);
        end
        % display
        imagesc( f(k+floor(taps/2)).orig ); axis image off; colormap gray
        [xramp,yramp] = meshgrid( [1:s:xdim], [1:s:ydim] );
        hold on;
        ind = find( vx==0 & vy==0 );
        xramp(ind) = 0;
        yramp(ind) = 0;
        h = quiver( xramp, yramp, 20*vx, 20*vy, 0 );
        set( h, 'Color', 'r', 'LineWidth', 1 );
        hold off;
        drawnow;
    end
end


% compute average horizontal and vertical motion
c = 1;
for k = 1 : N-taps
    vx = zeros(size(Vx,1),size(Vx,2));
    vy = zeros(size(Vy,1),size(Vy,2));
    Vx2 = Vx(:,:,k:k+taps-1);
    Vy2 = Vy(:,:,k:k+taps-1);
    % temporal average
    for j = 1 : length(blur)
        vx = vx + blur(j)*Vx2(:,:,j);
        vy = vy + blur(j)*Vy2(:,:,j);
    end
    indx = find( abs(vx) > eps );
    indy = find( abs(vy) > eps );
    motion_x(c) = 1/scale * mean( vx(indx) );
    motion_y(c) = -1/scale * mean( vy(indy) );
    c = c + 1;
end

