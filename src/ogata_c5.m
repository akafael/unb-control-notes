%% 


%% First Order System
T = 1
G1 = tf(1,[T 1])


%% Second Order System
w0 = 1
xi = 1
G2 = tf([w0^2],[1 2*xi*w0 w0^2])

ts = 4/(xi*w0)


ts = 2
mp = 0.05
sq_xi = (log(mp))^2/ (pi^2 + (log(mp))^2)
xi = sqrt(sq_xi)
w0 = 4/(ts*xi)
G2 = tf([w0^2],[1 2*xi*w0 w0^2])
