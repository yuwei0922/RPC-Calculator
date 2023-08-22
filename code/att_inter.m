function p = att_inter(time,att)
%该函数用来进行本体到J2000的四元数内插
%输出：time时刻的四元数
   %找到大于和小于time的前后各一个星历点
   index1 = find(att(:,1)<time);
   index2 = find(att(:,1)>time);
   former = att(index1(end),:);
   latter = att(index2(1),:);
   %进行球面内插
   p = Slerp(former(2:5),latter(2:5),former(1),latter(1),time);   %四元数
end