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
N = sym('N')
syms s;

% Open Loop State Space Expression
Ama = A - B*F
Bma = B*N
Cma = C
Dma = D

% Find Inner Loop Characteristic Equation
I = eye(size(Ama));
polyMa = flip(coeffs(det(s*I-Ama),s))

% Ensure stead state error equals zero by placing one pole to zero
F(end) = solve(polyMa(end),F(end))

% Closed Loop Space State Expression
Amf = A - B*F - B*N*C
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
polyK = (polyMf - polyDesired)
[m,v] = equationsToMatrix(polyK,[F(1:end-1) sym('N')]);
x = linsolve(m,v);
F(1:end-1) = x(1:end-1)
N = x(end)

% Controled System
Ac = double(A - B*F - B*N*C)
Bc = double(B*N)
Cc = double(C)
Dc = double(D)

[num,den] = ss2tf(Ac,Bc,Cc,Dc);
Gc = tf(num,den)

%% Step Response Evaluation
hold on;
step(G)
step(Gc)
legend('G(s)','Gc(s)')
hold off;
