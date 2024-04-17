% Parameters
num_of_bytes = 2;
f_carrier = 1;

data_rate = 1;
%data = [0, 1, 1, 0, 1, 0, 0, 1];
data = randi([0 1], 1, (8*num_of_bytes));

% Time vector
f_sample = 1000;
total_duration = length(data) / data_rate;
t = 0:1/f_sample:total_duration-1/f_sample;

%       Modulation
samp_per_bit = f_sample / data_rate;
data_samp = 2*repelem(data, samp_per_bit)-1;
carrier = cos(2*pi*f_carrier*t(1:length(data_samp)));
bpsk_mod = data_samp .* carrier;


%       Demodulation
bpsk_demod = bpsk_mod .* carrier;
% Decision making
bpsk_demod = bpsk_demod > 0;

%       Graphs plot
% Time domain
figure;
subplot(3,1,1);
stairs(t(1:length(data))*f_sample, data, 'LineWidth', 2);
title('Original Data');
xlim([0, length(data)])
ylim([-0.2 1.2]);

subplot(3,1,2);
plot(t(1:length(bpsk_mod)), bpsk_mod, 'LineWidth', 2);
title(['BPSK Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz']);
xlim([0, length(data)])
ylim([-1.2 1.2]);

%subplot(3,1,3);
%stairs(t(1:length(bpsk_demod)), bpsk_demod, 'LineWidth', 2);
%title('Demodulated Signal');

t_demod = [t(1:length(bpsk_demod)), t(length(bpsk_demod))+1/f_sample];
subplot(3,1,3);
stairs(t_demod, [bpsk_demod, bpsk_demod(end)], 'LineWidth', 2); % Append the last bit value to ensure it's plotted
title('Demodulated Signal');
xlim([0, length(data)])
ylim([-0.2 1.2]);












