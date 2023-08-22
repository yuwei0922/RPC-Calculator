function [img,Z]=grid_img(m,n,height,width,k,hmin,hmax)
%该函数用来进行像方的虚拟格网点的划分
%输入：m,n：分别在行列方向划分的格网点个数
%输入：height：图像的高度（行数）；width：图像的宽度（列数）
%输入：k：高程分层层数；hmin：高程最低值；hmax：高程最高值
%输出：img：划分格网点的坐标（行列号）；Z：划分的格网点高程
%第一个点从最底层图像左上角算起，


% 图像分为（m+1,n+1)个间隔，(m,n)个点
a=fix(height/(m+1));
line=a:a:m*a;

b=fix(width/(n+1));
sample=b:b:n*b;

%图像分为k层
detaZ=fix((hmax-hmin)/k);
Z=hmin+detaZ:detaZ:detaZ*k+hmin;

L = repmat(line',n,1);
C = repmat(sample,m,1);
C = reshape(C,m*n,1);
img = [L C];
img = repmat(img,k,1);
Z = repmat(Z,m*n,1);
Z = reshape(Z,m*n*k,1);

end
