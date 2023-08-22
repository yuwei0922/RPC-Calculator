function y = BLH2XYZ(BLH)
%该函数用来进行BLH到WGS84坐标系的转换
%输出：WGS84坐标系下的XYZ坐标
   B = BLH(1);  L = BLH(2);   H = BLH(3);
   a = 6378137;    %长半轴
   e2 = 0.00669437999013;   %第一偏心率的平方
   B = B*pi/180;   L = L*pi/180;
   W = sqrt(1-e2*sin(B)^2);
   N = a/W;
   X = (N+H)*cos(B)*cos(L);
   Y = (N+H)*cos(B)*sin(L);
   Z = (N*(1-e2)+H)*sin(B);
   y = [X Y Z];
end