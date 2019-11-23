%% Study

clc
close all

% Transfer Function
%G = tf(10*[1 .4 1],[1 .8 9 0])
%G = tf([1 .5],[1 1 0 1])
T = [3 2 1]
G = tf(10,[1 0 0])*tf([1 .5],[1 2])*tf(1,[1 10])

% Freq Eval

figure;
%bode(G)

hold on;
nyquist(G)
