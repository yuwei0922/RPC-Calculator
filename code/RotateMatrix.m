function R = RotateMatrix(x)
%输入为p:pitch；r：roll；y：yaw
%转角顺序（顺规）为Y-X-Z
%输出为旋转矩阵
   p = x(1);  r = x(2);  y = x(3);
   Mp = [cos(p) 0 sin(p);0 1 0;-sin(p) 0 cos(p)];
   Mr = [1 0 0;0 cos(r) -sin(r);0 sin(r) cos(r)];
   My = [cos(y) -sin(y) 0;sin(y) cos(y) 0;0 0 1];
   R = Mp*Mr*My;
end