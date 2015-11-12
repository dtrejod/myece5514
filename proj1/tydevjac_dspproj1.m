% DSP Project 1
% By: Tyler Olivieri, Devin Trejo, Jacob Esworthy
% Publish Date: October 21, 2015

%%

% Clear workspace
%
clear; close all; clc;

% -----------------
% - IMPORT SIGNAL - 
% -----------------
% Generate the varying sampled signal. Imports the following variables:
%     - x        : Original Signal (constant sample rate)
%     - t        : Original Signal (constant sampling rates) time vector
%     - y        : Variable Sampled Signal (varying sampling rate)
%     - t_resamp : Variable Sampled Signal (varying sampling rate) 
%                  time vector
run('createSignal.m')

% ----------------------
% - Interpolate SIGNAL - 
% ----------------------
% Before we can interpolate we define a high sample frequency we know
% will capture our frequency content. 
%
fs = 8000;

% Define a time vector using sample signal upsampled time vector
%
startT = t_resamp(1);
stopT = t_resamp(length(t_resamp));
t_inter = startT:1/fs:stopT; % Interpolate Time Vector

% Use Interpolation to resample the signal
% Function Input 'vq = interp1(x,v,xq,method)':
%     - x      : Sample interval points 
%     - v      : Sample values 
%     - xq     : New Sample Interval Point
%     - method : Interperlation Method. 
splineY = interp1(t_resamp, y, t_inter, 'spline');
linearY = interp1(t_resamp, y, t_inter, 'linear'); 

% Get the legnth of the Signals
%
xL = length(x);
yL = length(y);
splineL = length(splineY);
linearL = length(linearY);

% Find number of sample points we need to capture an accurate FFT
%
NFFT = 2^nextpow2(xL);
NFFT2 = 2^nextpow2(yL);
NFFT3 = 2^nextpow2(splineL);
NFFT4 = 2^nextpow2(linearL);

% Find fourier Transform
%
xFFT = fft(x,NFFT)/xL;
yFFT = fft(y, NFFT2)/yL;
splineFFT = fft(splineY, NFFT3)/splineL; 
linearFFT = fft(linearY, NFFT4)/linearL;

% Truncate to a signal sided fft
%
xFFT = 2*abs(xFFT(1:NFFT/2+1));
yFFT = 2*abs(yFFT(1:NFFT2/2+1));
splineFFT = 2*abs(splineFFT(1:NFFT3/2+1));
linearFFT = 2*abs(linearFFT(1:NFFT4/2+1));

% Define frequency vector
%
fsX = 1/(t(2)-t(1));
f = fsX/2*linspace(0,1,NFFT/2+1);
f3 = fs/2*linspace(0,1,NFFT3/2+1);
f4 = fs/2*linspace(0,1,NFFT4/2+1);

% ---------------
% - PLOT THINGS -
% ---------------
% Plot original signal
%
figure(1);
subplot(2,1,1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Volts (V)');
ylim([ceil(min(x)) ceil(max(x))]);
axis1 = axis();
grid on
subplot(2,1,2);
plot(t_resamp, y, 'color', [1 .4 0]);
title('Variable Sampled Signal');
xlabel('Time (s)');
ylabel('Volts (V)');
axis(axis1);
grid on

% Plot Interpreted Signal
%
figure(2);
subplot(2,1,1);
plot(t_inter, splineY);
title('Resampled Signal using Spline Inter');
xlabel('Time (s)');
ylabel('Volts (V)');
axis(axis1);
grid on
subplot(2,1,2);
plot(t_inter, linearY, 'color', [1 .4 0]);
title('Resampled Signal using Linear Inter');
xlabel('Time (s)');
ylabel('Volts (V)');
axis(axis1);
grid on

% Plot Interpreted Signal Close up overlay
%
figure(3);
plot(t_resamp, y, 'LineWidth', 2);
hold on
plot(t_inter, splineY, t_inter, linearY);
title(['Comparison of Varying Sample Signal and Interpolated Signals ' ...
    '(Zoomed)']);
xlabel('Time (s)');
ylabel('Volts (V)');
legend('Variable Sampled Signal', 'Intr u/ Spline', 'Intr u/ Linear');
%axis(axis1);
axis([1 1.8 -0.5 0.5]);
grid on

% Plot Fourier Transform of all our siganls
%
figure(4);
plot(f, xFFT);
xlim([0 50]);
axis2 = axis();
grid on
xlabel('freq (Hz)');
ylabel('Magnitude')
title('FFT of Original Signal');

figure()
plot(yFFT);
axis3 = axis();
grid on
xlabel('freq (Hz)');
ylabel('Magnitude')
title('FFT of Variable Sampled Signal')

figure()
plot(f3, splineFFT);
axis(axis2);
grid on
xlabel('freq (Hz)');
ylabel('Magnitude')
title('FFT of Spline Inter')

figure()
plot(f4, linearFFT);
axis(axis2);
grid on
xlabel('freq (Hz)');
ylabel('Magnitude')
title('FFT of Linear Inter');