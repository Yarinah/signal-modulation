% Time vector
f_sample = 5000;
t = 0:1/f_sample:0.5-1/f_sample;

% Parameters
f_carrier = 200;
f_message = [87, 59, 101];
k_freq = 75;


message = 0;
for f_msg_index = 1:length(f_message)
    message = message + cos(2*pi*f_message(f_msg_index)*t);
end

%       Modulation
mod_message = fmmod(message, f_carrier, f_sample, k_freq);

%       Demodulation
demod_message = fmdemod(mod_message, f_carrier, f_sample, k_freq);

%       Graphs plot
% Time domain
figure;

subplot(3,1,1);
plot(t, message);
title(['Message Signal, f_{message} = [', num2str(f_message), '] Hz']);
xlabel('Time');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, mod_message, 'b', t, message,'r--');
title(['f_{carrier} = ', num2str(f_carrier), 'Hz, f_{k} = ', num2str(k_freq), 'Hz']);
xlabel('Time');
ylabel('Amplitude');
legend('Modulated message signal', 'Original message signal');

subplot(3,1,3);
plot(t, demod_message ,'b' ,t ,message ,'r--');
xlabel('Time (s)')
ylabel('Amplitude')
legend('Demodulated message signal', 'Original message signal')


% Frequency domain
freq = (-length(t)/2:length(t)/2-1)*(f_sample/length(t));
figure;

subplot(3, 1, 1)
fft_message = fftshift(abs(fft(message)));
plot(freq, fft_message);
title(['Spectrum of Message Signal, f_{message} = [', num2str(f_message), '] Hz']);
xlabel('Frequency');
ylabel('Magnitude');
xlim([-max(f_message)*5 max(f_message)*5]);
%ylim([-1 max(fft_message)]);


subplot(3, 1, 2);
fft_fm_mod = fftshift(abs(fft(mod_message)));
plot(freq, fft_fm_mod);
title(['Spectrum of FM Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz, f_{k} = ', num2str(k_freq), 'Hz']);
xlabel('Frequency');
ylabel('Magnitude');
xlim([-f_carrier*2 f_carrier*2]);
%ylim([-1 max(fft_message)]);

subplot(3, 1, 3);
fft_fm_demod = fftshift(abs(fft(demod_message)));
plot(freq, fft_fm_demod);
title('Spectrum of Demodulated Signal');
xlabel('Frequency');
ylabel('Magnitude');
xlim([-max(f_message)*5 max(f_message)*5]);
%ylim([-1 max(fft_message)]);


