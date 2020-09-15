%example 1 SVM

%% Data generation
x=randn(2,30)*2+[1;2]*ones(1,30);
y=ones(30,1);
x=[x randn(2,30)*2+[-1;-2]*ones(1,30)];
y=[y;-ones(30,1)];

figure(1)
plot(x(1,y==1),x(2,y==1),'r+')
hold on
plot(x(1,y==-1),x(2,y==-1),'k+')
hold off
keyboard

%% Training the SVM
options='-s 0 -t 0 -c 100 -h 0';
% -s means Support Vector Machine; -t means it's linear; parameter C=100;
% -h silences output messages
model=svmtrain(y,x',options); % Here, we compute the kernel matrix inside.
keyboard
% Type model in the command window to see the support structure. sv_indices
% are the positions of the model, sv_coef are the coefficients alpha times
% the labels.
%% SVM test (we use the training data)
y2=svmpredict(y,x',model);
keyboard

%% Extracting the parameters
b=-model.rho; % This is the bias. Do not forget to change the sign.
alpha=model.sv_coef; % These are the duals, already multiplied by the labels.
idx=model.sv_indices; % The indices of the samples that are SVs.
w=x(:,idx)*alpha; % This is the primal. Just to represent the margin.
keyboard

%% Plot the support vectors