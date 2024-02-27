% -------------------------------------------------------------------------
% FALLING BODY WITH DRAG KALMAN FILTER SIMULATION
% -------------------------------------------------------------------------
%
% DESCRIPTION:
% This script simulates the motion of a falling body influenced by gravity
% and air drag using a Kalman filter. The true motion of the body and the 
% Kalman filter both use the same model parameters, including the effect of drag.
%
% SETUP:
% - The motion of the body is influenced by parameters g (gravity), k (drag coefficient),
%   and dt (time step).
% - The Kalman filter uses the same parameters to estimate the body's position and velocity.
% - Measurements of the body's position are simulated with added noise.
%
% PURPOSE:
% The main objectives of this simulation are:
% 1. To observe the performance of the Kalman filter in estimating the state 
%    of a system with drag.
% 2. To visualize the true position, measured position, and the Kalman 
%    filter's estimated position over time.
%
% -------------------------------------------------------------------------

% Parameters
g = 9.81; % acceleration due to gravity (m/s^2)
k = 0.1; % drag coefficient
dt = 0.1; % time step (s)
t_end = 50; % end time

% State transition matrix and control input matrix
A = [1, dt; 0, 1 - k*dt];
B = [0.5*dt^2; dt];

% Measurement matrix and noise covariances
H = [1, 0];
Q = 0.1 * eye(2); % Q indicates the trust in the model
                   % actual g value, no drag
R = 100; % measurement noise covariance is the variance
         % of height uncertainty (K=1) squared,
         % R=100 equals uncertainty 10 meters (k=1)

% Initial state estimate
x_est = [0; 0];
P = eye(2);

% Simulate the Kalman filter over a time period
t = 0:dt:t_end;
z_true = zeros(size(t));
z_meas = zeros(size(t));
z_est = zeros(size(t));
v_est = zeros(size(t));

for i = 1:length(t)
    % ----------------------------------
    % This simulation part you would replace 
    % with actual measuremnts:
    % Simulate true motion with drag
    x_true = A * x_est + B * g;
    z_true(i) = x_true(1);
    
    % Simulate measurement (with some noise)
    z_meas(i) = x_true(1) + sqrt(R) * randn;
    % ----------------------------------

    % Kalman filter prediction step
    x_pred = A * x_est + B * g;
    P_pred = A * P * A' + Q;

    % Kalman filter update step
    y = z_meas(i) - H * x_pred;
    S = H * P_pred * H' + R;
    K = P_pred * H' / S;
    x_est = x_pred + K * y;
    P = (eye(2) - K * H) * P_pred;
    
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
title('Falling Body with Drag Kalman Filter Simulation');

subplot(2,1,2);
plot(t, v_est, 'r');
legend('Estimated Velocity');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
