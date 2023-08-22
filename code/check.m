%可视化检查各项参数
%% 检查外方位元数
L = [];
P = [];
E = [];
for i = 1:5378
    t = imgtime(i,2);
    a = gps_inter(t,gps);
    b = att_inter(t,att);
    c = j2w_inter_yxz(t,jw);
    L = [L;a];
    P = [P;b];
    E = [E;c];
end

%位置矢量
figure('name','位置矢量随时间的变换')
subplot(3,1,1)
plot([1:5378]',L(:,1),'b-', 'LineWidth', 2);
xlabel('time'); ylabel('Px');
subplot(3,1,2)
plot([1:5378]',L(:,2),'b-', 'LineWidth', 2);
xlabel('time'); ylabel('Py');
subplot(3,1,3)
plot([1:5378]',L(:,3),'b-', 'LineWidth', 2);
xlabel('time'); ylabel('Pz');

%四元数
figure('name','四元数随时间的变换');;
subplot(4,1,1)
plot([1:5378]',P(:,1),'r-', 'LineWidth', 2);
xlabel('time'); ylabel('x');
subplot(4,1,2)
plot([1:5378]',P(:,2),'r-', 'LineWidth', 2);
xlabel('time'); ylabel('y');
subplot(4,1,3)
plot([1:5378]',P(:,3),'r-', 'LineWidth', 2);
xlabel('time'); ylabel('z');
subplot(4,1,4)
plot([1:5378]',P(:,4),'r-', 'LineWidth', 2);
xlabel('time'); ylabel('w');

%j2000到wgs84的欧拉角
figure('name','J2000转WGS84的欧拉角随时间的变换');
subplot(3,1,1)
plot([1:5378]',E(:,1),'g-', 'LineWidth', 2);
xlabel('time'); ylabel('thetay');
subplot(3,1,2)
plot([1:5378]',E(:,2),'g-', 'LineWidth', 2);
xlabel('time'); ylabel('thetax');
subplot(3,1,3)
plot([1:5378]',E(:,3),'g-', 'LineWidth', 2);
xlabel('time'); ylabel('thetaz');

%% 检查虚拟控制点
figure('name','BLH空间的虚拟控制点');
c=control_BLH(:,3);
scatter3(control_BLH(:,1),control_BLH(:,2),control_BLH(:,3),20,c,'filled');
xlabel('纬度B'); ylabel('经度L');  zlabel('大地高H');

figure('name','WGS84空间的虚拟控制点');
c=control_XYZ(:,3);
scatter3(control_XYZ(:,1),control_XYZ(:,2),control_XYZ(:,3),20,c,'filled');
xlabel('X'); ylabel('Y');  zlabel('Z');

%% 检查检查点设置
figure('name','BLH空间的检查点');
c=check_BLH(:,3);
scatter3(check_BLH(:,1),check_BLH(:,2),check_BLH(:,3),20,c,'filled');
xlabel('纬度B'); ylabel('经度L');  zlabel('大地高H');

figure('name','WGS84空间的检查点');
c=check_XYZ(:,3);
scatter3(check_XYZ(:,1),check_XYZ(:,2),check_XYZ(:,3),20,c,'filled');
xlabel('X'); ylabel('Y');  zlabel('Z');