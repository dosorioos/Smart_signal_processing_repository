clear all; close; clc;

x1 = -5.2:1e-1:5.2;
x2 = -5.2:1e-1:5.2;

[X1,X2] = meshgrid(x1,x2);

f = 20 + X1.^2 + X2.^2 - 10.*(cos(2*pi.*X1)+cos(2*pi.*X2));

eje = subplot(1,1,1);

surf(X1,X2,f);
set(eje,'FontSize',15);
xlabel('x_1');
ylabel('x_2');
zlabel('f(x_1,x_2)');
title('Función de Rastrigin')