lambdaValues = []; % 存储满足条件的lambda值
xValues = []; % 存储对应的x值
yValues = []; % 存储对应的y值
numSimulations = 500; % 模拟次数
temp_x = 0;
s_N = [];
u_N = [];

cur_x = 1;
cur_y = 1;
for l = 1:30
    disp(num2str(l));
    for x = cur_x:3 % 更改x的范围根据实际情况调整
        % 模拟参数
        lambda = l; % 泊松分布参数
        numChargers = 1; % 初始充电桩数量
        serDesks = x; % 初始换电台数量
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
        if useRate <= 0.5
            temp_x = serDesks;
            cur_x = x;
            break;
        end
    end
    for y = cur_y:40 % 更改y的范围根据实际情况调整
        % 模拟参数
        lambda = l; % 泊松分布参数
        numChargers = y; % 初始充电桩数量
        serDesks = temp_x; % 初始换电台数量
        retentionRate_all = 0;
        useRate_all = 0;
        success_num_all = 0;
        use_num_all = 0;
        % 计算留存率和使用率
        for i = 1:5
            [retentionRate, useRate, success_num, use_num] = simulateCharging(lambda,numChargers,serDesks,numSimulations);
            retentionRate_all = retentionRate_all + retentionRate;
            useRate_all = useRate_all + useRate;
            success_num_all = success_num_all + success_num;
            use_num_all = use_num_all + use_num;
        end
        retentionRate = retentionRate_all / 5;
        useRate = useRate_all / 5;
        success_num = success_num_all / 5;
        use_num = use_num_all / 5;

        % 判断是否满足条件
        if retentionRate >= 0.9
            lambdaValues = [lambdaValues, lambda];
            xValues = [xValues, numChargers];
            yValues = [yValues, serDesks];
            s_N = [s_N;success_num, numChargers];
            u_N = [u_N;use_num, serDesks];
            cur_y = y;
            break;
        end
    end
end

% 绘制三维图
figure(1);
scatter3(xValues, yValues, lambdaValues);
xlabel('充电桩数量');
ylabel('换电服务台数量');
zlabel('每小时车流量（lambda）');

figure(2);
scatter3(s_N(:,1)', u_N(:,1)', lambdaValues);
xlabel('充电桩日服务数量');
ylabel('换电台日服务数量');
zlabel('每小时车流量（lambda）');