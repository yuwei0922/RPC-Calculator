function y = j2w_inter_yxz(time,jw)
%该函数内插J2000到WGS84的旋转角
   %找到该时刻前后各一个时间点的jw旋转矩阵
   index1 = find(jw(:,1)<time);
   index2 = find(jw(:,1)>time);
   jw_former = jw(index1(end),:);
   R_former = reshape(jw_former(2:10),3,3);
   R_former = R_former';
   jw_latter = jw(index2(1),:);
   R_latter = reshape(jw_latter(2:10),3,3);
   R_latter= R_latter';
   %从旋转矩阵中分解出旋转角
   eulor1 = deRPY(R_former);
   eulor2 = deRPY(R_latter);
   %对旋转角进行线性内插
   thetay = eulor1(1)+(eulor2(1)-eulor1(1))*(time-jw_former(1))/(jw_latter(1)-jw_former(1));
   thetax = eulor1(2)+(eulor2(2)-eulor1(2))*(time-jw_former(1))/(jw_latter(1)-jw_former(1));
   thetaz = eulor1(3)+(eulor2(3)-eulor1(3))*(time-jw_former(1))/(jw_latter(1)-jw_former(1));
   y = [thetay thetax thetaz];
end