% Sample data (replace with your measurements)
%V_NTC = [ 4.5332, 4.2348, 3.8279, 3.3279, 2.7767, 2.2302, 1.7367, 1.3233, 0.9955, 0.7451, 0.5580 ]; % Voltage across NTC in volts
%V_NTC = [ 4.5158,4.2093,3.7941,3.2877, 2.7341,2.1895,1.7010,1.2940, 0.97262,0.72772,0.545012];
T = 253.15:10:353.15; % Temperature in Kelvin

% Known values
V_supply = 5.0; % Supply voltage in volts
R_ref = 10000; % Reference resistor in ohms

% Define the 4-parameter Steinhart-Hart model using fittype
steinhartModel = fittype('1 / (a + b * log(R_ref * V_NTC / (V_supply - V_NTC)) + c * log(R_ref * V_NTC / (V_supply - V_NTC))^2 + d * log(R_ref * V_NTC / (V_supply - V_NTC))^3)', ...
    'independent', 'V_NTC', 'problem', {'R_ref', 'V_supply'}, 'coefficients', {'a', 'b', 'c', 'd'});

% Perform the fit
startPoints = [0.001, 0.0002, -0.0000004, 0.0000001];
fitResult = fit(V_NTC', T', steinhartModel, 'StartPoint', startPoints, ...
    'problem', {R_ref; V_supply});

% Calculate the fitted temperatures for the measured voltages
fitted_T = feval(fitResult, V_NTC);

% Calculate the residuals
residuals = T - fitted_T';

% Display the residuals alongside the main fit:
figure;
subplot(2,1,1);
plot(fitResult, V_NTC, T);
xlabel('Voltage across NTC (Volts)');
ylabel('Temperature (K)');
title('4-Parameter Steinhart-Hart Model Fit for Half-Bridge Configuration');
grid on;
legend('Data', 'Fit');

subplot(2,1,2);
plot(V_NTC, residuals, 'o-');
xlabel('Voltage across NTC (Volts)');
ylabel('Residuals (K)');
title('Residuals');
grid on;
