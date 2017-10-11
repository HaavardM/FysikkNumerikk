clear all; close all; clc;

%Simuleringsparametre
h = 0.01; %Tidssteg
endTime = 3;
%Tyngeakselerasjon
g = 9.81;

%Konstanter for forsøkene:
C_kule = 2/5;
C_skall = 2/3;
C_sylinder = 1;
C_values = [C_kule, C_skall, C_sylinder];
C_descriptions = {'Kule', 'Kuleskall', 'Sylinder'};
filenames = {'golf.mat', 'pingpong.mat', 'ring.mat'};

%Plan konstanter
DEG = 4.9;%Grader
THETA = deg2rad(DEG); %vinkel på plan i radianer 
L = 1.0; % i meter - lengden på planet

%Akselerasjon som funksjon av vinkel og konstant
v_dot = @(theta, c) (g * sin(theta))/(1 + c); 

%Antall simuleringer
NUM_SIMS = numel(C_values);

%Forhåndsallokerer minne
for i = 1 : NUM_SIMS
   t_num(i) = {zeros(1, endTime / h)};
   v_num(i) = {zeros(1, endTime / h)};
   s_num(i) = {zeros(1, endTime / h)};
end

%Løser differensialligningen numerisk med faste tidssteg (h)

for simNr = 1 : NUM_SIMS
    for i = 1 : endTime / h
       v_num{simNr}(i + 1) = v_num{simNr}(i) + h*v_dot(THETA, C_values(simNr));
       s_num{simNr}(i + 1) = s_num{simNr}(i) + h*v_num{simNr}(i);
       t_num{simNr}(i + 1) = t_num{simNr}(i) + h;
       if s_num{simNr}(i + 1) >= L
           s_num{simNr} = s_num{simNr}(1 : i + 1);
           v_num{simNr} = v_num{simNr}(1 : i + 1);
           t_num{simNr} = t_num{simNr}(1 : i + 1);
           break;
       end
    end
end

for i = 1 : NUM_SIMS
    %Lager en figur og plotter dataen
    figure('Name', C_descriptions{i});
    clf(i)
    plot(t_num{i}, v_num{i});
    hold on;
    plot(t_num{i}, s_num{i});
    xlabel('Tid [s]');
    ylabel('v(t) [m/s] / s(t) [m]');
    legend('Hastighet', 'Posisjon');
    title(sprintf('Numerisk løsning av C = %.2f - %s', C_values(i), C_descriptions{i}));
end

%Sammenligning av treghetsmoment - numerisk
figure('Name', 'Sammenligning av treghetsmoment - numerisk');
legendText = cell(NUM_SIMS, 1);
for i = 1 : NUM_SIMS
   plot(t_num{i}, s_num{i});
   hold on;
   legendText{i} = sprintf('C_{%s}=%.1f',C_descriptions{i}, C_values(i));
end
title('Sammenlignging av treghetsmoment - numerisk');
legend(legendText, 'Location', 'northwest');
xlabel('Tid [s]');
ylabel('Posisjon [m]');
print -depsc numerical



%Sammenligning av treghetsmoment i forsøk
figure('Name', 'Sammenligning av treghetsmoment - forsøk');
for i = 1 : numel(filenames)
    %Load data from mat files
    data = load(filenames{i});
    %Convert data from structure to cell
    data = struct2cell(data);
    %Calucalte average position based on plots
    data = vecs2avg(data);
    %Find first positionelement larger than L and remove everything after
    ix = find(data(2, :) >= L, 1, 'first');
    data = data(:, 1 : ix);
    %Plot the data
    plot(data(1, :), data(2, :))
    hold on;
end
title('Sammenlignings av treghetsmoment - forsøk');
lgd = legend(C_descriptions, 'Location', 'northwest');
xlabel('Tid [s]');
ylabel('Posisjon [m]');
print -depsc experiment

%Sammenligning av resultater fra numerikk og forsøk
figure('Name', 'Sammenligning av treghetsmoment - forsøk og numerikk');
for i = 1 : numel(filenames)
    %Load data from mat files
    data = load(filenames{i});
    %Convert from structure to cell
    data = struct2cell(data);
    %Calculate average
    data = vecs2avg(data);
    %Find first element larger than L, remove everything after
    ix = find(data(2, :) >= L, 1, 'first');
    data = data(:, 1 : ix);
    subplot(numel(filenames), 1, i);
    plot(data(1, :), data(2, :));
    title(C_descriptions{i});
    hold on;
    plot(t_num{i}, s_num{i});
    legend({'Eksperiment', 'Numerisk'}, 'Location', 'northwest');
    xlabel('Tid [s]');
    ylabel('Posisjon[m]');
end
print -depsc num_exp







