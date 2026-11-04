import math
import random

def Función_costo_Rosenbrock(x1,x2):
    costo = (1-x1)**2 + 100*(x2 - x1**2)**2
    return costo

def Función_costo_Rastrigin(x1,x2):
    costo = 20 + x1**2 + x2**2 - 10*(math.cos(2*math.pi*x1) + math.cos(2*math.pi*x2))
    return costo



def Hill_Climbing_Rosenbrock(x1, x2, paso1, paso2):
    x1_actual, x2_actual = x1, x2
    solución_actual= Función_costo_Rosenbrock(x1_actual, x2_actual)
    contador = 0
    while True:
            vecino_x = x1_actual + random.choice([-paso1, paso1])
            vecino_y = x2_actual + random.choice([-paso2, paso2])
            costo_vecino = Función_costo_Rosenbrock(vecino_x, vecino_y)

            if costo_vecino < solución_actual:
                x1_actual, x2_actual = vecino_x, vecino_y
                solución_actual = costo_vecino
            else:
                contador += 1
                if contador >= 200:
                    print("No se encontró una mejor solución después de 200 intentos.")
                    break

    print("Mejor solución encontrada: x1 =", x1_actual, ", x2 =", x2_actual, ", costo =", solución_actual)

def Hill_Climbing_Rosenbrock(x1, x2, paso1, paso2):
    x1_actual, x2_actual = x1, x2
    solución_actual= Función_costo_Rosenbrock(x1_actual, x2_actual)
    contador = 0
    while True:
            vecino_x = x1_actual + random.choice([-paso1,0, paso1])
            vecino_y = x2_actual + random.choice([-paso2, paso2])
            costo_vecino = Función_costo_Rosenbrock(vecino_x, vecino_y)

            if costo_vecino < solución_actual:
                x1_actual, x2_actual = vecino_x, vecino_y
                solución_actual = costo_vecino
                contador = 0  # se reinicia porque hubo mejora
            elif costo_vecino > solución_actual:
                 x1_actual, x2_actual = x1_actual, x2_actual
                 solución_actual = solución_actual
            else:
                contador += 1
                if contador >= 200:
                    paso1 /= 2
                    paso2 /= 2
                    contador = 0
                    print("No se encontró una mejor solución después de 200 intentos.")
                    break

    print("Mejor solución encontrada: x1 =", x1_actual, ", x2 =", x2_actual, ", costo =", solución_actual)

def Hill_Climbing_Rastrigin(x1, x2, paso1, paso2):
    x1_actual, x2_actual = x1, x2
    solución_actual= Función_costo_Rastrigin(x1_actual, x2_actual)
    contador = 0
    while True:
            vecino_x = x1_actual + random.choice([-paso1, paso1])
            vecino_y = x2_actual + random.choice([-paso2, paso2])
            costo_vecino = Función_costo_Rastrigin(vecino_x, vecino_y)

            if costo_vecino < solución_actual:
                x1_actual, x2_actual = vecino_x, vecino_y
                solución_actual = costo_vecino
                contador = 0  # se reinicia porque hubo mejora
            else:
                contador += 1
                if contador >= 200:
                    paso1 /= 2
                    paso2 /= 2
                    contador = 0
                    print("No se encontró una mejor solución después de 200 intentos.")
                    break

    print("Mejor solución encontrada: x1 =", x1_actual, ", x2 =", x2_actual, ", costo =", solución_actual)

hill_climbing_rosenbrock = Hill_Climbing_Rosenbrock(3, 3, 0.1, 0.1)
hill_climbing_rastrigin = Hill_Climbing_Rastrigin(-4, 4, 0.1, 0.1)