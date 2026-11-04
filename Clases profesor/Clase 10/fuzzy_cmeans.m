clear; clc; close all;

% Extraer los datos de cada punto...
tabla = readtable("capitales_colombia.csv",...
    'VariableNamingRule', 'preserve');
[numdatos,n] = size(tabla);
nombres = table2array(tabla(:,1));
poblacion = table2array(tabla(:,3) ./ 1e6);
area = table2array(tabla(:,4)./1e3);
pib = table2array(tabla(:,5)./1e6);
datos = [poblacion./max(poblacion),area./max(area),pib./max(pib)];

% Visualizar población, área y PIB por capital
figure;
eje = subplot(1,1,1);
bar(categorical(nombres),poblacion);
set(eje,'FontSize',10);
title('Población por ciudad');
xlabel('Ciudades');
ylabel('Población (millones)');
grid minor;

figure;
eje = subplot(1,1,1);
bar(categorical(nombres),area);
set(eje,'FontSize',10);
title('Area por ciudad');
xlabel('Ciudades');
ylabel('Area (miles km²)');
grid minor;

figure;
eje = subplot(1,1,1);
bar(categorical(nombres),pib);
set(eje,'FontSize',10);
title('PIB anual por ciudad');
xlabel('Ciudades');
ylabel('PIB (millones)');
grid minor;

figure;
eje = subplot(1,1,1);
bar(categorical(nombres), datos);
set(eje,'FontSize',10);
xlabel('Cuidades');
ylabel('Valores normalizados');
legend('Población', 'Área', 'PIB', ...
    'Location', 'best');
grid minor;

options.WindowStyle = 'normal';
respuesta = inputdlg('Seleccione de los 3 criterios:',...
    'Criterios para hacer el agrupamiento',...
    1,{'[1 2 3]'},options);

criterios = eval(respuesta{1});
if length(criterios) < 1
    return;
end

datos = datos(:,criterios);

% uso del clasificador de Matlab fcm
C = 3;
options = fcmOptions(...
    NumClusters=C,...
    MaxNumIteration=100,...
    MinImprovement=0.001,...
    Verbose=false);
[centroides,U,costo] = fcm(datos,options);

for k = 1:C
    cad = sprintf('Grupo %c','A' + k-1);
    leyenda{k} = cad;
end

figure;
eje = subplot(1,1,1);
plot(costo,'LineWidth',2);
set(eje,'FontSize',12);
grid minor;
xlabel('Iteraciones');


figure;
eje = subplot(1,1,1);
bar(categorical(nombres),U','stacked');
set(eje,'FontSize',10);
xlabel('Cuidades');
ylabel('Distribución en los grupos');
title('Grados de pertenencia de cada ciudad')
legend(leyenda);
