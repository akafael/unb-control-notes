%% Exame Final Intro Controle

clc
close all

%% q1
T1 = tf([1],[1 1 1])
time5p = 3/(1/2)
%step(T)

RESPOSTA1 = time5p+4

%% q2
T2 = tf([1],[1 4 0])

b = 1
a = 4
mp = .25
sq_e = (log(mp))^2/ (pi^2 + (log(mp))^2)
K = a^2/(4*b*sq_e)

wd = sqrt(K*b - (a/2)^2)
theta = acos(sqrt(sq_e))

timeRise = (pi - theta)/wd
T2mf = T2*K/(1+T2*K)

RESPOSTA2 = timeRise*1000

%% q3
b = 1
a = 0.2
T3 = tf([b],[1 a 0])

tp = 31.4
mp = exp(-a*tp/2)
sq_e = (log(mp))^2/ (pi^2 + (log(mp))^2)
K = a^2/(4*b*sq_e)
T3mf = T3*K/(1+T3*K)

RESPOSTA3 = mp*100

%% q4
b = 10
a = 10
T4 = tf([b],[1 a 0])
err = 0.05
kp = 1/err

K = kp
T4mf = T4*K/(1+K*T4)
tp = pi/sqrt(K*b - a^2/4)

RESPOSTA4 = tp*1000

%% Q6
T6 = tf([1],[1 6 2 0])

err = 0.1
kp = 1/err

