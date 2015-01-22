% compute the RMS error between the current model and the data. This is
% used by the non-linear optimization in modelFit.m
%

function[err] = errorFunc( model, dat )
N   = length(dat);
f   = evaluateModel( model, N );
err = sum( (f - dat).^2 );
