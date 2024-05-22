lambdaValues = []; % 存储满足条件的lambda值
xValues = []; % 存储对应的x值
yValues = []; % 存储对应的y值
numSimulations = 1000; % 模拟次数
temp_x = 0;

for l = 1:20
    disp(num2str(l));
    for x = 1:30 % 更改x的范围根据实际情况调整
        % 模拟参数
        lambda = l; % 泊松分布参数
        numChargers = x; % 初始充电桩数量
        serDesks = 1; % 初始换电台数量
        retentionRate_all = 0;
        useRate_all = 0;
        % 计算留存率和使用率
        for i = 1:5
            [retentionRate, useRate, success_num, use_num] = simulateCharging(lambda,numChargers,serDesks,numSimulations);
            retentionRate_all = retentionRate_all + retentionRate;
            useRate_all = useRate_all + useRate;
        end
        retentionRate = retentionRate_all / 5;
        useRate = useRate_all / 5;

        % 判断是否满足条件
        if retentionRate >= 0.9
            temp_x = numChargers;
            break;
        end
    end
    for y = 1:10 % 更改y的范围根据实际情况调整
        % 模拟参数
        lambda = l; % 泊松分布参数
        numChargers = temp_x; % 初始充电桩数量
        serDesks = 11-y; % 初始换电台数量
    
        % 计算留存率和使用率
        [retentionRate, useRate, success_num, use_num] = simulateCharging(lambda,numChargers,serDesks,numSimulations);
    
        % 判断是否满足条件
        if useRate >= 0.4
            lambdaValues = [lambdaValues, lambda];
            xValues = [xValues, numChargers];
            yValues = [yValues, serDesks];
            break;
        end
    end
end

% 绘制三维图
figure;
scatter3(xValues, yValues, lambdaValues);
xlabel('充电桩数量');
ylabel('换电服务台数量');
zlabel('lambda值');