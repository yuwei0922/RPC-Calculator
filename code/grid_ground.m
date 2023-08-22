function pt = grid_ground(dem,North,West,dLat,dLon,m,n)
%该函数用来物方经纬度打格网,并内插出高程
%输入：dem；North：左上角点纬度；West：左上角经度
%输入：dLat：纬度采样间隔；dLon：经度采样间隔
%输入：m：纬度划分格网；n：经度划分格网

[row,col] = size(dem);

% 图像分为（m+1,n+1)个间隔，(m,n)个点
a=fix(row/(m+1));
line=a:a:m*a;

b=fix(col/(n+1));
sample=b:b:n*b;

Lat = North-dLat*(line-1);
Lon = West+dLon*(sample-1);

h = double(dem(line,sample));
h = reshape(h,m*n,1);

R = repmat(Lat',n,1);
C = repmat(Lon,m,1);
C = reshape(C,m*n,1);
pt = [R C h];

end