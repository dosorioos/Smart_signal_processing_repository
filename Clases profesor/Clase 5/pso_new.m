clear all; close all; clc;

% límites y graficación de la superficie de búsqueda:
x_min = -5;
x_max = 5;
x1 = x_min:1e-1:x_max;
x2 = x_min:1e-1:x_max;
[X1,X2] = meshgrid(x1,x2);
f = rastrigin(X1,X2);

% Parámetros del algoritmo
Max_Iter = 200;
N = 25; % Tamaño del enjambre
w1 = 0.005;
w2 = 0.005;

positions = rand(N, 2) .* (x_max - x_min) + x_min; % Posiciones aleatorias
velocities = (rand(N, 2) .* (x_max - x_min) + x_min)./50; % Velocidades 
bestPositions = positions; % Mejores posiciones encontradas
bestScores = rastrigin(positions(:,1), positions(:,2)); % Evaluar la función
bestScoreG =  min(bestScores);
bestPositionG = bestPositions(bestScoreG == bestScores);
bestPositionG = bestPositionG(1);

% inicializar antes de iterar
i = 1;
bestG = zeros(1,Max_Iter);


%primera gráfica
eje = subplot(1,2,2);
surf(X1,X2,f);
set(eje,'FontSize',15);
xlabel('x_1');
ylabel('x_2');
zlabel('f(x_1,x_2)');    
for k=1:N
    texto = text(positions(k,1),positions(k,2),rastrigin(positions(k,1),...
        positions(k,2)),'*','FontSize',60,'Color',[1 0 0],...
        'HorizontalAlignment','center',VerticalAlignment='top');
end
msgbox('Ajuste el punto de vista...','modal');
pause;
[az,el] = view;


while(i<Max_Iter)
    % Actualizar las posiciones y velocidades
    r1 = rand(N, 2);
    r2 = rand(N, 2);
    velocities = velocities + w1.* r1 .* (bestPositions - positions) ...
        + w2 .* r2 .* (bestPositionG - positions);
    positions = positions + velocities;
    % restricciones:
    positions(positions>x_max) = x_max;
    positions(positions<x_min) = x_min;

    % Evaluar nuevas posiciones
    currentScores = rastrigin(positions(:,1), positions(:,2));
    
    % Actualizar mejores posiciones
    for j = 1:N
        if currentScores(j) < bestScores(j)
            bestScores(j) = currentScores(j);
            bestPositions(j, :) = positions(j, :);
        end
    end
    
    % Actualizar mejor global
    [minimo, idx] = min(bestScores);
    if (minimo < bestScoreG)
        bestScoreG = minimo; % Actualizar el mejor score global
        bestPositionG = bestPositions(idx, :);
    end
    
    % Guardar el mejor score en cada iteración
    bestG(i) = bestScoreG;

    eje = subplot(1,2,1);
    plot(bestG(1:i),'b:','LineWidth',2);
    set(eje,'FontSize',12);
    grid minor;
    xlabel('Iterations');
    title('Best Fitness found so far...');
    axis([1 Max_Iter 0 max(bestG)]);

    eje = subplot(1,2,2);
    surf(X1,X2,f);
    set(eje,'FontSize',12);
    xlabel('x_1');
    ylabel('x_2');
    zlabel('f(x_1,x_2)');    
    for k=1:N
        texto = text(positions(k,1),positions(k,2),...
            1.1*rastrigin(positions(k,1),...
            positions(k,2)),'*','FontSize',60,'Color',[1 0 0],...
            'HorizontalAlignment','center',VerticalAlignment='top');
    end

    view(az,el);
    pause(0.01);
    
    % comentar si no se quiere guardar la animación:
    if(~ mod(i,5))
        exportgraphics(gcf, 'Salida.gif', 'Append', true);
    end

    i = i + 1;
end


function [z] = rastrigin(x1,x2)
    z = 20 + x1.^2 + x2.^2 - 10.*(cos(2*pi.*x1) + cos(2*pi.*x2));
end
