clear; clc; close all;

triang = 1.2 .* bartlett(40)';
x = [];
for k=1:25
x = [x triang];
end
s = sin(pi.*(0:999)./1000);
vector = zeros(1,1000);
vector(s > x) = 1;