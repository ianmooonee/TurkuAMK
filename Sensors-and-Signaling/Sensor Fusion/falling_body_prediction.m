% -------------------------------------------------------------------------
% FALLING BODY KALMAN FILTER SIMULATION
% -------------------------------------------------------------------------
% 
% DESCRIPTION:
% This script simulates the motion of a falling body influenced by gravity
% and air drag. The true motion of the body is simulated using one set of
% parameters, while a Kalman filter estimates the body's position and 
% velocity using a potentially different set of parameters. This setup 
% allows for the exploration of how well the Kalman filter can estimate 
% the state of a system when the true system dynamics and the assumed 
% dynamics (used by the Kalman filter) are different.
%
% SETUP:
% - The true motion of the body is influenced by parameters g_true (gravity),
%   k_true (drag coefficient), and m_true (mass).
% - The Kalman filter uses estimated parameters g_kalman, k_kalman, and m_kalman.
% - Measurements of the body's position are simulated with added noise.
% - There are periods where measurements are intentionally stopped to 
%   observe the Kalman filter's prediction capabilities in the absence of 
%   measurements.
%
% PURPOSE:
% The main objectives of this simulation are:
% 1. To observe the performance of the Kalman filter when the true system 
%    dynamics and the Kalman filter's assumed dynamics are different.
% 2. To understand the behavior of the Kalman filter during periods without 
%    measurements.
% 3. To visualize the true position, measured position, and the Kalman 
%    filter's estimated position and velocity over time.
%
% -------------------------------------------------------------------------


% Parameters for true motion (simulation)
g_true = 9.81; % acceleration due to gravity (m/s^2)
k_true = 0.15; % drag coefficient
m_true = 1; % mass of the body (kg)

% Parameters for Kalman filter
g_kalman = 9.82; % estimated gravity
k_kalman = 0.1; % estimated drag coefficient
m_kalman = 1.2; % estimated mass

% Common parameters
dt = 0.1; % time step (s)
t_end = 100; % end time
t_measure_end = 5; % time when measurements stop
t_measure_restart = 50; % time when measurements restart

% State transition and control input matrices for true motion
A_true = [1, dt; 0, 1 - k_true*dt/m_true];
B_true = [0; dt*g_true/m_true];

% State transition and control input matrices for Kalman filter
A_kalman = [1, dt; 0, 1 - k_kalman*dt/m_kalman];
B_kalman = [0; dt*g_kalman/m_kalman];

% Measurement matrix and noise covariances
H = [1, 0; 0, 1];
Q = 0.01 * eye(2);
R = 0.1 * eye(2);

% Initial state estimate
x_est = [0; 0];
x_true = [0; 0];
P = eye(2);

% Simulate the Kalman filter over a time period
t = 0:dt:t_end;
z_true = zeros(size(t));
z_meas = zeros(size(t));
z_est = zeros(size(t));
v_est = zeros(size(t));

for i = 1:length(t)
    % Simulate true motion
    x_true = A_true * x_true + B_true;
    z_true(i) = x_true(1);
    
    % Simulate measurement (with some noise)
    z_meas(i) = x_true(1) + sqrt(R(1,1)) * 50 * randn;
    
    % Kalman filter prediction step
    x_pred = A_kalman * x_est + B_kalman;
    P_pred = A_kalman * P * A_kalman' + Q;

    if (t(i) <= t_measure_end) || (t(i) > t_measure_restart)
        % Kalman filter update step
        y = [z_meas(i); x_true(2)] - H * x_pred;
        S = H * P_pred * H' + R;
        K = P_pred * H' / S;
        x_est = x_pred + K * y;
        P = (eye(2) - K * H) * P_pred;
    else
        z_meas(i) = NaN;
        x_est = x_pred;
    end
    
    % Store estimates
    z_est(i) = x_est(1);
    v_est(i) = x_est(2);
end

% Plot results
figure;
subplot(2,1,1);
plot(t, z_true, 'g', t, z_meas, 'b.', t, z_est, 'r');
legend('True Position', 'Measured Position', 'Estimated Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(2,1,2);
plot(t, v_est, 'r');
legend('Estimated Velocity');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
