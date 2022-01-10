%Generate a gauusian 
close all
N=200;
X=randn(2,N);
%Correlate it
X=[[1,0.5]*X;[1,0.1]*X];
plot(X(1,:),X(2,:),'o')
title('Gaussian sample')
axis([-4 4 -4 4])
pause
R=X*X'/N;
[Q,l]=eig(R)

Y=randn(2,N);
for i=1:N
    Z(:,i)=Q*sqrt(l)*Y(:,i);
end
figure(2)
plot(Z(1,:),Z(2,:),'o')
title('Gaussian sample generated from incorrelated pdf')
axis([-4 4 -4 4])
pause

binx=-3:0.1:3;
biny=-3:0.1:3;
x1=repmat(binx,length(biny),1);
x2=repmat(biny,length(binx),1)';

PDF=1/sqrt(2*pi)*exp(-(x1.^2+x2.^2)/2);
figure(3)
contour(x1,x2,PDF)
pause
PDF=1/sqrt(2*pi)*exp(-(x1.^2*l(1,1)+x2.^2*l(2,2))/2);
figure(4)
contour(x1,x2,PDF)
pause
X=[x1(:) x2(:)];
X=X*Q*sqrt(l^(-1));
x1_=buffer(X(:,1),sqrt(size(X,1)),0,'nodelay');
x2_=buffer(X(:,2),sqrt(size(X,1)),0,'nodelay');
PDF=1/sqrt(2*pi)*exp(-(x1_.^2+x2_.^2)/2);
figure(1)
hold on
contour(x1,x2,PDF)
hold off
