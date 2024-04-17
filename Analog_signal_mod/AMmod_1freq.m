% Time vector
f_sample = 5000;
t = 0:1/f_sample:0.5-1/f_sample;

% Parameters
f_carrier = 200;
f_message = 10;
amp_carrier = 1;
mod_indices = [0.5, 1, 1.5];

for mod_indice = mod_indices
    amp_mod = amp_carrier.*mod_indice;
    message = amp_mod*cos(2*pi*f_message*t);

    %       Modulation
    am_mod = (amp_carrier + message).*cos(2*pi*f_carrier*t);

    %       Demodulation
    am_demod = abs(hilbert(am_mod));

    %       Graph plot
    % Time domain
    figure;

    subplot(3, 1, 1)
    plot(t, message);
    title(['Message Signal, f_{message} = [', num2str(f_message), '] Hz']);
    xlabel('Time');
    ylabel('Amplitude');

    subplot(3, 1, 2);
    plot(t, am_mod);
    title(['AM Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz, Modulation Index = ', num2str(mod_indice)]);
    xlabel('Time');
    ylabel('Amplitude');

    subplot(3, 1, 3);
    plot(t, am_demod);
    title('AM Demodulated Signal');
    xlabel('Time');
    ylabel('Amplitude');

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
    fft_am_mod = fftshift(abs(fft(am_mod)));
    plot(freq, fft_am_mod);
    title(['Spectrum of AM Modulated Signal, f_{carrier} = ', num2str(f_carrier), 'Hz, Modulation Index = ', num2str(mod_indice)]);
    xlabel('Frequency');
    ylabel('Magnitude');
    xlim([-f_carrier*2 f_carrier*2]);
    %ylim([-1 max(fft_message)]);

    subplot(3, 1, 3);
    fft_am_demod = fftshift(abs(fft(am_demod)));
    plot(freq, fft_am_demod);
    title('Spectrum of Demodulated Signal');
    xlabel('Frequency');
    ylabel('Magnitude');
    xlim([-max(f_message)*5 max(f_message)*5]);
    %ylim([-1 max(fft_message)]);
end






