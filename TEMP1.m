% 模拟参数
lambda = 10; % 泊松分布参数
numChargers = 7; % 初始充电桩数量
servuceDesks = 1; % 初始换电台数量
numSimulations = 1000; % 模拟次数

% 初始化参数
arrivalTime = exprnd(1/lambda, numSimulations, 1); % 车辆到达时间
initialSOC = rand(numSimulations, 1) * 60 + 10; % 当前电量
chargers = zeros(numChargers, 1); % 充电桩状态，0表示空闲
queue = cell(numChargers, 1); % 排队队列，每行包含[充电所需时间，充电桩选择]
charger_queue_pos = ones(numChargers, 1);
Desks_chargers = zeros(servuceDesks, 1); % 充电桩状态，0表示空闲
Desks_queue = cell(servuceDesks, 1); % 排队队列，每行包含[充电所需时间，充电桩选择]
Desks_queue_pos = ones(servuceDesks, 1);
success_num = 0; % 服务客户数量
use_num = 0; % 换电台使用数量

% 创建充电时间函数句柄
chargingTimeFunc = ChargingTimeFunc();

for sim = 1:numSimulations
    % 车辆到达
    currentTime = arrivalTime(sim);
    SOC = initialSOC(sim);
    
    % 车主充电决策
    if SOC < 20
        % 根据概率选择充电方式
        if rand < 0.65
            % 更换电池
            for i = 1:servuceDesks
                try
                    if Desks_queue{i}(Desks_queue_pos(i))
                        Desks_queue{i}(Desks_queue_pos(i)) = Desks_queue{i}(Desks_queue_pos(i)) - currentTime;
                        while Desks_queue{i}(Desks_queue_pos(i)) <= 0
                            Desks_chargers(i) = Desks_chargers(i) - 1;
                            Desks_queue_pos(i) = Desks_queue_pos(i) + 1;
                            Desks_queue{i}(Desks_queue_pos(i)) = Desks_queue{i}(Desks_queue_pos(i)) + Desks_queue{i}(Desks_queue_pos(i) - 1);
                        end
                    end
                catch
                    continue;
                end
            end
            
            % 换电台选择
            % 找到数组中值为零的元素的索引
            zero_indices = find(Desks_chargers == 0);
            
            % 如果有零元素，则选择第一个零元素的索引
            if ~isempty(zero_indices)
                chargerChoice = zero_indices(1);
            else
                chargerChoice = find(Desks_chargers == min(Desks_chargers));
                if length(chargerChoice) ~= 1
                    chargerChoice = chargerChoice(1);
                end
            end
            
            % 检查排队情况
            waitNum = Desks_chargers(chargerChoice);
            if rand > 0.7^waitNum
                % 客户离开
                continue;
            end
            % 排队
            Desks_chargers(chargerChoice) = Desks_chargers(chargerChoice) + 1;
            timeNeeded = 0.1; % 换电所需时间
            Desks_queue{chargerChoice} = [Desks_queue{chargerChoice}; timeNeeded];
            success_num = success_num + 1;
            use_num = use_num + sum(Desks_chargers);
            continue; % 下一车辆
        end
    end

    for i = 1:numChargers
        try
            if queue{i}(charger_queue_pos(i))
                queue{i}(charger_queue_pos(i)) = queue{i}(charger_queue_pos(i)) - currentTime;
                while queue{i}(charger_queue_pos(i)) <= 0
                    chargers(i) = chargers(i) - 1;
                    charger_queue_pos(i) = charger_queue_pos(i) + 1;
                    queue{i}(charger_queue_pos(i)) = queue{i}(charger_queue_pos(i)) + queue{i}(charger_queue_pos(i) - 1);
                end
            end
        catch
            continue;
        end
    end
    
    % 充电桩选择
    % 找到数组中值为零的元素的索引
    zero_indices = find(chargers == 0);
    
    % 如果有零元素，则选择第一个零元素的索引
    if ~isempty(zero_indices)
        chargerChoice = zero_indices(1);
    else
        chargerChoice = find(chargers == min(chargers));
        if length(chargerChoice) ~= 1
            chargerChoice = chargerChoice(1);
        end
    end
    
    % 检查排队情况
    waitNum = chargers(chargerChoice);
    if rand > 0.7^waitNum
        % 客户离开
        continue;
    end
    
    % 充电
    chargers(chargerChoice) = chargers(chargerChoice) + 1; % 选择充电桩并排队

    targetSOC = rand * (100 - SOC + 20) + SOC + 20;

    % 计算充电所需时间
    timeNeeded = chargingTimeFunc(SOC, targetSOC);

    % 排队
    queue{chargerChoice} = [queue{chargerChoice}; timeNeeded];
    success_num = success_num + 1;
    
end

% 计算客户留存率
retentionRate = success_num / numSimulations;
% 计算换电台空闲率
idleRate = 1 - (use_num / (numSimulations * servuceDesks));
disp(['留存率', num2str(100*retentionRate), '%']);
disp(['空闲率', num2str(100*idleRate), '%']);