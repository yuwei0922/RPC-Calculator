function y = RPM(u,v,h,imgtime,gps,att,ccd,jw)
%该函数用来建立严格物理模型Rigorous Physical Model
%输入：u,v:像点坐标(行列号)；h：大地高
%输入：imgtime：扫描行成像时间；gps：扫描行的位置矢量
%输入：att：本体到J2000的四元数；ccd：相机坐标系下像元指向角；
%输入：jw：J2000到WGS84坐标系的旋转矩阵
%输出：对应地面点在WGS84坐标系下的三维坐标
   % 求解扫描行对应的外方位元素
   [L,R] = EOE(u,gps,att,imgtime,jw);
   Xs = L(1);  Ys = L(2);  Zs = L(3);
   
   %建立严格传感器模型
   %内插像元指向角
   v1 = floor(v);   v2 = ceil(v);
   phix1 = ccd(v1,2);   phiy1 = ccd(v1,3);
   phix2 = ccd(v2,2);   phiy2 = ccd(v2,3);
   phix = (phix2-phix1)*(v-v1)+phix1;
   phiy = (phiy2-phiy1)*(v-v1)+phiy1;
   cord_s = [tan(phiy);tan(phix);-1];      %像元在相机坐标系下的坐标
   cord_g = R*cord_s;            %像元在WGS84坐标系下的坐标
   x = cord_g(1);  y = cord_g(2);  z = cord_g(3); 
   %严格传感器模型：cord = P + m*cord_g
   %接下来利用椭球方程求解m
   a = 6378137;   b = 6356752.3;
   A = a+h;   B = b+h;
   %方程系数
   c1 = (x^2+y^2)/A^2+z^2/B^2;
   c2 = 2*((Xs*x+Ys*y)/A^2+Zs*z/B^2);
   c3 = (Xs^2+Ys^2)/A^2+Zs^2/B^2;
   syms t;
   t = solve(c1*t^2+c2*t+c3-1);     %求解一元二次方程
   m = max(double(t));      %m有两个根，取小的根(小的根为负，取大的根)
   y = [Xs;Ys;Zs]+m*cord_g;       %控制点的地面平面坐标
end