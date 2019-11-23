%% Lista 3
function list3()
  b9_5()
end

function b9_1()
   f = tf([1 6],[1 5 6])

   % Canonical Form
   Ac = [0 1;-f.den{1}(1,2:end)]
   Bc = [0 1]'
   Cc = [f.num{1}(1,2:end) - f.den{1}(1,2:end)*f.num{1}(1)]

   % Observable Form
   Ao = Ac'
   Bo = Cc'
   Co = Bc'
end

function b9_3()
   syms s;
   A = [1 2;-4 -3]
   B = [1 2]'
   C = [1 1]
   I = diag(ones(1,2),0)

   G = C*(s*I - A)^(-1)*B

   f = tf([3 -1],[1 2 5])
   Ac = [0 1;-f.den{1}(1,2:end)]
   Bc = [0 1]'
   Cc = [f.num{1}(1,2:end) - f.den{1}(1,2:end)*f.num{1}(1)]
end

function b9_4()
   syms s;
   A = [-1 0 1;1 -2 0;0 0 -3]
   B = [0 0 1]'
   C = [1 1 0]
   D = [0 0 0]'
   I = diag(ones(1,3),0)

   G = C*(s*I - A)^(-1)*B
end

function b9_5()
   A = diag([1 1 1],1)
   A(end,1) = 1

   d = eig(A)'

   P = [d./d ;d;d.^2;d.^3]
end
