clear; close all; clc;

N = 15;    % número de individuos
LR = 0.005; % Tasa de aprendizaje
MAX_It = 400;

historia = zeros(1,MAX_It);

% inicilización
P = 0.5 .* ones(1,60);

i = 1;
while(i<MAX_It)
    pop = rand(N,60) < P;
    fitness = evaluar(pop);
    indice = find(fitness == min(fitness));
    indice = indice(1);
    best = pop(indice,:);
    bestf = evaluar(best);
    % Actualizar las probabilidades:
    P(best) = P(best) .* (1+LR);
    P(~best) = P(~best) .* (1-LR);
    P(P>1) = 1;
    P(P<0) = 0;
    historia(i) = bestf;

    % gráficas
    R2 = bin2dec(char(best(:,1:30)+'0')) / 2^15;
    R1 = bin2dec(char(best(:,31:60)+'0')) / 2^15;
    subplot(2,1,1);
    eje = subplot(1,1,1);
    plot(1:i,historia(1:i),'b-.','LineWidth',2);
    set(eje,'FontSize',14);
    grid minor;
    xlabel('iterations');
    ylabel('Best_{ F}');
    title(sprintf('R2 = %.3f, R1 = %.3f',R2,R1));
    pause(0.05);

    i = i + 1;
end
msgbox(sprintf('R2/R1 = %.4f',R2/R1));


function [mse] = evaluar(matriz)
% los primeros 30 bits son un número en punto
% fijo, los siguientes 30 son otro

R2 = bin2dec(char(matriz(:,1:30)+'0')) / 2^15;
R1 = bin2dec(char(matriz(:,31:60)+'0')) / 2^15;

mse = (4 - R2./R1).^2; % ganancia esperada
end