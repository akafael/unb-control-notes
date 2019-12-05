%% Freq Control

clear
clc

% Generic Transfer Function
syms s;
a=1;
b=5;
G = tf(1,[1 a])*tf(1,[1 b])        % Transfer function
sG = 1/((s + a)*(s + b))           % Symbolic

% Input Signal ( Unitary Ramp )
sR = 1/(s^2)                       % Symbolic
R = tf(1,[1 0 0])                  % Transfer Function

% Project Requirements
MaxError = 0.05
GainMarginDB = 10
PhaseMarginDeg = 60
PhaseMarginRad = degtorad(PhaseMarginDeg*1.1) % Convert and add safety margin

% Plant Stead State Error
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
Gi = tf(Kc,[1 0])           % Transfer Function

% Check if the error is lower then Max Error Required
assert( MaxError <= subs(simplify(s*sR*(1/(1+sG*Kc*sGi))),0),...
       'Error: Stead State error greater then required')

%% Lead Lag Controler
[Gm,Pm,Wcg,Wcp] = margin(G*Gi);
Tlag = 10/Wcg
phi = sin(PhaseMarginRad);
alpha = (1-phi)/(1+phi)
beta = 1/alpha
Wlead = Wcg*10^(-20*log10(Gm)/20)
Tlead = 1/(alpha*Wlead)
Gleag = tf([Tlag 1],[beta*Tlag 1])
Gleadlag = tf([Tlead 1],[alpha*Tlead 1])*tf([Tlag 1],[beta*Tlag 1])

bode(G*Gi);
hold on;
margin(G*Gi*Gleadlag)
hold off;

% Check Requirements
[Gm2,Pm2,Wcg2,Wcp2] = margin(Gi*Gleadlag*G);
assert( 20*log10(Gm2) > GainMarginDB, 'Error: Gain margin smaller than Required!' )
assert( Pm2 > PhaseMarginDeg , 'Error: Phase margin smaller than Required!' )


%% Lead Controler (Not Working)
%PmDesired = 60
%dPm = -180 + PmDesired + 5

% Find point with pPm phase:
%w = 1e-1:1e-2:1e2;
%[m,f] = bode(Gi*G,w);
%dGain = max(m(f<dPm));
%wdPm = min(w(f<dPm));

%alphaLag = 10^(dGain/20)
%Tlag = 1/(alphaLag*wdPm)
%Glag = tf([alphaLag*Tlag 1],[Tlag 1])

%[Gm,Pm,Wcg,Wcp] = margin(G*Gi);
%assert(Pm>PmDesired)
