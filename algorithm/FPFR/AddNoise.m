function noisyData = AddNoise(data, SNR)
%% 
noise = randn(size(data));
varS = var(data(:));
varN = varS / (10 ^ (SNR / 10));
stdN = sqrt(varN);
noisyData = data + stdN / std(noise(:)) * noise;
end