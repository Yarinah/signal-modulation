% Parameters
num_of_bytes = 2;
f_carrier = 5;
amp_1 = 1;
amp_0 = 0.5;

data_rate = 1;
%data = [1, 1, 0, 1, 1, 0, 0, 1];
data = randi([0 1], 1, (8*num_of_bytes));

% Time vector
f_sample = 1000;
total_duration = length(data) / data_rate;
t = 0:1/f_sample:total_duration-1/f_sample;

%       Modulation
samp_per_bit = f_sample / data_rate;
data_samp = repelem(data, samp_per_bit);
carrier = cos(2*pi*f_carrier*t(1:length(data_samp)));
for i_data_samp = 1:length(data_samp)
    if data_samp(i_data_samp) == 1
        data_samp(i_data_samp) = amp_1;
    else
        data_samp(i_data_samp) = amp_0;
    end
end
ask_signal = data_samp .* carrier;

%       Demodulation
% Assuming coherent detection where the carrier phase and frequency are known
ask_demod = ask_signal .* (2*carrier(1:length(ask_signal)));
ask_demod_filt = lowpass(ask_demod, f_carrier/2, f_sample);

% Decision making
ask_demod_filt = ask_demod_filt > (amp_0 + amp_1)/2; % Simple threshold decision
ask_demod_filt = repelem(mean(reshape(ask_demod_filt, samp_per_bit, [])), samp_per_bit);

%       Graphs plot
% Time domain
figure;
subplot(3,1,1);
stairs(t(1:length(data))*f_sample, data, 'LineWidth', 2);
title('Original Data');
xlim([0, length(data)])
ylim([-0.2 1.2]);

subplot(3,1,2);
plot(t(1:length(ask_signal)), ask_signal, 'LineWidth', 2);
title(['ASK Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz']);
ylim([-2 2]);

subplot(3,1,3);
stairs(t(1:length(ask_demod_filt)), ask_demod_filt, 'LineWidth', 2);
title('Demodulated Data');
ylim([-0.2 1.2]);






