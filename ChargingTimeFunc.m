function chargingTimeFunc = ChargingTimeFunc()
    % 数据准备
    soc = [0, 50, 100]; % 电量百分比
    timeData = [0, 0.5, 1.5]; % 对应的充电时间（单位：小时）

    % 插值拟合
    timeInterpolated = interp1(soc, timeData, 'pchip', 'pp');

    % 定义插值函数
    chargingTimeFunc = @(startSOC, targetSOC) ppval(timeInterpolated, targetSOC) * (targetSOC - startSOC) / 100;
end
