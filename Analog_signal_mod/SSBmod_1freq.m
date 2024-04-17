% Time vector
f_sample = 5000;
t = 0:1/f_sample:0.5-1/f_sample;

% Parameters
f_carrier = 200;
f_message = 10;

carrier = cos(2*pi*f_carrier*t);
message = cos(2*pi*f_message*t);

%       Modulation
hil_message = imag(hilbert(message));
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
subplot(3, 1, 1);
plot(t, message);
title(['Message Signal, f_{message} = [', num2str(f_message), '] Hz']);
xlabel('Time')
ylabel('Amplitude');

subplot(3, 1, 2);
plot(t, ssb_mod, 'b', t, message, 'r--');
title(['SSB Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz']);
xlabel('Time');
ylabel('Amplitude');
legend('Modulated Signal', 'Original Signal');

subplot(3,1,3);
plot(t, ssb_demod_cos_filt);
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
fft_ssb = fftshift(abs(fft(ssb_mod)));
plot(freq, fft_ssb);
title(['Spectrum of SSB Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz']);
xlabel('Frequency');
ylabel('|SSB|');
xlim([-f_carrier*2 f_carrier*2]);
ylim([-1 max(fft_message)]);

subplot(3, 1, 3);
fft_ssb_demod_cos_filt = fftshift(abs(fft(ssb_demod_cos_filt)));
plot(freq, fft_ssb_demod_cos_filt);
title('Spectrum of Demodulated Signal (filtered)');
xlabel('Frequency');
ylabel('|Demod|');
xlim([-max(f_message)*5 max(f_message)*5]);
ylim([-1 max(fft_message)]);





