function uv = BackProjection(XYZ,gps,att,imgtime,ccd,jw)
%该函数用来通过严格传感器模型将物方WGS84坐标反投影到像方坐标
%输入：XYZ：物方WGS84坐标系下的坐标
%输入：imgtime：扫描行成像时间；gps：扫描行的位置矢量
%输入：att：四元素和；ccd：像元指向角；jw：JS2000到WGS84坐标系
%输出：uv：像方坐标（u：Line；v：sample）
   %% Step1：采用窗口二分法找到最佳扫描行
   %flag = 1; 
   X = XYZ(1);  Y = XYZ(2);   Z = XYZ(3);
   Ls = 1;  Le = 5378;  L0 = 2689;
   interations = 1;
   while interations<20
       [P1,R1] = EOE(Ls,gps,att,imgtime,jw);
       [dxs,~] = ReverseRPM(X,Y,Z,P1,R1);
       [P2,R2] = EOE(Le,gps,att,imgtime,jw);
       [dxe,~] = ReverseRPM(X,Y,Z,P2,R2);
       [P3,R3] = EOE(L0,gps,att,imgtime,jw);
       [dx0,~] = ReverseRPM(X,Y,Z,P3,R3);
       if dxs*dx0<=0
           Ls = Ls;  Le = L0;  L0 = floor((Ls+Le)/2);
       elseif dx0*dxe<0
           Ls = L0;  Le =Le;  L0 = floor((Ls+Le)/2);
       end
       if abs(Le-Ls)<=20
           break;
       end
       interations = interations+1;
   end
   %%
   if abs(Le-Ls)>20
       uv = zeros(1,2);     %扫描行超出影像覆盖范围，标记为0 [0 0]
   else
       x = [];  y = [];
       for i =Ls:Le
           [P,R] = EOE(i,gps,att,imgtime,jw);
           [dx,dy] = ReverseRPM(X,Y,Z,P,R);
           x = [x;dx];
           y = [y;dy];
       end
       [~,index] = min(abs(x));
       u = Ls+index-1;
       %计算ccd上的y坐标
       y = y(index);
       [~,v] = min(abs(tan(ccd(:,2))-y));     %比较像元指向角
       if v == 8192 || v == 1
           uv = zeros(1,2);       %sample坐标超出影像覆盖区域，标记为0
       else
           uv = [u,v];
       end
   end
end