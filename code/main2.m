%该main2文件用来计算RFM反解系数和精度
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
for i =1:length(control_im)
    XYZ = RPM(control_im(i,1),control_im(i,2),h(i),imgtime,gps,att,ccd,jw);
    control_XYZ(i,:) = XYZ;
    BLH = XYZ2BLH(XYZ);
    control_BLH(i,:) = BLH;
end
%% Step2：计算反解系数
 X = control_BLH(:,1); Y = control_BLH(:,2); Z = control_BLH(:,3);
 R = control_im(:,1);  C = control_im(:,2);
[RFMcoef1,Regulationcoef1] = RPC_P2_P4(R,C,Z,X,Y);   
%% Step3：生成检查点（像方打格网）
[check_im,h_check] = grid_img(15,15,5378,8192,2,hmin,hmax);
check_BLH = zeros(size(check_im,1),3);    %检查点的BLH坐标
check_XYZ = zeros(size(check_im,1),3);
for i =1:length(check_im)
    XYZ = RPM(check_im(i,1),check_im(i,2),h_check(i),imgtime,gps,att,ccd,jw);
    check_XYZ(i,:) = XYZ;
    BLH = XYZ2BLH(XYZ);
    check_BLH(i,:) = BLH;
end
%% Step4：精度评定（物方评定）
%1.控制点精度
control_BL = RFMforward([control_im(:,1),control_im(:,2),control_BLH(:,3)], RFMcoef1,Regulationcoef1);
control_BLH_1 = [control_BL,control_BLH(:,3)];
control_XYZ_1=zeros(size(control_BLH_1,1),3);
for i=1:length(control_BLH_1)
    control_XYZ_1(i,:)=BLH2XYZ(control_BLH_1(i,:));
end
M_BLH_control = sqrt(mean((control_BLH_1-control_BLH).^2));
Mblh__control = sqrt(M_BLH_control(1)^2+M_BLH_control(2)^2+M_BLH_control(3)^2);
M_XYZ_control = sqrt(mean((control_XYZ_1-control_XYZ).^2));
Mxyz_control = sqrt(M_XYZ_control(1)^2+M_XYZ_control(2)^2+M_XYZ_control(3)^2);
%2.检查点精度
check_BL = RFMforward([check_im(:,1),check_im(:,2),check_BLH(:,3)], RFMcoef1,Regulationcoef1);
check_BLH_1=[check_BL(:,1),check_BL(:,2),check_BLH(:,3)];
check_XYZ_1=zeros(size(check_BLH_1,1),3);
for i=1:length(check_BLH_1)
    check_XYZ_1(i,:)=BLH2XYZ(check_BLH_1(i,:));
end
M_BLH_check = sqrt(mean((check_BLH_1-check_BLH).^2));
Mblh_check = sqrt(M_BLH_check(1)^2+M_BLH_check(2)^2+M_BLH_check(3)^2);
M_XYZ_check = sqrt(mean((check_XYZ_1-check_XYZ).^2));
Mxyz_check = sqrt(M_XYZ_check(1)^2+M_XYZ_check(2)^2+M_XYZ_check(3)^2);
