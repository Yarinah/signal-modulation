% Time vector
f_sample = 5000;
t = 0:1/f_sample:0.5-1/f_sample;

% Parameters
f_carrier = 200;
f_message = 10;

carrier = cos(2*pi*f_carrier*t);
message = cos(2*pi*f_message*t);


%       Modulation
dsb_mod = carrier.*message;

%       Demodulation
dsb_demod = carrier.*dsb_mod;
f_cutoff = max(f_message)*2;
dsb_demod_filt = lowpass(dsb_demod, f_cutoff, f_sample);

%       Graphs plot
% Time domain
figure;
subplot(3, 1, 1);
plot(t, message);
title(['Message Signal, f_{message} = [', num2str(f_message), '] Hz']);
xlabel('Time')
ylabel('Amplitude');

subplot(3, 1, 2);
plot(t, dsb_mod, 'b', t, message, 'r--');
title(['DSB Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz']);
xlabel('Time');
ylabel('Amplitude');
legend('Modulated Signal', 'Original Signal');

subplot(3,1,3);
plot(t, dsb_demod_filt);
title('Demodulated Signal');
xlabel('Time');
ylabel('Amplitude');

% Frequency domain
freq = (-length(t)/2:length(t)/2-1)*(f_sample/length(t));
figure;

subplot(3,1,1);
fft_message = fftshift(abs(fft(message)));
plot(freq, fft_message);
title(['Spectrum of Message Signal, f_{message} = [', num2str(f_message), '] Hz']);
xlabel('Frequency');
ylabel('|M|');
xlim([-max(f_message)*5 max(f_message)*5]);
ylim([-1 max(fft_message)]);

subplot(3,1,2);
fft_dsb = fftshift(abs(fft(dsb_mod)));
plot(freq, fft_dsb);
title(['Spectrum of DSB Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz']);
xlabel('Frequency');
ylabel('|DSB|');
xlim([-f_carrier*2 f_carrier*2]);
ylim([-1 max(fft_message)]);

subplot(3, 1, 3);
fft_dsb_demod_filt = fftshift(abs(fft(dsb_demod_filt)));
plot(freq, fft_dsb_demod_filt);
title('Spectrum of Demodulated Signal (filterd)');
xlabel('Frequency');
ylabel('|Demod|');
xlim([-max(f_message)*5 max(f_message)*5]);
ylim([-1 max(fft_message)]);




