clear all; close all; clc; 

% Tamaño del problema
N = 20;

% creación aleatoria del problema:
coordenadas = round(rand(N,2) .* 150);

% solucion inicial:
mejor = randperm(N);
distancia = fitness(coordenadas,mejor);

condicion_salida = 0;
T = 50;
iteraciones = 1;
MAXIT = 2.5E3;

while(~condicion_salida)
    subplot(1,1,1)
    eje = subplot(2,1,1);
    xlabel('x_{ [km]}');
    ylabel('y_{ [km]}');
    set(eje,'FontSize',14,'Color','w');
    axis([-2 152 -2 152]);
    grid minor;
    hold on;
    for k=1:N
        % ubica cada ciudad:
        texto = text(coordenadas(k,1),coordenadas(k,2),sprintf('%c','A'+k-1));
        set(texto,'FontSize',15,'HorizontalAlignment','center',...
            'FontWeight','bold');
        % traza la línea y calcula fitness:
        
        if(k<N)
            line([coordenadas(mejor(k),1) coordenadas(mejor(k+1),1)],...
                [coordenadas(mejor(k),2) coordenadas(mejor(k+1),2)],...
                'Color', 'b', 'LineWidth', 0.3,'LineStyle','-.');
        end
    end
    tmp = mejor;
    % Intercambiar las ciudades en la solución actual
    cambio = randperm(N,2);
    tmp2 = mejor(cambio(1));
    mejor(cambio(1)) = mejor(cambio(2));
    mejor(cambio(2)) = tmp2;
    distancia2 = fitness(coordenadas,mejor);

    if (distancia2 > distancia)
        if(rand < exp((distancia-distancia2)/T))
            distancia = distancia2; % Update the current distance
        else    
            mejor = tmp;
        end
    else 
        distancia = distancia2;
    end
    registro(iteraciones) = distancia;
    iteraciones = iteraciones + 1;
    T = 0.995 * T;

    title(sprintf('Problema del vendedor viajero'));
    hold off;
    % Aquí se puede agregar la lógica para calcular la condición de salida
    eje = subplot(2,1,2);
    plot(registro,'LineWidth',2);
    axis([1, iteraciones 0 max(registro)*1.05]);
    set(eje,'FontSize',14);
    xlabel('Iteraciones');
    ylabel('Distancia total_{ [km]}');
    grid minor;
    title(sprintf('D = %.2f, T = %.2f',distancia,T));

    if(iteraciones > MAXIT) 
        condicion_salida = 1;
    end
    pause(0.01);
end



function [dist] = fitness(coordenadas,sol)

dist = 0;
N = length(coordenadas);
for k= 1:N-1
    x1 = coordenadas(sol(k),1);
    y1 = coordenadas(sol(k),2);
    x2 = coordenadas(sol(k+1),1);
    y2 = coordenadas(sol(k+1),2);
    dist = dist + sqrt((x2-x1)^2 + (y2-y1)^2);
end
end