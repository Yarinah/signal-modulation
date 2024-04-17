% Time vector
f_sample = 10000;
bit_duration = 1;
t = 0:1/f_sample:bit_duration-1/f_sample; % Duration on 1 bit

% Parameters
num_of_bytes = 2;
f_carrier = 10;

%data = [0, 1, 0, 0, 1, 0, 1, 1];
%data = [0, 1, 0, 1, 1, 1, 1, 1];
%data = randi([0 1], 1, (8*num_of_bytes));
data = grayCodeRandomizer(num_of_bytes);
%data = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ];



%       Modulation
data_pairs = reshape(data, 2, []);
phase_data = zeros(1, length(data_pairs));
% Phase mapping: 00 -> 45 degrees, 01 -> 135 degrees, 11 -> 225 degrees, 10 -> 315 degrees
for data_index = 1:length(data_pairs)
    if isequal(data_pairs(:,data_index), [0;0])
        phase_data(data_index) = pi/4;
    elseif isequal(data_pairs(:,data_index), [0;1])
        phase_data(data_index) = 3*pi/4;
    elseif isequal(data_pairs(:,data_index), [1;1])
        phase_data(data_index) = 5*pi/4;
    else % [1;0]
        phase_data(data_index) = 7*pi/4;
    end
end
% Signal build
qpsk_signal = [];
for phase = phase_data
    qpsk_signal = [qpsk_signal cos(2*pi*f_carrier*t + phase)];
end


carrier1bit = cos(2*pi*f_carrier*t);
carrier = repmat(carrier1bit, 1, 8*num_of_bytes);

%       Demodulation
% Assuming perfect phase synchronization
%reci_p = [];
reci_p2 = [];
for phase_index = 1:length(phase_data)
    phase_segment = qpsk_signal(((phase_index-1)*f_sample + 1):(phase_index*f_sample));
    carrier_segment = carrier(((phase_index-1)*f_sample + 1):(phase_index*f_sample));
    c_p = atan2(imag(hilbert(carrier_segment)), carrier_segment);
    p_p = atan2(imag(hilbert(phase_segment)), phase_segment);
    reci_p2 = [reci_p2 unwrap(p_p - c_p)];

end

qpsk_demod = zeros(1, length(data));
%new_reci = [reci_p2(2000) reci_p2(12000) reci_p2(22000) reci_p2(32000)];
new_reci = zeros(length(reci_p2)/f_sample);
for i = 1:(length(reci_p2)/f_sample)
    new_reci(i) = reci_p2(f_sample*(i-0.5));
end


for i = 1:length(new_reci)
    if new_reci(i) < 0
        new_reci(i) = new_reci(i) + 2*pi;
    end
    if new_reci(i) > 0 && new_reci(i) < pi/2
        qpsk_demod(2*i-1:2*i) = [0 0];
    elseif new_reci(i) > pi/2 && new_reci(i) < pi
        qpsk_demod(2*i-1:2*i) = [0 1];
    elseif new_reci(i) > pi && new_reci(i) < 3*pi/2
        qpsk_demod(2*i-1:2*i) = [1 1];
    else % [1 0]
        qpsk_demod(2*i-1:2*i) = [1 0];
    end
end



%       Graphs plot
% Time domain
figure;
subplot(3,1,1);
stairs(t(1:length(data)), data, 'LineWidth', 2);
title('Original Data');
xlim([0, length(data)/f_sample])
ylim([-0.2 1.2]);

subplot(3,1,2);
plot(qpsk_signal);
title(['QPSK Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz']);
xlim([0, length(phase_data)*f_sample])
ylim([-1.2 1.2]);

subplot(3,1,3);
stairs(t(1:length(data)), qpsk_demod, 'LineWidth', 2);
title('Demodulated Data');
xlim([0, length(data)/f_sample])
ylim([-0.2 1.2]);







