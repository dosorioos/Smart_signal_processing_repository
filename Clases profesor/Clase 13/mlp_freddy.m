clear; close all; clc;

% Leer el conjunto de datos:
tabla = readtable('IRIS.csv');
[m,n] = size(tabla);


% 80 por ciento de los datos para entrenamiento
particion1 = cvpartition(ones(m,1),'HoldOut',0.2);
indice_entre = training(particion1);
% 20 por ciento restante
indice_prueba = test(particion1);

% datos de entrenamiento (con validacion) y de prueba:
datos_tmp = tabla(indice_entre,:);
datos_prueba = tabla(indice_prueba,:);

% volver a particionar para los datos de validación
particion2 = cvpartition(height(datos_tmp),'HoldOut',0.2);
indice_validacion = test(particion2);
indice_entrenamiento = training(particion2);
datos_entre = datos_tmp(indice_entrenamiento,:);
datos_validacion = datos_tmp(indice_validacion,:);

% entrenamiento del modelo
modelo = fitcnet(datos_entre,'species',Standardize=true,ValidationData=...
    datos_validacion,Verbose=0,LayerSizes=[5 20 10]);

% graficas
iteraciones = modelo.TrainingHistory.Iteration;
perdidas_entre = modelo.TrainingHistory.TrainingLoss;
perdidas_validacion = modelo.TrainingHistory.ValidationLoss;
eje = subplot(1,1,1);
plot(iteraciones, perdidas_entre, 'b:','LineWidth',2);
hold on; set(eje,'FontSize',15); grid minor;
plot(iteraciones, perdidas_validacion, 'r-.','LineWidth',2);
xlabel('Iteración'); ylabel('Pérdidas');
legend('Entrenamiento', 'Validación'); 

% matriz de confusion
predicciones = predict(modelo, datos_prueba);
matrizConfusion = confusionmat(datos_prueba.species, predicciones);
figure;
etiquetas = {'Iris-setosa';'Iris-versicolor';'Iris-virginica'};
confusionchart(matrizConfusion,etiquetas);
title('Matriz de confusión');

% métricas
i = 0;
precision = zeros(length(predicciones),1);
f1_score = zeros(length(predicciones),1);
recall = zeros(length(predicciones),1);

for k=1:length(predicciones)
    if strcmp(predicciones{k},datos_prueba.species{k})
        i = i + 1;
    end
end
for k=1:length(etiquetas)
    TP = matrizConfusion(k,k);
    FP = sum(matrizConfusion(:,k)) - TP;
    FN =  sum(matrizConfusion(k,:)) - TP;
    if TP + FP == 0
        precision(k) = 0;
    else
        precision(k) = TP / (TP + FP);
    end
    if TP + FN == 0
        recall(k) = 0;
    else
        recall(k) = TP / (TP + FN);
    end
    if precision(k) + recall(k) == 0
        f1_Score(k) = 0;
    else
        f1_Score(k) = 2 * (precision(k) * recall(k)) / (precision(k) + recall(k));
    end
end

cad = sprintf('Accuracy = %.4f %%\nRecall = %.4f%%\nPrecision = %.4f %%\nF1-Score = %.4f %%',...
    100.0*i/length(predicciones),100.0*mean(recall),...
    100.0 * mean(precision),100.0 * mean(f1_Score));

msgbox(cad)


