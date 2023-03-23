% This function generates a sinusoid of length N for a specified frequency, 
% phase, and amplitude.
%
function[f] = evaluateModel( model, N )

freq  = model(1);
phase = model(2);
amp   = model(3);

t = [0:N-1]; 
f = amp .* cos( freq*2*pi/N*t + phase );
