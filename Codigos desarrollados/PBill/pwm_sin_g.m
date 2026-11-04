% Función dedicada a calcular el costo asociado a un patrón de conmutación
% en términos de su distorsión armónica. Uso:
% [costo] = pwm_sin(vector)
% vector es un vector binario de 1000 posiciones almacenando el patrón de
% conmutación del primer semiciclo de la señal.
function [costo] = pwm_sin_g(vector)

x = [vector -vector];
L = length(x);
Ffund = 60;
Fs = Ffund * L;


% muchos periodos: mejora calidad del espectro y reduce efectos de borde:
X = [x x x x x x x x x x x x x x x x x x x x];
Y = abs(fft(X)) ./ length(X);
F = ((0:length(Y)-1)./length(Y) - 0.5) .* Fs;

% filtrado del patrón:
[b,a] = butter(1,Ffund*2/(Fs/2));
xf = filter(b,a,X);
[respf,ff] = freqz(b,a,1e4,Fs);

% Cálculo de la THD:
XF = abs(fft(xf));
[picos,localiz] = findpeaks(XF(1:round(length(XF)/2)));
X1 = picos(1).^2;
Xr = sum(picos(2:length(picos)).^2);
costo = Xr / X1;

%graficación de las señales (solo para verificación, comentar luego):
factor = 40;
eje = subplot(2,1,1);
plot((0:2*L-1) / Fs, [x x],'r-.','LineWidth',0.3);
set(eje,'FontSize',13);
grid minor;
hold on;
plot((0:2*L-1) / Fs, xf(6*L+1:8*L),'b','LineWidth',2);
xlabel('Tiempo (s)');
ylabel('x(t)');
grid on;
xlim([0 2/Ffund]);
hold off;
legend('Patrón Original','Filtrada');
eje = subplot(2,1,2);
plot(F, fftshift(Y),'r-.','LineWidth',0.5);
set(eje,'FontSize',13);
grid minor;
xlabel('Frecuencia (Hz)');
ylabel('|X(f)|');
xlim([-1 1] .* (factor * Ffund));
grid on;
hold on;
plot(F, fftshift(XF)./length(X),'b','LineWidth',2);
plot(ff,abs(respf),'k:','LineWidth',1.5);
plot(-ff,abs(respf),'k:','LineWidth',1.5);
hold off;
legend('Patrón Original','Filtrada','Ganancia del filtro');
title(sprintf('THD = %.5f',costo));
tmp = Fs .* (0:length(XF)-1) ./ length(XF);
for k=1:length(localiz)
    if(tmp(localiz(k)) < factor*Ffund)
        texto = text(tmp(localiz(k)),XF(localiz(k)) / length(X),'X');
        set(texto,'HorizontalAlignment','center','Color','g',...
            'FontSize',14,'FontWeight','bold');
    end
end

