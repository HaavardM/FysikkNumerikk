clear all; close all; clc;

%Simuleringsparametre
h = 0.1; %Tidssteg
endTime = 1;
%Tyngeakselerasjon
g = 9.81;

%Konstanter for forsøkene:
C_kule = 2/5;
C_skall = 2/3;
C_sylinder = 1;

%Vinkel på plan
THETA = pi / 6; %30 grader

%Akselerasjon som funksjon av vinkel og konstant
v_dot = @(theta, c) (g * sin(theta))/(1 + c); 

t = zeros(1, endTime / h);
v = zeros(1, endTime / h);
s = zeros(1, endTime / h);

for i = 1 : endTime / h
   v(i + 1) = v(i) + h*v_dot(THETA, C_kule);
   s(i + 1) = s(i) + h*v(i);
   t(i + 1) = t(i) + h;
end

figure(1);
plot(t, v);
hold on;
plot(t, s);
xlabel('Tid [s]');
ylabel('v(t) [m/s] / s(t) [m]');
legend('Hastighet', 'Posisjon');
title('Numerisk løsning:');




