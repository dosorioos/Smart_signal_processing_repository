import struct
import numpy as np
import matplotlib.pyplot as plt

#Lectura de los datos
def leer_imagenes_idx(ruta):
    with open(ruta, "rb") as f:                       # "rb": leer en binario
        magic, n, filas, cols = struct.unpack(">IIII", f.read(16))
        assert magic == 2051, "No es un archivo de imágenes"
        datos = np.frombuffer(f.read(), dtype=np.uint8)   # el resto: todos los píxeles
    return datos.reshape(n, filas * cols)             # N x 784, una imagen por fila

def leer_etiquetas_idx(ruta):
    with open(ruta, "rb") as f:
        magic, n = struct.unpack(">II", f.read(8))
        assert magic == 2049, "No es un archivo de etiquetas"
        return np.frombuffer(f.read(), dtype=np.uint8)

X = leer_imagenes_idx("mnist/train-images.idx3-ubyte")
y = leer_etiquetas_idx("mnist/train-labels.idx1-ubyte")
print(X.shape, y.shape)           # (60000, 784) (60000,)

# Verificación visual: las primeras 10 imágenes con su etiqueta
fig, ax = plt.subplots(1, 10, figsize=(12, 1.8))
for i in range(10):
    ax[i].imshow(X[i].reshape(28, 28), cmap="gray")
    ax[i].set_title(y[i]); ax[i].axis("off")
plt.show()

# Selección del dígito 9
X9 = X[y == 9].astype(np.float64)     # uint8 → decimal, para poder restar y dividir
N, D = X9.shape
print(f"N = {N} imágenes, D = {D} píxeles")

#Normalización de los datos
media = X9.mean(axis=0)               # media de cada píxel (784,)
desv  = X9.std(axis=0)                # desviación de cada píxel (784,)
desv[desv == 0] = 1.0                 # píxeles constantes (bordes): evitar dividir por 0

Xs = (X9 - media) / desv              # datos estandarizados, N x 784

# Verificación
print("Media máx. por píxel:", np.abs(Xs.mean(axis=0)).max())          # ~1e-16
print("Desviaciones posibles:", np.unique(np.round(Xs.std(axis=0), 6))) # [0. 1.]
print("Píxeles constantes:", np.sum(X9.std(axis=0) == 0))

# Media y desviación vistas como imágenes
fig, ax = plt.subplots(1, 2, figsize=(7, 3.5))
ax[0].imshow(media.reshape(28, 28), cmap="gray"); ax[0].set_title("Media de los 8")
ax[1].imshow(X9.std(axis=0).reshape(28, 28), cmap="gray"); ax[1].set_title("Desviación por píxel")
for a in ax: a.axis("off")
plt.show()

