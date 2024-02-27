% -------------------------------------------------------------------------
% SENSOR FUSION KALMAN FILTER SIMULATION FOR FALLING BODY WITH DRAG
% -------------------------------------------------------------------------
%
% DESCRIPTION:
% This script simulates a falling body influenced by gravity and air drag.
% Two sensors measure the height and velocity of the body with different 
% accuracies and sample rates. A Kalman filter fuses these measurements 
% to estimate the state of the body.
%
% SETUP:
% - True motion is influenced by parameters g_true (gravity) and k_true (drag coefficient).
% - The Kalman filter uses estimated parameters g_kalman and k_kalman.
% - Height and velocity are measured with different accuracies and sample rates.
%
% PURPOSE:
% The main objectives of this simulation are:
% 1. To demonstrate sensor fusion using a Kalman filter.
% 2. To observe the performance of the Kalman filter when the true system 
%    dynamics and the assumed dynamics are different.
% 3. To visualize the true state, measured state, and the Kalman filter's 
%    estimated state over time.
%
% -------------------------------------------------------------------------

% True motion parameters
g_true = 9.81; % acceleration due to gravity (m/s^2)
k_true = 0.15; % drag coefficient

% Kalman filter parameters
g_kalman = 9.75; % estimated gravity
k_kalman = 0.1; % estimated drag coefficient

% Common parameters
dt = 0.1; % time step (s)
t_end = 50; % end time

% State transition matrices
A_true = [1, dt; 0, 1 - k_true*dt];
B_true = [0.5*dt^2; dt];
A_kalman = [1, dt; 0, 1 - k_kalman*dt];
B_kalman = [0.5*dt^2; dt];

% In this setup there are frequent inaccurate velocity measurements
% and lower rate more accurate distance (height) measurement
% It seems the estimated velocity does not match actual velocity
% Why??? (check the settings in below!)
% R: Because Q is too low, we have very high trust in our guess.

% Measurement matrices and noise covariances
H_pos = [1, 0];
H_vel = [0, 1];
R_pos = 10; % position measurement noise
R_vel = 100; % velocity measurement noise
%Q = 0.01 * eye(2); %original
Q = 1 * eye(2);

% Initial state estimate
x_est = [0; 0];
x_true = [0; 0];
P = eye(2);

% Simulate the Kalman filter over a time period
t = 0:dt:t_end;
z_true = zeros(size(t));
v_true = zeros(size(t));
z_meas_pos = zeros(size(t));
z_meas_vel = zeros(size(t));
z_est = zeros(size(t));
v_est = zeros(size(t));

for i = 1:length(t)
    % Simulate true motion with drag
    x_true = A_true * x_true + B_true * g_true;
    
    % Simulate measurements with noise
    if mod(i,10) == 0 % simulate height sensor with 1/10 the sample rate
        z_meas_pos(i) = x_true(1) + sqrt(R_pos) * randn;
    else
        z_meas_pos(i) = NaN;
    end
    z_meas_vel(i) = x_true(2) + sqrt(R_vel) * randn;
    z_true(i) = x_true(1);
    v_true(i) = x_true(2);

    % Kalman filter prediction step
    x_pred = A_kalman * x_est + B_kalman * g_kalman;
    P_pred = A_kalman * P * A_kalman' + Q;

    % Kalman filter update step for position
    if ~isnan(z_meas_pos(i))
        y_pos = z_meas_pos(i) - H_pos * x_pred;
        S_pos = H_pos * P_pred * H_pos' + R_pos;
        K_pos = P_pred * H_pos' / S_pos;
        x_pred = x_pred + K_pos * y_pos;
        P_pred = (eye(2) - K_pos * H_pos) * P_pred;
    end
    
    % Kalman filter update step for velocity
    y_vel = z_meas_vel(i) - H_vel * x_pred;
    S_vel = H_vel * P_pred * H_vel' + R_vel;
    K_vel = P_pred * H_vel' / S_vel;
    x_est = x_pred + K_vel * y_vel;
    P = (eye(2) - K_vel * H_vel) * P_pred;
    
    % Store estimates
    z_est(i) = x_est(1);
    v_est(i) = x_est(2);
end

% Plot results
figure;
subplot(2,1,1);
plot(t, z_true, 'g', t, z_meas_pos, 'b.', t, z_est, 'r');
legend('True Position', 'Measured Position', 'Estimated Position');
xlabel('Time (s)');
ylabel('Position (m)');
title('Falling Body with Sensor fusion');

subplot(2,1,2);
plot(t, v_true, 'g', t, z_meas_vel, 'b.', t, v_est, 'r');
%plot(t, v_true, 'g', t, z_meas_vel, 'b.');
legend('True Velocity', 'Measured Velocity', 'Estimated Velocity');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
