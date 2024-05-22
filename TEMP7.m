% 模拟参数
lambda = 30; % 泊松分布参数
numChargers = 40; % 初始充电桩数量
serDesks = 3; % 初始换电台数量
numSimulations = 1000;
[retentionRate, useRate, success_num, use_num] = simulateCharging(lambda,numChargers,serDesks,numSimulations);