function y = gps_inter(time,gps)
%采用拉格朗日内插方法获得gps位置
   %找到扫描行成像时刻前后四个时间点的位置矢量
   index1 = find(gps(:,1)<time);
   index2 = find(gps(:,1)>time);
   gps_sample = [gps(index1(end-3:end),:);gps(index2(1:4),:)];
   %内插
   Px = Lagrange(gps_sample(:,1),gps_sample(:,2),time);
   Py = Lagrange(gps_sample(:,1),gps_sample(:,3),time);
   Pz = Lagrange(gps_sample(:,1),gps_sample(:,4),time);
   y = [Px Py Pz];
end