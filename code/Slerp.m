function r= Slerp(p,q,t0,t1,t)
%该函数用来进行四元数球面线性插值
%程序考虑了p、q点乘结果为负的情况
%输入：t0时刻的四元数p；t1时刻的四元数q；需要内插的时刻t
%返回的插值结果是r

w0=p(4);x0=p(1);y0=p(2);z0=p(3);
w1=q(4);x1=q(1);y1=q(2);z1=q(3);
%用点乘计算两个四元数夹角的cos值
cosOmega=w0*w1+x0*x1+y0*y1+z0*z1;
%如果点乘为负，则反转一个四元数以取得短的4D弧
if(cosOmega<0.0)
    w1=-w1;
    x1=-x1;
    y1=-y1;
    z1=-z1;
    cosOmega=-cosOmega;
end

%检查他们是否接近，以避免除零
m=size(t,2);%火啊去插值精度，即需要分别在哪一部分插值
for i=1:m
if cosOmega>0.99999999   %cos=1的时候就是夹角为0，重合
    k0=(t1-t(i))/(t1-t0);
    k1=(t(i)-t0)/(t1-t0);
else
    %用三角公式sin?+cos?=1计算sin值
    sinOmega=sqrt(1.0-cosOmega*cosOmega);
    %通过sin和cos计算角度
    omega=atan2(sinOmega,cosOmega); %计算点(cosOmega,sinOmega)与x轴正向的夹角
    %计算分母的倒数，这样就只需要一次除法
    oneOverSinOmega=1.0/sinOmega;
    %计算插值变量
     k0=sin((t1-t(i))/(t1-t0)*omega)*oneOverSinOmega;
     k1=sin((t(i)-t0)/(t1-t0)*omega)*oneOverSinOmega;
end
%插值
w=w0*k0+w1*k1;
x=x0*k0+x1*k1;
y=y0*k0+y1*k1;
z=z0*k0+z1*k1;
r(i,1)=x; r(i,2)=y; r(i,3)=z; r(i,4)=w;
end