
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.pipeline import make_pipeline
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay

SEMILLA = 1  # para que las particiones sean reproducibles

# Leer el conjunto de datos
tabla = pd.read_csv("IRIS.csv")
X = tabla.drop(columns="species")
y = tabla["species"]

# 80 % entrenamiento+validación, 20 % prueba 
X_tmp, X_prueba, y_tmp, y_prueba = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=SEMILLA)

# 80 % entrenamiento, 20 % validación
X_entre, X_val, y_entre, y_val = train_test_split(
    X_tmp, y_tmp, test_size=0.2, stratify=y_tmp, random_state=SEMILLA)

def crear_knn(k):
    return make_pipeline(
        StandardScaler(),
        KNeighborsClassifier(n_neighbors=k, metric="euclidean"))

valores_K = np.arange(1, 32, 2)  # K impares: 1, 3, ..., 31
error_entre = np.zeros(len(valores_K))
error_validacion = np.zeros(len(valores_K))

for j, k in enumerate(valores_K):
    mdl = crear_knn(k).fit(X_entre, y_entre)
    error_entre[j] = 1 - mdl.score(X_entre, y_entre)  # como resubLoss
    error_validacion[j] = 1 - mdl.score(X_val, y_val)  # como loss(mdl, val)

# K con menor error de validación (argmin devuelve el primero si hay empate)
K_opt = int(valores_K[np.argmin(error_validacion)])

# Gráfica de error vs. K
fig, eje = plt.subplots(figsize=(9, 5))
eje.plot(valores_K, error_entre, "b:o", linewidth=2, label="Entrenamiento")
eje.plot(valores_K, error_validacion, "r-.s", linewidth=2, label="Validación")
eje.axvline(K_opt, color="k", linestyle="--", linewidth=1.5)
eje.text(K_opt + 0.3, eje.get_ylim()[1] * 0.9, f"K = {K_opt}", fontsize=13)
eje.set_xlabel("Número de vecinos K", fontsize=15)
eje.set_ylabel("Error de clasificación", fontsize=15)
eje.set_title("Selección de K", fontsize=15)
eje.tick_params(labelsize=13)
eje.minorticks_on()
eje.grid(which="both", alpha=0.3)
eje.legend(fontsize=13)
fig.tight_layout()

modelo = crear_knn(K_opt).fit(X_tmp, y_tmp)

# Matriz de confusión sobre los datos de prueba
predicciones = modelo.predict(X_prueba)
etiquetas = modelo.classes_
matriz_confusion = confusion_matrix(y_prueba, predicciones, labels=etiquetas)

fig2, eje2 = plt.subplots(figsize=(7, 6))
ConfusionMatrixDisplay(matriz_confusion, display_labels=etiquetas).plot(
    ax=eje2, cmap="Blues", colorbar=False)
eje2.set_xlabel("Clase predicha")
eje2.set_ylabel("Clase real")
eje2.set_title(f"Matriz de confusión (KNN, K = {K_opt})")
fig2.tight_layout()

num_clases = len(etiquetas)
precision = np.zeros(num_clases)
recall = np.zeros(num_clases)
f1_score = np.zeros(num_clases)

for k in range(num_clases):
    TP = matriz_confusion[k, k]
    FP = matriz_confusion[:, k].sum() - TP
    FN = matriz_confusion[k, :].sum() - TP

    if TP + FP > 0:
        precision[k] = TP / (TP + FP)
    if TP + FN > 0:
        recall[k] = TP / (TP + FN)
    if precision[k] + recall[k] > 0:
        f1_score[k] = 2 * precision[k] * recall[k] / (precision[k] + recall[k])

accuracy = np.trace(matriz_confusion) / matriz_confusion.sum()

print(f"K = {K_opt}")
print(f"Accuracy  = {100 * accuracy:.4f} %")
print(f"Recall    = {100 * recall.mean():.4f} %")
print(f"Precision = {100 * precision.mean():.4f} %")
print(f"F1-Score  = {100 * f1_score.mean():.4f} %")

plt.show()