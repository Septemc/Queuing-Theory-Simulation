% 初始化参数
arrivalTime = exprnd(1/lambda, numSimulations, 1); % 车辆到达时间
initialSOC = rand(numSimulations, 1) * 40 + 30; % 当前电量
Desks_chargers = zeros(numChargers, 1); % 充电桩状态，0表示空闲
Desks_queue = cell(numChargers, 1); % 排队队列，每行包含[充电所需时间，充电桩选择]
Desks_queue_pos = ones(numChargers, 1);
Desks_chargers = zeros(servuceDesks, 1); % 充电桩状态，0表示空闲
Desks_queue = cell(servuceDesks, 1); % 排队队列，每行包含[充电所需时间，充电桩选择]
Desks_queue_pos = ones(servuceDesks, 1);
success_num = 0; % 服务客户数量         

