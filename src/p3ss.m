%%

close all;
clear;

G = tf([1],[1 6 5 6])
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

polyMa = wrev(coeffs(det(s*eye(size(Ama))-Ama),s))

% Ensure one pole equals zero
F(end) = solve(polyMa(end),F(end))

% Closed Loop Space State Expression
Amf = A - B*F - B*N*C
Bmf = B*N
Cmf = C
Dmf = D

polyMf = wrev(coeffs(det(s*eye(size(Amf))-Amf),s))

% Find Desired Poles
polesDesired = [complex(-1,-0),complex(-10,0),complex(-10,0)];
polyDesired = poly(polesDesired)

% Solve to find desired gain
polyK = (polyMf - polyDesired)
[m,v] = equationsToMatrix(polyK,[F(1:end-1) sym('N')])
x = linsolve(m,v)
F(1:end-1) = x(1:end-1)
N = x(end)

% Controled System
Ac = double(A - B*F - B*N*C)
Bc = double(B*N)
Cc = double(C)
Dc = double(D)

[num,den] = ss2tf(Ac,Bc,Cc,Dc);
Gc = tf(num,den)

%% Graphic Evaluation
hold on;
step(G)
step(Gc)
legend('G(s)','Gc(s)')
hold off;
