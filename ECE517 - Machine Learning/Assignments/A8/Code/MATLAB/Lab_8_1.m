%code for regression based on linear gaussian process
clear all; clc;
randn('seed',0);
rng default
rng(1225)
N = 100;
nTrain = 20;
nTest = N-nTrain;
mean = 0;
var = 1;
w = mean + var.*randn(100,1);

B = [1,-2.3695,2.3140,-1.0547,0.1874];
A = [0.0048,0.0193,0.0289,0.0193,0.0048];
output = filter(A,B,w);

r=randperm(N);
index=r(1:nTrain);

%%
f = zeros(1,nTrain);
f = output(index);
x = 1:N;
xtrain = x(index)';
ytrain = f;
diffI = setdiff(1:N,index);
xtest = x(diffI)';
ytest = output(diffI);
meanfunc = {@meanSum, {@meanLinear, @meanConst}}; hyp.mean = [0; 0];
covfunc = @covSEiso; hyp.cov = [0; 0];
likfunc = @likGauss; hyp.lik = log(std(xtrain));
hyp = minimize(hyp, @gp, -1000, @infExact, meanfunc, covfunc, likfunc, xtrain, ytrain);
nlml = gp(hyp, @infExact, meanfunc, covfunc, likfunc, xtrain, ytrain)
%%
figure(1)
[m, s2] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, xtrain, ytrain, xtest);
fi = [m+2*sqrt(s2); flipdim(m-2*sqrt(s2),1)]; 
fill([xtest; flipdim(xtest,1)], fi, [0.9 0.9 0.9])
hold on; plot(xtest, m, 'k', xtest,ytest,'k*'); plot(xtrain, ytrain, '+')
hold off;
% xlabel('Input Data');
% ylabel('Output Data');
% title('Figure 2: Experimental set up');
% axis tight;
grid minor;
legend('Variance Margin','Predicted Output','Test Data','Training Data');
error1 = sum((m-ytest).^2)/length(m)
