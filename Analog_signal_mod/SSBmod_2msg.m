% Time vector
f_sample = 5000;
t = 0:1/f_sample:0.5-1/f_sample;

% Parameters
f_carrier = 200;
f_message = 10;
f_message2 = 20;

carrier = cos(2*pi*f_carrier*t);
message = cos(2*pi*f_message*t);
message2 = cos(2*pi*f_message2*t);

%       Modulation
hil_message = imag(hilbert(message2));
ssb_mod = message.*cos(2*pi*f_carrier*t) - hil_message.*sin(2*pi*f_carrier*t);

%       Demodolation
f_cutoff = max(f_message)*2;
ssb_demod_cos = ssb_mod.*cos(2*pi*f_carrier*t);
ssb_demod_cos_filt = lowpass(ssb_demod_cos, f_cutoff, f_sample);

ssb_demod_sin = ssb_mod.*sin(2*pi*f_carrier*t);
ssb_demod_sin_filt = lowpass(ssb_demod_sin, f_cutoff, f_sample);

%       Graphs plot
% Time domain
figure;
subplot(3, 2, 1);
plot(t, message);
title(['Message Signal 1, f_{message} = [', num2str(f_message), '] Hz']);
xlabel('Time')
ylabel('Amplitude');

subplot(3, 2, 2);
plot(t, message2);
title(['Message Signal 2, f_{message} = [', num2str(f_message2), '] Hz']);
xlabel('Time')
ylabel('Amplitude');

subplot(3, 2, [3 4]);
plot(t, ssb_mod);
title(['SSB Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz']);
xlabel('Time');
ylabel('Amplitude');

subplot(3, 2, 5);
plot(t, ssb_demod_cos_filt);
title('Demodulated Signal');
xlabel('Time');
ylabel('Amplitude');

subplot(3, 2, 6);
plot(t, ssb_demod_sin_filt);
title('Demodulated Signal 2');
xlabel('Time');
ylabel('Amplitude');

% Frequency domain
freq = (-length(t)/2:length(t)/2-1)*(f_sample/length(t));
figure;

subplot(3, 2, 1);
fft_message = fftshift(abs(fft(message)));
plot(freq, fft_message);
title(['Spectrum of Message Signal 1, f_{message} = [', num2str(f_message), '] Hz']);
xlabel('Frequency');
ylabel('|M|');
xlim([-max(f_message)*5 max(f_message)*5]);
ylim([-1 max(fft_message)]);

subplot(3, 2, 2);
fft_message2 = fftshift(abs(fft(message2)));
plot(freq, fft_message2);
title(['Spectrum of Message Signal 2, f_{message} = [', num2str(f_message2), '] Hz']);
xlabel('Frequency');
ylabel('|M|');
xlim([-max(f_message)*5 max(f_message)*5]);
ylim([-1 max(fft_message)]);

subplot(3, 2, [3 4]);
fft_ssb = fftshift(abs(fft(ssb_mod)));
plot(freq, fft_ssb);
title(['Spectrum of SSB Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz']);
xlabel('Frequency');
ylabel('|SSB|');
xlim([-f_carrier*2 f_carrier*2]);
ylim([-1 max(fft_message)]);

subplot(3, 2, 5);
fft_ssb_demod_cos_filt = fftshift(abs(fft(ssb_demod_cos_filt)));
plot(freq, fft_ssb_demod_cos_filt);
title('Spectrum of Demodulated Signal 1 (filtered)');
xlabel('Frequency');
ylabel('|Demod|');
xlim([-max(f_message)*5 max(f_message)*5]);
ylim([-1 max(fft_message)]);

subplot(3, 2, 6);
fft_ssb_demod_sin_filt = fftshift(abs(fft(ssb_demod_sin_filt)));
plot(freq, fft_ssb_demod_sin_filt);
title('Spectrum of Demodulated Signal 2 (filtered)');
xlabel('Frequency');
ylabel('|Demod|');
xlim([-max(f_message)*5 max(f_message)*5]);
ylim([-1 max(fft_message)]);



