%% Frequency Project

clear
close all

syms s;

% Plant
a = 1;
b = 5 
G = tf(1,[1 a])*tf(1,[1 b])        % Transfer Function
sG = 1/((s + a)*(s + b))           % Symbolic

% Input Signal ( Unitary Ramp )
sR = 1/(s^2)                       % Symbolic
R = tf(1,[1 0 0])                  % Transfer Function

% Project Requirements
MaxError = 0.05
GainMarginDB = 10
PhaseMarginRad = degtorad(60+5)

% Error Evaluation Plant
sSteadErrorExpr = simplify(s*sR*(1/(1+sG)))
try
   SteadError = subs(sSteadErrorExpr,s,0)
catch ME
   %disp(ME)
   SteadError = Inf
end

% Fix Stead State Error
sGi = 1/s                  % Symbolic
sSteadErrorExpr = simplify((s*sR)/(1+(sG*sGi)))
Kc = double((subs(sSteadErrorExpr,s,0))/MaxError)
Gi = tf(1,[1 0])           % Transfer Function

%% Lag
phi = sin(PhaseMarginRad);
alpha = (1-phi)/(1+phi)
Tlag = 1;
Glag = alpha*tf([Tlag 1],[alpha*Tlag 1])

% Graphical Evaluation
figure;
hold on;
grid on;
bodeplot(G*Gi);
margin(G*Gi*Glag);
legend('Gi','Glag')
hold off;

%% Lead Lag
[Gm,Pm,Wcg,Wcp] = margin(G*Gi);
Tlag = 10/Wcg
phi = sin(PhaseMarginRad);
alpha = (1-phi)/(1+phi)
beta = 1/alpha
%Tlead = (1/(alpha*Wcg))*sqrt(abs((Gm^2-alpha^2)/(1-Gm^2)))
Tlead = 1/0.36 % TODO Find Correct Expression
Gleadlag = tf([Tlead 1],[alpha*Tlead 1])*tf([Tlag 1],[beta*Tlag 1])

% Graphical Evaluation
figure;
hold on;
grid on;
bodeplot(G*Gi);
margin(G*Gi*Gleadlag);
legend('Gi','Gleadlag')
hold off;

%% PID
Wa = 1
Wb = 2
Kp = Kc
Gpid = tf(Kp,[1 0])*tf([1/Wa 1],1)*tf([1/Wb 1],1)
Gpid.Name = 'Gpid'
sGpid = (Kp/s)*(s/Wa +1)*(s/Wb +1);
[Gm,Pm,Wcg,Wcp] = margin(G*Gpid)

% Graphical Evaluation
figure;
hold on;
grid on;
bodeplot(G*Gi);
margin(G*Gpid);
legend('Gi','Gpid')
hold off;
