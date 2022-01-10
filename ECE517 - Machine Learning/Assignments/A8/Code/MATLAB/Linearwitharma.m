rng('default');
rng(54432);
clear;
n = linspace(1,99,100)';
%% Process noise
an = 0.2;

%% training input
ntrain  =(linspace(0,100,100))';
a = [1,-2.3695,2.3140,-1.0547,0.1874]'; % AR coeffs
b = [0.0048,0.0193,0.0289,0.0193,0.0048]'; % MA coeffs
w = normrnd(0,1,[100,1]); % generate gaussian white noise
yarma = filter(b,a,w); % generate y


f = zeros(100,1);

for i = 1:100
    if i ==1
        f(i) = b(1)*w(1)/a(1);
    end
    if i ==2
        f(i) = (b(1)*w(2)+b(2)*w(1)-a(2)*f(1))/a(1);
    end
    if i ==3
        f(i) = (b(1)*w(3)+b(2)*w(2)+b(3)*w(1)-a(2)*f(2)-a(3)*f(1))/a(1);
    end
    if i ==4
        f(i) = (b(1)*w(4)+b(2)*w(3)+b(3)*w(2)+b(4)*w(1)-a(2)*f(3)-a(3)*f(2)-a(4)*f(1))/a(1);
    end
    if i ==5
        f(i) = (b(1)*w(5)+b(2)*w(4)+b(3)*w(3)+b(4)*w(2)+b(5)*w(1)-a(2)*f(4)-a(3)*f(3)-a(4)*f(2)-a(5)*f(1))/a(1);
    end
    if i>5
        %        f(i) = -a'*[f(i-5); f(i-4); f(i-3); f(i-2); f(i-1)]+b'*[w(i-5); w(i-5); w(i-3); w(i-2); w(i-1)];
        f(i) = (-a'*[0; f(i-1); f(i-2); f(i-3); f(i-4)]+b'*[w(i);w(i-1); w(i-2); w(i-3); w(i-4)])/a(1);
            
    end
    
end

%%AR(1) process noise >> x(t) = alpha*x(t-1)+w(t)
wg = normrnd(0,0.1,[100,1]); % generate gaussian white noise
% y(n) = f(n)+g(n)
g = zeros(100,1);
g(1) = wg(1);
for i = 2:100
    g(i) = wg(i) + 0.2*g(i-1);
end



%New label
y = f + g;
% training set
%%
ytrain = y;
% for i = 1:100
%     ytrain(i) = y(i*5);
% end


meanfunc = {@meanSum, {@meanLinear, @meanConst}}; hyp.mean = [0; 0];
% covfunc = @covSEiso; 
covfunc = {@covSum,{@covLIN,@covConst}};   % Linear covariance function
% covfunc = {@covSum,{@covSEiso,@covNoise}};   % Nonlenear cov with white noise
hyp.cov = 0;
likfunc = @likGauss; sn = 0.1; hyp.lik = log(sn);
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, ntrain, y);
[mu s2] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, ntrain, y, n);


%% fill plot is below
figure(1);
n2 = [n;flip(n)];
inBetween = [mu+2*s2;flip(mu-2*s2)];
filler = fill(n2,inBetween,[7 7 7]/8);
%%
% p2.HandleVisibility = 'off';
hold on;
p1 = plot(y,".");
hold on
p2 = plot(ntrain,ytrain,"+"); hold on;
p3 = plot(n,mu,"-o");
% ylim([-2,2]);
hLegend = legend({'2\sigma boundary', 'training data' ,'test data', 'predicted output'}, 'Location', 'north')
print -depsc fig3.eps;