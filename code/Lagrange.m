function y=Lagrange(x1,y1,x)
%本程序为Lagrange1插值，其中x1,y1
%为插值节点和节点上的函数值，输出为插值点xx的函数值，
%xx可以是向量。
n=length(x1);
for i=1:n
    t=x1;
    t(i)=[];
    L(i)=prod((x-t)./(x1(i)-t));% L向量用来存放插值基函数
end
y=sum(dot(L,y1));
end