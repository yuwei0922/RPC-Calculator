function LS = RFMforward(BLH, RFMcoef, Regulationcoef)
%   RFMforward 利用RFM模型正算
%   输入经纬度高程，在函数内部进进行标准化, RFM模型参数计算像点坐标
%   直接得到像点坐标(S, L)，即在外部不用再标准化以及反解
%   输出: L = LS(1) S = LS(2)
%   输入: Lat = BLH(1) Lon = BLH(2) Height = BLH(3)
    ROffset = Regulationcoef(1,1);
    RScale = Regulationcoef(1,2);
    COffset = Regulationcoef(2,1);
    CScale = Regulationcoef(2,2);
    XOffset = Regulationcoef(3,1);
    XScale = Regulationcoef(3,2);
    YOffset = Regulationcoef(4,1);
    YScale = Regulationcoef(4,2);
    ZOffset = Regulationcoef(5,1); 
    ZScale = Regulationcoef(5,2);

    X = BLH(:,1); 
    Y = BLH(:,2); 
    Z = BLH(:,3);
    
    L_Num = RFMcoef(:,1);      %行
    L_Den = RFMcoef(:,2);
    S_Num = RFMcoef(:,3);      %列
    S_Den = RFMcoef(:,4);

    %标准化BLH
    X = (X - XOffset) ./ XScale;
    Y = (Y - YOffset) ./ YScale;
    Z = (Z - ZOffset) ./ ZScale;
    
    %rfm计算
    n = size(BLH,1);
    A=[ones(n,1) Z Y X Z.*Y Z.*X Y.*X Z.^2 Y.^2 X.^2 Z.*Y.*X Z.^2.*Y Z.^2.*X Y.^2.*Z Y.^2.*X...
        X.^2.*Z X.^2.*Y Z.^3 Y.^3 X.^3];
    
    line = (A * L_Num) ./ (A * L_Den);
    sample = (A * S_Num) ./ (A * S_Den);
    
    %反标准化
    line = line * RScale + ROffset;
    sample = sample * CScale + COffset;
    
    LS = [line,sample];

end