batch = readtable('NTC_batch.txt');
batch_data = batch{:, 2:end};
figure;
plot(batch_data);
batch_mean = mean(batch_data, 2);
V_NTC = batch_mean';

%now use the templates: beta and steinhart