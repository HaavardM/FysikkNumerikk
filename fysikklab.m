clear all; close all; clc;

%Simuleringsparametre
h = 0.01; %Tidssteg
endTime = 1;
%Tyngeakselerasjon
g = 9.81;

%Konstanter for forsøkene:
C_kule = 2/5;
C_skall = 2/3;
C_sylinder = 1;
C_values = [C_kule, C_skall, C_sylinder];

%Plan konstanter
THETA = pi / 6; %30 grader - vinkel på plan 
L = 1; % i meter - lengden på planet

%Akselerasjon som funksjon av vinkel og konstant
v_dot = @(theta, c) (g * sin(theta))/(1 + c); 

%Antall simuleringer
NUM_SIMS = numel(C_values);

%Forhåndsallokerer minne
for i = 1 : NUM_SIMS
   t(i, :) = zeros(1, endTime / h);
   v(i, :) = zeros(1, endTime / h);
   s(i, :) = zeros(1, endTime / h); 
end

%Løser differensialligningen numerisk med faste tidssteg (h)

for simNr = 1 : NUM_SIMS
    for i = 1 : endTime / h
       v(simNr, i + 1) = v(simNr, i) + h*v_dot(THETA, C_values(simNr));
       s(simNr, i + 1) = s(simNr, i) + h*v(simNr, i);
       t(simNr, i + 1) = t(simNr, i) + h;
    end
end

for i = 1 : NUM_SIMS
    %Lager en figur og plotter dataen
    figure(i);
    clf(i)
    plot(t(i, :), v(i, :));
    hold on;
    plot(t(i, :), s(i, :));
    xlabel('Tid [s]');
    ylabel('v(t) [m/s] / s(t) [m]');
    legend('Hastighet', 'Posisjon');
    title(sprintf('Numerisk løsning av C = %.2f', C_values(i)));
end

figure(NUM_SIMS + 1);
legendText = cell(NUM_SIMS + 1, 1);
for i = 1 : NUM_SIMS
   plot(t(i, :), s(i, :));
   hold on;
   legendText{i} = sprintf('C = %.1f', C_values(i));
end
title('Sammenlignging av posisjon per tid');
legendText{NUM_SIMS + 1} = 'Slutt';
plot(t(1, :), ones(1, numel(t(1, :)))*L); %Skjæringslinje
legend(legendText);





