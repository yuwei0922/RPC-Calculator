function [x,y] = ReverseRPM(X,Y,Z,P,R)
%该函数通过严格传感器模型将物方坐标转化为像元指向角
%输入：(X,Y,Z)：WGS84坐标；P：位置矢量；R：旋转矩阵
%输出：x(其实是tan(phix))，y（其实是tan(phiy)）

   a1=R(1,1); a2=R(1,2); a3=R(1,3);
   b1=R(2,1); b2=R(2,2); b3=R(2,3);
   c1=R(3,1); c2=R(3,2); c3=R(3,3);
   Xs = P(1);  Ys = P(2);  Zs = P(3);
   x = -(a1*(X-Xs)+b1*(Y-Ys)+c1*(Z-Zs))/(a3*(X-Xs)+b3*(Y-Ys)+c3*(Z-Zs));
   y = -(a2*(X-Xs)+b2*(Y-Ys)+c2*(Z-Zs))/(a3*(X-Xs)+b3*(Y-Ys)+c3*(Z-Zs));
end