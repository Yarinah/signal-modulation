% Time vector
f_sample = 10000;
bit_duration = 1;
t = 0:1/f_sample:bit_duration-1/f_sample;

% Parameters
num_of_bytes = 2;
f_carrier_1 = 2;
f_carrier_0 = 5;

%data = [0, 1, 1, 0, 1, 0, 0, 1];
data = randi([0 1], 1, (8*num_of_bytes));
bit_period = f_sample/length(data);

%       Modulation
fsk_signal = [];
for bit = data
    if bit == 1
        fsk_signal = [fsk_signal cos(2*pi*f_carrier_1*t)];
    else
        fsk_signal = [fsk_signal cos(2*pi*f_carrier_0*t)];
    end
end

%       Demodulation
fsk_demod = [];
for k = 1:(8*num_of_bytes)
    % Extracting one bit duration from the modulated signal
    bit_data_signal = fsk_signal((k-1)*length(t)+1:k*length(t));

    % Correlating with cosine of both frequencies
    corr_1 = sum(bit_data_signal .* cos(2*pi*f_carrier_1*t));
    corr_0 = sum(bit_data_signal .* cos(2*pi*f_carrier_0*t));

    % Decision making
    if corr_1 > corr_0
        fsk_demod = [fsk_demod 1];
    else
        fsk_demod = [fsk_demod 0];
    end
end

%       Grapg plot
figure;
subplot(3,1,1);
stairs(t(1:length(data)), data, 'LineWidth', 2);
title('Original Data');
xlim([0, length(data)/f_sample])
ylim([-0.2 1.2]);

subplot(3,1,2);
plot(fsk_signal, 'LineWidth', 2);
title(['FSK Modulated Signal, f_{carrier1} = ', num2str(f_carrier_1), 'Hz, f_{carrier0} = ', num2str(f_carrier_0), 'Hz']);
xlim([0, length(data)*f_sample])
ylim([-1.2 1.2]);

subplot(3,1,3);
stairs(t(1:length(fsk_demod)), fsk_demod, 'LineWidth', 2);
title('Demodulated Data');
xlim([0, length(data)/f_sample])
ylim([-0.2 1.2]);





