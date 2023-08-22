function [RFMcoef,Regulationcoef] = RPC(X,Y,Z,R,C)
%输入：Xn,Yn,Zn,Rn,Cn均为n*1的向量
%输出：RFMcoef20*4 RFM参数;Regulationcoef:4*2 标准化参数
epsilon = 1e-4;
n = length(X);

%% 按照定义标准化
[R,R_Off,R_scale] = Normalization(R);
[C,C_Off,C_scale] = Normalization(C);
[X,X_Off,X_scale] = Normalization(X);
[Y,Y_Off,Y_scale] = Normalization(Y);
[Z,Z_Off,Z_scale] = Normalization(Z);

a0=ones(n,1);
A=[a0 Z Y X Z.*Y Z.*X Y.*X Z.^2 Y.^2 X.^2 Z.*Y.*X Z.^2.*Y Z.^2.*X Y.^2.*Z Y.^2.*X...
    X.^2.*Z X.^2.*Y Z.^3 Y.^3 X.^3];
M=[A -diag(R)*A(:,2:20)];
N=[A -diag(C)*A(:,2:20)];

%% 初始化W,计算出J，K初值
Wr0=eye(n);
Wc0=eye(n);
Nbb=M'*Wr0^2*M;
Ndd=N'*Wc0^2*N;
Wb=M'*Wr0^2*R;
Wd=N'*Wc0^2*C;
J1=pinv(Nbb)*Wb;
K1=pinv(Ndd)*Wd;


%% 循环迭代
interations = 1;
while interations < 100
    bb=[1;J1(21:39,1)];
    dd=[1;K1(21:39,1)];
    B=A*bb;
    D=A*dd;
    Wr=diag(1./B);
    Wc=diag(1./D);
    %法方程最小二乘计算
    Nbb=M'*Wr^2*M;
    Ndd=N'*Wc^2*N;
    Wb=M'*Wr^2*R;
    Wd=N'*Wc^2*C;
    %J,K求解
    J2=pinv(Nbb)*Wb;
    K2=pinv(Ndd)*Wd;
    %求解改正数
    Vr = Wr*M*J2-Wr*R;
    Vc = Wc*N*K2-Wc*C;
    if (max(abs([Vr;Vc]))<epsilon)     %收敛条件一
        break;
    end
    J1 = J2;
    K1 = K2;
    interations = interations+1;
end
%%
RFMcoef=[J2(1:20) [1;J2(21:39)] K2(1:20) [1;K2(21:39)]];
Regulationcoef = [R_Off,R_scale;C_Off,C_scale;X_Off,X_scale;Y_Off,Y_scale;Z_Off,Z_scale];
end