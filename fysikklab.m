clear all; close all; clc;

%Simuleringsparametre
h = 0.1; %Tidssteg

%Tyngeakselerasjon
g = 9.81;

%Konstanter for forsøkene:
C_kule = 2/5;
C_skall = 2/3;
C_sylinder = 1;

%Akselerasjon som funksjon av vinkel og konstant
v_dot = @(theta, c) (g * sin(theta))/(1 + c); 