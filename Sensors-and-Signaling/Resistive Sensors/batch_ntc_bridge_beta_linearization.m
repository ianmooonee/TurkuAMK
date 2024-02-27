% read batch data
batch = readtable("NTC_batch.txt");
batch_data = batch{:, 2:end};    % extract data skipping first column (row temperatures)
% visual check: outliers, or other odd data?
figure;
plot(batch_data)
% calculate mean response at each temperature
batch_mean = mean(batch_data,2); 
V_NTC = batch_mean';
% then calculate the coeffs like in example, jump to marker -->2
% ----------------------------------------------------------------------

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
subplot(3,1,1);
plot(fitResult, V_NTC, T);
xlabel('Voltage across NTC (Volts)');
ylabel('Temperature (K)');
title('NTC Beta Model Fit for Half-Bridge Configuration');
grid on;
legend('Data', 'Fit');

subplot(3,1,2);
plot(V_NTC, residuals, 'o-');
xlabel('Voltage across NTC (Volts)');
ylabel('Residuals (K)');
title('Residuals');
grid on;

% ----------------------------------------------------------------------
% --> 2 
% Above we calculated data fitting residual for the average of all devices.
% To characterize the complete batch, we need to calculate all device
% deviations from the batch mean (i.e. fitted_T).

% evaluuate model on each elemnt in matrix
batch_data_evaluated = arrayfun(@(x) feval(fitResult, x), batch_data);

% calculate difference to true temperatures (in vector T)
batch_data_errors = batch_data_evaluated - T';

% show histogram and calculate standard deviation (as k=1 uncertainty of
% batch calibration error)

batch_std = std(batch_data_errors(:));
disp("Batch standard deviation: "+ num2str(batch_std));
subplot(3,1,3);
histogram(batch_data_errors, 11);
xlabel('Batch calibration point residuals (degrees C)');