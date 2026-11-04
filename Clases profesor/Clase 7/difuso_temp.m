clear; close all; clc;


T = 0:1e-3:50;
Fresco(T<20) = 1;
Fresco(T>30) = 0;
Fresco(T >= 20 & T <= 30) = linspace(1, 0, nnz(T >= 20 & T <= 30));
Caliente(T<20) = 0;
Caliente(T>30) = 1;
Caliente(T >= 20 & T <= 30) = linspace(0, 1, nnz(T >= 20 & T <= 30));

Velocidad = 0:1e-3:1;
Rapido(Velocidad < 0.5) = 0;
Rapido(Velocidad >= 0.5) = linspace(0,1,nnz(Velocidad >= 0.5));



% Gráficas de los conjuntos:
eje = subplot(2,1,1);
plot(T, Fresco, 'LineWidth', 1.5);
set(eje,'FontSize',15);
xlabel('Temperatura'); ylabel('Pertenencia');
axis([0 50 -0.1 1.1]);
grid minor; hold on;
plot(T, Caliente,'r', 'LineWidth', 1.5);
legend('Fresco','Caliente');

eje = subplot(2,1,2);
plot(Velocidad,Rapido,'k','LineWidth',1.5);
set(eje,'FontSize',15);
xlabel('Velocidad'); ylabel('Pertenencia');
axis([0 1 -0.1 1.1]);
grid minor;
legend('Rápido','Location','northwest');
hold on;


% Definir una temperatura deentrada:
prompt = {'Ingrese la temperatura:'};
dlgtitle = 'Entrada al sistema difuso';
fieldsize = [1 45];
definput = {'27'};
answer = inputdlg(prompt,dlgtitle,fieldsize,definput);

temp = eval(answer{1});
if(temp<20)
    pertenencia_caliente = 0;
elseif(temp>30)
    pertenencia_caliente = 1;
else
    pertenencia_caliente = (temp - 20) / 10;
end
truncada = Rapido;
truncada(Rapido>pertenencia_caliente) = pertenencia_caliente;
Velocidad_salida = sum(truncada) / sum(Rapido);

subplot(2,1,1);
line([temp temp],[0 1],'Color','green','LineWidth',1);
legend('Fresco','Caliente','Temperatura');
title(sprintf('Pertenencia a Caliente: %.4f',pertenencia_caliente));
subplot(2,1,2);
plot(Velocidad,ones(1,length(Velocidad)).*pertenencia_caliente,...
    'g-.','LineWidth',2);
plot(Velocidad,truncada,'k:','LineWidth',2);
legend('Rápido','Pertenencia','Truncada','Location','northwest');
title(sprintf(...
    'Única regla: "Si Caliente entonces Rápido"; Velocidad_{Salida} = %.3f %',...
    Velocidad_salida));
