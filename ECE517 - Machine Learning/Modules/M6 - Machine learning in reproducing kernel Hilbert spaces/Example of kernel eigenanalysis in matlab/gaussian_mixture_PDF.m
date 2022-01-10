function PDF=gaussian_mixture_PDF(C,mu,X)

cNames=fieldnames(C);
muNames=fieldnames(mu);
aux=mu.(muNames{1});
D=length(aux);
PDF=0;
for i=1:length(cNames)
    c=C.(cNames{i});
    m=mu.(muNames{i});
    [Q,l]=eig(c)
    Xt=inv(sqrt(l)) * Q'*X;
    mt=inv(sqrt(l)) * Q'*m
    
    PDF=PDF+kernelmatrix('rbf',Xt,mt,1)/sqrt(2*pi*det(c));

end
