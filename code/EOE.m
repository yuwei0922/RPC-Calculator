function [L,R] = EOE(u,gps,att,imgtime,jw)
%该函数返回第u个扫描行的外方位元素
%EOE（Elements of Exterior Orientation）
%输入：u：扫描行；imgtime：扫描行成像时间；gps：扫描行的位置矢量
%输入：att：本体到J2000的四元数；ccd：相机坐标系下像元指向角；
%输入：jw：J2000到WGS84坐标系的旋转矩阵
%输出：L：位置矢量；R：旋转矩阵
   %相机坐标系到本体坐标系的旋转角
   pitch_s2b = -0.000511776876952;
   roll_s2b = 0.001828916699906;
   yaw_s2b = 0.003770429577750;
   %内插出成像时刻
   u1 = floor(u);   u2 = ceil(u);
   t1 = imgtime(u1,2);  t2 = imgtime(u2,2);
   t = t1+(t2-t1)*(u-u1);
   %相机坐标系到本体坐标系的旋转矩阵
   R_s2b = RotateMatrix([pitch_s2b,roll_s2b,yaw_s2b]);    
   %内插位置矢量（拉格朗日内插）
   L = gps_inter(t,gps);
   %内插本体坐标系到J2000的四元数（球面内插）
   P = att_inter(t,att);
   %内插J2000到WGS84的旋转角（线性内插）
   E = j2w_inter_yxz(t,jw);
   %总旋转矩阵
   R_b2j = xyzw2R(P);
   R_j2w = RotateMatrix(E);
   R = R_j2w*R_b2j*R_s2b;     %传感器到WGS84坐标系旋转矩阵
end