import numpy as np
import matplotlib.pyplot as plt
from simpful import FuzzySystem, FuzzySet, LinguisticVariable

# Crear el modelo difuso (vacío)
FS = FuzzySystem(show_banner=False)

# Se crean los conjuntos difusos de entrada y las funciones de pertenencia
x_low = FuzzySet(points=[[0, 1], [5, 0]], term="bajo")
x_med = FuzzySet(points=[[0, 0], [5, 1], [10, 0]], term="medio")
x_high = FuzzySet(points=[[5, 0], [10, 1]], term="alto")
FS.add_linguistic_variable("X", LinguisticVariable([x_low, x_med, x_high], universe_of_discourse=[0, 10]))

y_low = FuzzySet(points=[[0, 1], [5, 0]], term="bajo")
y_med = FuzzySet(points=[[0, 0], [5, 1], [10, 0]], term="medio")
y_high = FuzzySet(points=[[5, 0], [10, 1]], term="alto")
FS.add_linguistic_variable("Y", LinguisticVariable([y_low, y_med, y_high], universe_of_discourse=[0, 10]))

# Se definen las reglas difusas (tipo sugeno), como una combinación lineal de las entradas
FS.set_output_function("plano1", "0.1*X + 0.1*Y + 2")
FS.set_output_function("plano2", "0.5*X - 0.2*Y + 5")
FS.set_output_function("plano3", "1.2*X + 0.8*Y + 1")
FS.set_output_function("plano4", "-0.4*X + 1.5*Y + 3")
FS.set_output_function("plano5", "0.8*X + 0.8*Y + 10")

# Se intergran las reglas difusas al modelo
reglas = [
    "IF (X IS bajo) AND (Y IS bajo) THEN (Z IS plano1)",
    "IF (X IS medio) AND (Y IS bajo) THEN (Z IS plano2)",
    "IF (X IS alto) AND (Y IS bajo) THEN (Z IS plano3)",
    "IF (X IS bajo) AND (Y IS alto) THEN (Z IS plano4)",
    "IF (X IS medio) AND (Y IS alto) THEN (Z IS plano5)",
    "IF (X IS alto) AND (Y IS alto) THEN (Z IS plano3)"
]
FS.add_rules(reglas)

# Se definen las coordenadas de la cuadrícula para evlauar la superficie
x_vals = np.linspace(0, 10, 50)
y_vals = np.linspace(0, 10, 50)
X_grid, Y_grid = np.meshgrid(x_vals, y_vals)
Z_grid = np.zeros_like(X_grid)

# Se evalua la superficie con el modelo:
for i in range(len(x_vals)):
    for j in range(len(y_vals)):
        FS.set_variable("X", X_grid[i, j])
        FS.set_variable("Y", Y_grid[i, j])
        # Simpful infers and executes weighted-average defuzzification automatically
        Z_grid[i, j] = FS.Sugeno_inference(["Z"],ignore_errors=True,ignore_warnings=True)["Z"]
        
        
# Dibujar la superficie:
fig = plt.figure(figsize=(10, 7))
ax = fig.add_subplot(111, projection='3d')
surface = ax.plot_surface(X_grid, Y_grid, Z_grid, cmap='viridis', edgecolor='none')

ax.set_title("Aproximación de una superficie 3D por medio de un modelo Takagi-Sugeno")
ax.set_xlabel("Entrada X")
ax.set_ylabel("Entrada Y")
ax.set_zlabel("Z aproximada")
fig.colorbar(surface, ax=ax, shrink=0.5, aspect=5)
plt.show()        
