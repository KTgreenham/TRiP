%%%
%%% space_time_deriv(): compute space/time derivatives from an image seq.
%%%			stored in the following data structure:
%%%				f(1).time, f(2).time, ...
%%%			No fewer than 2 frames, no more than 7.
%%%
function[ fx, fy, ft ] = space_time_deriv( f )

N	= size( f, 2 );
dims	= size( f(1).im );

%%% DEFINE DERIVATIVE KERNELS (farid&simoncelli, 1997)
if( N == 2 )
	pre	= [0.5 0.5];
	deriv	= [-1 1];
elseif( N == 3 )
	pre	= [0.223755 0.552490 0.223755];
	deriv	= [-0.453014 0.0 0.453014];
elseif( N == 4 )
	pre	= [0.092645 0.407355 0.407355 0.092645];
	deriv	= [-0.236506 -0.267576 0.267576 0.236506];
elseif( N == 5 )
	pre	= [0.036420 0.248972 0.429217 0.248972 0.036420];
	deriv	= [-0.108415 -0.280353 0.0 0.280353 0.108415];
elseif( N == 6 )
	pre 	= [0.013846 0.135816 0.350337 0.350337 0.135816 0.01384];
	deriv	= [-0.046266 -0.203121 -0.158152 0.158152 0.203121 0.046266];
elseif( N == 7 )
	pre = [0.005165 0.068654 0.244794 0.362775 0.244794 0.068654 0.005165];
	deriv= [-0.018855 -0.123711 -0.195900 0.0 0.195900 0.123711 0.018855];
else
	warning( sprintf( 'No such filter size (N=%d)', N ) );
end

%%% SPACE/TIME DERIVATIVES
fdt	= zeros( dims );
fpt	= zeros( dims );
for i = 1 : N
   fdt = fdt + deriv(i)*f(i).im;
   fpt = fpt + pre(i)*f(i).im;
end

fx	= conv2( conv2( fpt, pre', 'same' ), deriv, 'same' );
fy	= conv2( conv2( fpt, pre, 'same' ), deriv', 'same' );
ft	= conv2( conv2( fdt, pre', 'same' ), pre, 'same' );

