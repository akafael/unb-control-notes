%%

close all;
clear;

G = tf([1],[1 6 11 6])
[A,B,C,D] = tf2ss(G.num{1},G.den{1})

Mc = [B A*B A*A*B]
Mo = [C;C*A;C*A*A]

%% Solution 3
F1 = sym('F_1')
F2 = sym('F_2')
F3 = sym('F_3')
F = [F1 F2 F3]
L1 = sym('L_1')
L2 = sym('L_2')
L3 = sym('L_3')
L = [L1;L2;L3]
N = sym('N')
syms s;

%% Observer
Ao = A - L*C
Bo = B*N
Co = C
Do = D

% Find Observer Characteristic Equation
I = eye(size(Ao));
polyObserver = flip(coeffs(det(s*I-Ao),s))

% Chose Observer Desired Poles at 5 times original plant poles
polesObserverDesired = 5*roots(G.den{1})
polyObserverDesired = poly(polesObserverDesired)

% Solve to find desired L matrix
polyL = (polyObserver - polyObserverDesired)
[m,v] = equationsToMatrix(polyL,L);
nL = linsolve(m,v)

%% Plant + Estimated State Feedback
Ap = A - B*F - L*C
Bp = B*N
Cp = C
Dp = D

% Find Open Loop Characteristic Equation
I = eye(size(Ap));
polyMa = flip(coeffs(det(s*I-Ap),s))

% Apply L matrix for chosen observer dynamics
polyMa = subs(polyMa,L,nL)

% Ensure stead state error equals zero by placing one pole to zero
nF = F;
nF(end) = solve(polyMa(end),F(end))

% Closed Loop Space State Expression
Amf = A - B*nF - nL*C - B*N*C
Bmf = B*N
Cmf = C
Dmf = D

% Find Outer Loop Characteristic Equation
I = eye(size(Amf));
polyMf = flip(coeffs(det(s*I-Amf),s))

% Find Desired Poles
polesDesired = [complex(-1,-0),complex(-10,0),complex(-10,0)];
polyDesired = poly(polesDesired)

% Solve linear system to find desired gain matrix
polyF = (polyMf - polyDesired)
[m,v] = equationsToMatrix(polyF,[F(1:end-1) sym('N')])
x = linsolve(m,v)
nF(1:end-1) = x(1:end-1)
N = double(x(end))

% Replace any missing values
nF(end) = subs(nF(end),F(1:end-1),nF(1:end-1))

% Controled System
Ac = double(A - B*nF -nL*C - B*N*C)
Bc = double(B*N)
Cc = double(C)
Dc = double(D)
F = double(nF)
L = double(nL)

[num,den] = ss2tf(Ac,Bc,Cc,Dc);
Gc = tf(num,den)

%% Step Response Evaluation
hold on;
step(G)
step(Gc)
legend('G(s)','Gc(s)')
hold off;

%% Simulink
modelFileName = 'ss_project_observer';
% Run Simulation
sim(ss_project);