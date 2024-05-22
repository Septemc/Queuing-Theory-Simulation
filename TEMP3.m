% 数据准备
soc = [0, 50, 100]; % 电量百分比
timeData = [0, 0.5, 1.5]; % 对应的充电时间（单位：小时）

% 插值拟合
timeInterpolated = interp1(soc, timeData, 'pchip', 'pp');

% 在一系列SOC值上评估插值函数
socEval = linspace(0, 100, 100);
timeEval = ppval(timeInterpolated, socEval);

% 绘制插值曲线
figure;
plot(socEval, timeEval, 'b-', 'LineWidth', 2);
xlabel('SOC（电量百分比）');
ylabel('充电时间（小时）');
title('插值拟合结果');