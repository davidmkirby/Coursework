function X=gaussian_mixture(C,mu,N)

cNames=fieldnames(C);
muNames=fieldnames(mu);
aux=mu.(muNames{1});
D=length(aux);
X=[];
for i=1:length(cNames)
    c=C.(cNames{i});
    m=mu.(muNames{i});
    x=randn(D,N(i));
    i
    [Q,l]=eig(c)
    x=Q'*(sqrt(l)) * x;
    
    x=x+repmat(m,1,N(i));
    X=[X x];
end
