%Generate a gauusian 
close all
clear all
N=100;
X1=randn(2,N)+repmat([2;2],1,N);
%Correlate it
X1=[[1,0.5]*X1;[0.2,1]*X1];
N=100;
X2=randn(2,N)+repmat([2;2],1,N);
%Correlate it
X2=[[1,0.5]*X2;[-0.5,-1]*X2];
%X=[X1 X2];


X3=0.5*randn(2,N)+repmat([0;4],1,N);
%Correlate it
%X3=[[1,0.5]*X3;[-0.5,-1]*X3];
X=[X1 X2 X3];
X=X-repmat(mean(X,2),1,size(X,2)); %Take the mean out

minx=min(X(1,:));
miny=min(X(2,:));
maxx=max(X(1,:));
maxy=max(X(2,:));



R=X*X'/size(X,1);
[Q,l]=eig(R)

Y=randn(2,2*N);
for i=1:2*N
    Z(:,i)=Q*l*Y(:,i);
end
plot(X(1,:),X(2,:),'.')
title('Mixture of Gaussians')
pause

binx=minx:0.1:maxx;
biny=miny:0.1:maxy;
x1=repmat(binx,length(biny),1);
x2=repmat(biny,length(binx),1)';


X=[x1(:) x2(:)];
X=X*Q*sqrt(l^(-1));
x1_=buffer(X(:,1),size(x1,1),0,'nodelay');
x2_=buffer(X(:,2),size(x1,1),0,'nodelay');
PDF=1/sqrt(2*pi)*exp(-(x1_.^2+x2_.^2)/2);
figure(1)
hold on
contour(x1,x2,PDF)
hold off
