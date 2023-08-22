%该main1文件用来计算RFM模型正解系数和精度
clear,clc
att = importdata('att.txt');    %本体坐标到J2000的四元数
gps = importdata('gps.txt');    %卫星位置矢量
ccd = importdata('NAD.txt');    %相机坐标系下的像元指向角
imgtime = importdata('DX_ZY3_NAD_imagingTime.txt');   %扫描行成像时间
jw = importdata('j2w_r.txt');    %J2000到WGS84坐标系的旋转矩阵

%% step1 将影像划分格网选取虚拟控制点
hmin = 20;  hmax = 95;
[control_im,h] = grid_img(10,10,5378,8192,10,hmin,hmax);
control_BLH = zeros(size(control_im,1),3);    %虚拟控制点的BLH坐标
control_XYZ = zeros(size(control_im,1),3);
for i =1:length(control_im)          %严格物理模型求解格网点物方坐标
    XYZ = RPM(control_im(i,1),control_im(i,2),h(i),imgtime,gps,att,ccd,jw);
    control_XYZ(i,:) = XYZ;
    BLH = XYZ2BLH(XYZ);
    control_BLH(i,:) = BLH;
end

%% step2 求解RFM系数
 X = control_BLH(:,1); Y = control_BLH(:,2); Z = control_BLH(:,3);
 R = control_im(:,1);  C = control_im(:,2);
[RFMcoef,Regulationcoef] = RPC(X,Y,Z,R,C);            %P2!=P4
%[RFMcoef,Regulationcoef] = RPC_P2_P4(X,Y,Z,R,C);      %P2=P4

%% step3 获取检查点
dem = imread('dem.tif');

%物方经纬度打格网
North = 35.9654166667;   West = 114.605138889;
dLat = 0.00027777778;  dLon = 0.00027777778; 
check_BLH = grid_ground(dem,North,West,dLat,dLon,20,20);
%反投影变换求检查点像点坐标
check_XYZ = zeros(length(check_BLH),3);
check_im = zeros(length(check_BLH),2);
for i = 1:length(check_BLH)
    XYZ = BLH2XYZ(check_BLH(i,:));
    check_XYZ(i,:) = XYZ;
    check_im(i,:) = BackProjection(XYZ,gps,att,imgtime,ccd,jw);
end
%去掉超过影像范围的检查点
index = find(check_im(:,1)==0);
check_XYZ(index,:) = [];
check_BLH(index,:) = [];
check_im(index,:) = [];

%% Step4 精度评定
%1.计算控制点的像方点位误差
%通过RFM模型求解控制点像点坐标
control_uv = RFMforward(control_BLH, RFMcoef, Regulationcoef);
%计算中误差
M_control = sqrt(mean((control_uv-control_im).^2));
Mxy_control = sqrt(M_control(1)^2+M_control(2)^2);
%2.计算检查点的点位误差
%2.1检查点的像方精度
%通过RFM模型求解像点坐标
check_uv = RFMforward(check_BLH, RFMcoef, Regulationcoef);
%计算中误差
M_check = sqrt(mean((check_uv-check_im).^2));
Mxy_check = sqrt(M_check(1)^2+M_check(2)^2);
%2.2检查点的物方精度评定
for i =1:length(check_uv)
    XYZ = RPM(check_uv(i,1),check_uv(i,2),check_BLH(i,3),imgtime,gps,att,ccd,jw);
    check_XYZ1(i,:) = XYZ;
end
M_XYZ_check = sqrt(mean((check_XYZ1-check_XYZ).^2));
Mxyz_check = sqrt(M_XYZ_check(1)^2+M_XYZ_check(2)^2+M_XYZ_check(3)^2);
