%% 导入电子表格中的数据
% 用于从以下电子表格导入数据的脚本:
%
%    工作簿: F:\文档\MATLAB\充电站排队问题\每日服务数量.xlsx
%    工作表: Sheet1
%
% 由 MATLAB 于 2024-02-17 11:18:57 自动生成

%% 设置导入选项并导入数据
opts = spreadsheetImportOptions("NumVariables", 4);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A2:D21";

% 指定列名称和类型
opts.VariableNames = ["VarName1", "VarName2", "Var3", "VarName4"];
opts.SelectedVariableNames = ["VarName1", "VarName2", "VarName4"];
opts.VariableTypes = ["double", "double", "char", "double"];

% 指定变量属性
opts = setvaropts(opts, "Var3", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var3", "EmptyFieldRule", "auto");

% 导入数据
data = readtable("F:\文档\MATLAB\充电站排队问题\每日服务数量.xlsx", opts, "UseExcel", false);

% 绘制三维图
figure;
scatter3(data(:,2), data(:,3), data(:,1));
xlabel('充电桩日服务数量');
ylabel('换电台日服务数量');
zlabel('每小时车流量');
%% 清除临时变量
clear opts