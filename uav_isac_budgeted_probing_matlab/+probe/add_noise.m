function Z = add_noise(Z, snr_dB, cfg)
%ADD_NOISE Add AWGN to energy-domain observation
signal_power = mean(Z(:).^2);
if signal_power == 0
    signal_power = 1;
end
snr_lin = 10.^(snr_dB/10);
noise_power = signal_power ./ snr_lin;
noise = sqrt(noise_power) .* randn(size(Z));
Z = Z + noise;
end
