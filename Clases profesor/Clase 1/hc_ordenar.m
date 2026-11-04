% algoritmo de ordeanamiento basado en hill-climbing
% Uso: function [vector_salida] = hc_ordenar(vector)
function [vector_salida] = hc_ordenar(vector)

Tam = length(vector);
% inicializa el vector resultado:
vector_salida = vector;
while(1) % exit condition?
    costo_ini = costo(vector_salida);
    anterior = vector_salida;
    positions = randperm(Tam,2);
    tmp = vector_salida(positions(1));
    vector_salida(positions(1)) = vector_salida(positions(2));
    vector_salida(positions(2)) = tmp;
    costo_fin = costo(vector_salida);
    if costo_fin > costo_ini
        vector_salida = anterior;
    end
    disp(vector_salida);
%    pause(0.5);
end

function [fitness] = costo(vector)
Tam = length(vector)-1;
fitness = 0;
for k=1:Tam
    if(vector(k)>vector(k+1))
        fitness = fitness + 1;
    end
end
