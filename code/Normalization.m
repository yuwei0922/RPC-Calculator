function [X,X0,Xs] = Normalization(Xn)
X0=mean(Xn);
Xs=max(abs(max(Xn)-X0),abs(min(Xn)-X0));
X=(Xn-X0)./Xs;
end