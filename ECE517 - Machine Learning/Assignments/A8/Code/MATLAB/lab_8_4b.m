%code for Non-linear Gaussian Process for a model for whichthe input
%contains only 5 values of w[n?1] and the output is corrupted by the white
%noise plus AR(1) noise
plus AR(1) noise
clear all; clc;
randn('seed',0);
rng default
rng(1225)
N = 100;
nTrain = 20;
nTest = N-nTrain;
mean = 0;
var = 1;
w = mean + var.*randn(N,1);
B = [1,-2.3695,2.3140,-1.0547,0.1874];
A = [0.0048,0.0193,0.0289,0.0193,0.0048];
output = filter(A,B,w);

r=randperm(N);
index=r(1:nTrain);
% while 1
%     index = unique(randi([1 N],nTrain,1));
%     if length(index)== nTrain
%         break;    
%     end
% end
diffI = setdiff(1:N,index);
%  w = 1:200; 
w1 = [w(1:end)'];
w2 = [0 w(1:end-1)'];
w3 = [0 0 w(1:end-2)'];
w4 = [0 0 0 w(1:end-3)'];
w5 = [0 0 0 0 w(1:end-4)'];
W = [w1;w2;w3;w4;w5];
% 
% f1 = [0 output(1:end-1)'];
% f2 = [0 0 output(1:end-2)'];
% f3 = [0 0 0 output(1:end-3)'];
% f4 = [0 0 0 0 output(1:end-4)'];
% f5 = [0 0 0 0 0 output(1:end-5)'];
% F = [f1;f2;f3;f4;f5];
F=zeros(5,100);

wg = 0.1*randn(N,1);
g = filter(1,[1,-0.2],wg);

X = [F;W];
x_train = X(:,index)';
x_test = X(:,diffI)';
Y = (output+g);
y_train = Y(index);
y_test = Y(diffI);

meanfunc = @meanLinear; hyp.mean = zeros(10,1);
covfunc = {@covSum, {@covSEiso, @covNoise}}; hyp.cov = [0; 0; 0];%non linear part worked out in covfunc
likfunc = @likGauss; hyp.lik = log(0.1);
hyp = minimize(hyp, @gp, -1000, @infExact, meanfunc, covfunc, likfunc, x_train, y_train);
nlml = gp(hyp, @infExact, meanfunc, covfunc, likfunc, x_train, y_train)
%%
figure(3);
[m s2] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, x_train, y_train, x_test);
x = 1:N;
xtest = x(diffI)';
xtrain = x(index)';
fi = [m+2*sqrt(s2); flipdim(m-2*sqrt(s2),1)]; 
fill([xtest; flipdim(xtest,1)], fi, [7 7 7]/8)
hold on; plot(xtest, m, 'b', xtest,y_test,'kx'); plot(xtrain, y_train, '+')
hold off;
axis tight;
xlabel('Input Data');
ylabel('Output Data');
title('Figure 8: Non-linear Gaussian Process with AR Noise + White Noise');
legend('Variance Margin','Predicted Output','Test Data','Training Data');
error3 = sum((m-y_test).^2)/length(m);