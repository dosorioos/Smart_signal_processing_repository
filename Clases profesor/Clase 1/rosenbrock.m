clear all; close; clc;

x1 = -10:20e-2:10;
x2 = -10:20e-2:10;

[X1,X2] = meshgrid(x1,x2);

f = (1-X1.^2) + 100 .* (X2 - X1.^2).^2;

eje = subplot(1,1,1);

surf(X1,X2,f);
set(eje,'FontSize',15);
xlabel('x_1');
ylabel('x_2');
zlabel('f(x_1,x_2)');
title('Función de Rosenbrock')