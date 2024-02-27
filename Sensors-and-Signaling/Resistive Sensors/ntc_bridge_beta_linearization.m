% Sample data (replace with your measurements)
%V_NTC = [ 4.5332, 4.2348, 3.8279, 3.3279, 2.7767, 2.2302, 1.7367, 1.3233, 0.9955, 0.7451, 0.5580 ]; % Voltage across NTC in volts
%V_NTC = [ 4.5158,4.2093,3.7941,3.2877, 2.7341,2.1895,1.7010,1.2940, 0.97262,0.72772,0.545012];
T = 253.15:10:353.15; % Temperature in Kelvin

% Known values
V_supply = 5.0; % Supply voltage in volts
R_ref = 10000; % Reference resistor in ohms

% Define the combined model using fittype
combinedModel = fittype('1 / (1/T0 + 1/beta * log((R_ref * V_NTC) / (V_supply - V_NTC) / R0))', ...
    'independent', 'V_NTC', 'problem', {'R_ref', 'V_supply'}, 'coefficients', {'T0', 'beta', 'R0'});

% Perform the fit
fitResult = fit(V_NTC', T', combinedModel, 'StartPoint', [298.15, 3500, 10000], ...
    'problem', {R_ref; V_supply});

% Display the fit result
disp(fitResult);

% Calculate the fitted temperatures for the measured voltages
fitted_T = feval(fitResult, V_NTC);

% Calculate the residuals
residuals = T - fitted_T';

figure;
subplot(2,1,1);
plot(fitResult, V_NTC, T);
xlabel('Voltage across NTC (Volts)');
ylabel('Temperature (K)');
title('NTC Beta Model Fit for Half-Bridge Configuration');
grid on;
legend('Data', 'Fit');

subplot(2,1,2);
plot(V_NTC, residuals, 'o-');
xlabel('Voltage across NTC (Volts)');
ylabel('Residuals (K)');
title('Residuals');
grid on;
