rng('default');
rng(54432);
clear;
n = (linspace(1,100,100))';
%% training input
ntrain  =(linspace(1,100,20))';
% a = [1,-2.3695,2.3140,-1.0547,0.1874]; % AR coeffs
a = [1,-2.3695,2.3140,-1.0547,0.1874]; % AR coeffs
b = [0.0048,0.0193,0.0289,0.0193,0.0048]; % MA coeffs
% T = length(n);
% Ttrain = length(ntrain);
wn = normrnd(0,1,[100,1]); % generate gaussian white noise
% fn = normrnd(0,1,[T,1]); % generate gaussian white noise
yarma = filter(b,a,wn); % generate y

% training set
%%
f = zeros(10,1);
for i = 1:20
    f(i) = yarma(i*5);
end
% fn = normrnd(0,1,[20,1]);

% We need specify the mean, covariance and likelihood functions
%%


meanfunc = {@meanSum, {@meanLinear, @meanConst}}; hyp.mean = [0; 0];
% covfunc = @covSEiso; 
covfunc = {@covSum,{@covLIN,@covConst}};   % Linear covariance function
hyp.cov = 0;
likfunc = @likGauss; sn = 0.1; hyp.lik = log(sn);
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, ntrain, f);
[mu s2] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, ntrain, f, n);

%% fill plot is below
figure(1);
n2 = [n;flip(n)];
inBetween = [mu+2*s2;flip(mu-2*s2)];
filler = fill(n2,inBetween,[7 7 7]/8);
%%
% p2.HandleVisibility = 'off';
hold on;
p1 = plot(yarma,".");
hold on
p2 = plot(ntrain,f,"+"); hold on;
p3 = plot(n,mu,"-o");
ylim([-2,2]);
hLegend = legend({'2\sigma boundary', 'training data' ,'test data', 'predicted output'}, 'Location', 'north')
print -depsc fig2.eps;
