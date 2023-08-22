function  [RFMcoef,Regulationcoef] = RPC_P2_P4(X,Y,Z,R,C)
%计算的是P2=P4的情况
%输入：Xn,Yn,Zn,Rn,Cn均为n*1的向量
%输出：RFMcoef20*4 RFM参数;Regulationcoef:4*2 标准化参数
epsilon = 1e-4;
n = length(X);

%% 按照定义标准化
[X,X_Off,X_scale] = Normalization(X);
[Y,Y_Off,Y_scale] = Normalization(Y);
[Z,Z_Off,Z_scale] = Normalization(Z);
[R,R_Off,R_scale] = Normalization(R);
[C,C_Off,C_scale] = Normalization(C);

a0=ones(n,1);
A=[a0 Z Y X Z.*Y Z.*X Y.*X Z.^2 Y.^2 X.^2 Z.*Y.*X Z.^2.*Y Z.^2.*X Y.^2.*Z Y.^2.*X...
    X.^2.*Z X.^2.*Y Z.^3 Y.^3 X.^3];
M=[A -diag(R)*A(:,2:20)];

%% 初始化W,计算出J初值
Wr0=eye(n);
Nbb=M'*Wr0^2*M;
Wb=M'*Wr0^2*R;
J1=pinv(Nbb)*Wb;
%% 循环迭代,计算出J值
interations = 1;
while interations < 100
    bb=[1;J1(21:39,1)];
    B=A*bb;
    Wr=diag(1./B);
    %法方程最小二乘计算
    Nbb=M'*Wr^2*M;
    Wb=M'*Wr^2*R;
    J2=pinv(Nbb)*Wb;
    %求解改正数
    Vr = Wr*M*J2-Wr*R;

    if (max(abs(Vr))<epsilon)   %收敛条件一
        break;
    end
    J1 = J2;
interations=interations+1;
end 
%%计算线性方程中K值，其中K2=J2(21:39)
K2=J2(21:39);
P4=A*[1;K2];
K1=pinv(A)*(C.*P4);
%%
RFMcoef=[J2(1:20) [1;J2(21:39)] K1 [1;K2]];
Regulationcoef = [R_Off,R_scale;C_Off,C_scale;X_Off,X_scale;Y_Off,Y_scale;Z_Off,Z_scale];