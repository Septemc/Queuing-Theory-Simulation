% 定义矩形区域的宽度和高度
width = 40;
height = 40;

% 生成矩形区域的顶点坐标
x_rect = [0, width, width, 0, 0];
y_rect = [0, 0, height, height, 0];

% 定义圆形区域的半径和圆心坐标
radius = 12;
x_center = rand() * (width - 2 * radius) + radius;
y_center = rand() * (height - 2 * radius) + radius;

% 生成圆形区域的角度
theta = linspace(0, 2*pi, 100);

% 生成圆形区域的坐标
x_circle = radius * cos(theta) + x_center;
y_circle = radius * sin(theta) + y_center;

% 在圆形区域内随机生成21个点
num_points_circle = 21;
theta_points_circle = rand(num_points_circle, 1) * 2 * pi;
r_points_circle = sqrt(rand(num_points_circle, 1)) * radius;
x_points_circle = r_points_circle .* cos(theta_points_circle) + x_center;
y_points_circle = r_points_circle .* sin(theta_points_circle) + y_center;

% 在矩形区域内随机生成14个点，但不包括圆形区域
num_points_rect = 14;
x_points_rect = [];
y_points_rect = [];

while numel(x_points_rect) < num_points_rect
    x = rand() * width;
    y = rand() * height;
    
    % 检查点是否在圆形区域内
    if inpolygon(x, y, x_circle, y_circle)
        continue;
    end
    
    x_points_rect = [x_points_rect; x];
    y_points_rect = [y_points_rect; y];
end

% 保存points_circle坐标
points_circle = [x_points_circle, y_points_circle];

% 保存points_rect坐标
points_rect = [x_points_rect, y_points_rect];

% 绘制矩形区域、圆形区域和随机生成的点
hold on;
plot(x_rect, y_rect, 'b-');
plot(x_circle, y_circle, 'r-');
plot(x_points_circle, y_points_circle, 'ro');
plot(x_points_rect, y_points_rect, 'bo');
axis equal;  % 设置坐标轴比例相等，保证图形显示为正方形
grid on;  % 显示网格线