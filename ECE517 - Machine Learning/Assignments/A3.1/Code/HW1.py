import numpy as np
from matplotlib import pyplot as plt
from sklearn.svm import SVC
import tenvec

c=np.array([[1,1],[2,1.5],[2,1],[3,1.5]])
n=10
sigma=0.2
X=sigma*np.random.randn(n,2)+np.matlib.tile(c[0,:],(n,1))
for i in range(1,4):
    temp = sigma*np.random.randn(n,2)+np.matlib.tile(c[i,:],(n,1))
    X = np.concatenate((X,temp), axis = 0)
    
Y=np.array([1]*2*n+[-1]*2*n)

clf = SVC(kernel="linear", C=100)

clf.fit(X, Y)

w = clf.coef_
b = clf.intercept_

# Making a comparison between our model and that output by scikit-learn.
print(np.sign(np.dot(X,w.T).T + b))
print(clf.predict(X))


#The following is excerpted code from http://scikit-learn.org/stable/auto_examples/svm/plot_svm_margin.html
# get the separating hyperplane
w = clf.coef_[0]
a = -w[0] / w[1]
xx = np.linspace(-5, 5)
yy = a * xx - (clf.intercept_[0]) / w[1]

# plot the parallels to the separating hyperplane that pass through the
# support vectors (margin away from hyperplane in direction
# perpendicular to hyperplane). This is sqrt(1+a^2) away vertically in
# 2-d.
margin = 1 / np.sqrt(np.sum(clf.coef_ ** 2))
yy_down = yy - np.sqrt(1 + a ** 2) * margin
yy_up = yy + np.sqrt(1 + a ** 2) * margin

# plot the data, hyperplane, margins, and support vectors
plt.figure(1)
plt.clf()
plt.plot(xx, yy, 'k-')
plt.plot(xx, yy_down, 'k--')
plt.plot(xx, yy_up, 'k--')

plt.scatter(clf.support_vectors_[:, 0], clf.support_vectors_[:, 1], s=80,
            facecolors='none', zorder=10, edgecolors='k')
plt.scatter(X[:, 0], X[:, 1], c=Y, zorder=10, cmap=plt.cm.Paired,
            edgecolors='k')

# Excerpted code ends here--
plt.axis('tight')
x_min = -2
x_max = 5
y_min = -2
y_max = 5

plt.xlim(x_min, x_max)
plt.ylim(y_min, y_max)

plt.show()


'''
Below we have section 3.2 and 3.3, for 3.2, the variables must be changed 
around so we only run 100 samples. It is currently set up for section 3.3.

'''
N = 500
H = 500

samples = [i for i in range(10,N)]
emp_risk = np.zeros([len(samples),H])
act_risk = np.zeros([len(samples),H])

mean_emp_risk = np.zeros([len(samples)])
mean_act_risk = np.zeros([len(samples)])

c = np.logspace(-1.5,1,100)

for i in range (0, H):
    # Double for loop assures we create enough data for our graphs.
    for j in range(len(samples)):
        
        [x_train, y_train] = tenvec.data(samples[j], 0.3)
        
        # Must take an extra step here because sometimes we don't get uniques
        if len(np.unique(y_train))<2:
            [x_train, y_train] = tenvec.data(samples[j], 0.3)
            
        [x_test, y_test] = tenvec.data(samples[j], 0.3)
        
        # Uncomment for testing 100 samples.
#        [x_train, y_train] = tenvec.data(100, 0.3)
#        if len(np.unique(y_train))<2:
#            [x_train, y_train] = tenvec.data(100, 0.3)
#            
#        [x_test, y_test] = tenvec.data(100, 0.3)        

        clf2 = SVC(kernel="linear", C = 1)
        
        clf2.fit(x_train, y_train)
            
        w_k = clf2.coef_
        b_k = clf2.intercept_
        
        # Calculation of empirical risk
        y_h = np.sign(np.dot(x_train,w_k.T).T + b_k)
        emp_risk[j][i] =  0.5 / samples[j] * np.sum(np.abs(y_h - y_train))
        
        # Calculation of actual risk
        pred_label = clf2.predict(x_test)
        act_risk[j][i] =  0.5 / samples[j] * np.sum(np.abs(pred_label - y_test))
               

# Find the mean of both empirical and actual risks.
mean_emp_risk = np.mean(emp_risk, axis = 1)
mean_act_risk = np.mean(act_risk, axis = 1)

# Define structural risk to be difference between actual and empirical risks
str_risk = mean_emp_risk -  mean_act_risk  

# Plot it all
fig = plt.figure()
plt.semilogx(samples,  mean_emp_risk,'b-',samples, mean_act_risk ,'g-',samples, str_risk, 'r-')
