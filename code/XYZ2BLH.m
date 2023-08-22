function y = XYZ2BLH(XYZ)
%该函数用来进行WGS84坐标转换为BLH坐标
%输入：WGS84坐标系下的XYZ坐标
%输出：BLH坐标（经纬度和大地高）
   X = XYZ(1);   Y = XYZ(2);   Z = XYZ(3);
   a = 6378137;    %长半轴
   e2 = 0.00669437999013;   %第一偏心率的平方
   err = 0.0000000001;
   L = atan2(Y,X);
   r = sqrt(X^2+Y^2);
   B1 = atan(Z/r);
   while true
       W1 = sqrt(1-e2*sin(B1)^2);
       N1 = a/W1;
       B2 = atan((Z+N1*e2*sin(B1))/r);
       if abs(B2-B1)<err
           break;
       end
       B1 = B2;
   end
   B = B2;
   W = sqrt(1-e2*sin(B)^2);
   N = a/W;
   H = r/cos(B)-N;
   if isnan(B)
       B = pi/2;
   end
   B = B*180/pi;   L = L*180/pi;
   y = [B L H];
end