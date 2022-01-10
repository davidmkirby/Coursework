%% Example of Kernel PCA

close all
clear all
kernel='rbf';
par=0.8;
N=200;
D=2;

%Parameters of the Gaussian mixture to be synthesized. 
C1=[1.2 0.7; 0.7 1.2];mu1=[3,3]';
C2=[1.2 -1;-1 1.2];mu2= [3,-3]';
C3=[0.125 0;0 0.125];mu3=[0,4]';
C.C1=C1;
C.C2=C2;
C.C3=C3;
mu.mu1=mu1;
mu.mu2=mu2;
mu.mu3=mu3;

% Function that synthesize the gaussian
X=gaussian_mixture(C,mu,[N N N]);
figure(1)
plot(X(1,:),X(2,:),'ro')
title('Sample of a Gaussian mixture')

minx=min(X(1,:));
miny=min(X(2,:));
maxx=max(X(1,:));
maxy=max(X(2,:));

K = kernelmatrix(kernel,X,X,par);
M=ones(size(K))/size(K,1);
%K=K+M*K*M-2*K*M;

[Q,L]=eig(K+1*ones(size(K,1)));
l=real(diag(L));
[l,ind]=sort(l);
Q=Q(:,ind);
figure(2)
stem(l)

qm=Q(:,end-D+1:end);
lm=l(end-D+1:end);


binx=minx:0.1:maxx;
biny=miny:0.1:maxy;
x1=repmat(binx,length(biny),1);
x2=repmat(biny,length(binx),1)';


Xm=[x1(:) x2(:)]';

Km = kernelmatrix(kernel,X,Xm,par);
m=ones(size(Km))/size(K,1);
%Km=Km-K*m-M*Km+M*K*m;

Xm=(lm'*qm'*Km);

Xm=buffer(Xm,size(x1,1),0,'nodelay');
figure(1)
hold on
contour(x1,x2,Xm,'k')

hold off

figure(3)
surf(x1,x2,abs(Xm))
shading interp
camlight


Xpdf=[x1(:) x2(:)]';
PDF=gaussian_mixture_PDF(C,mu,Xpdf);

PDF=buffer(PDF,size(x1,1),0,'nodelay');


figure(4)
surf(x1,x2,PDF)
shading interp
camlight
