import pandas as pd
from sklearn.svm import SVR
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import Ridge
import numpy as np
from sklearn.svm import SVR
from sklearn.model_selection import cross_validate
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import validation_curve


data= np.genfromtxt ("data.csv", delimiter=",")
ftest = data[:,0]
ftrain= data[:,1]
Xtest=data[:,2:21]
Xtrain=data[:,21:40]
ytest=data[:,40]
ytrain=data[:,41]

classifier = Ridge(alpha=1.5)
classifier.fit(Xtrain,ytrain)
prediction=classifier.predict(Xtest)
sqerror = (prediction-ytest)**2
meansquareerror=np.mean((prediction-ytest)**2)
# print(meansquareerror)
score=cross_validate(classifier,Xtrain,ytrain,scoring='neg_mean_squared_error',cv=11,return_train_score=False)
# print(score)
accuracy=cross_val_score(estimator=classifier,X=Xtrain,y=ytrain,cv=11)
np.random.seed(0)
temp=np.arange(ytrain.shape[0])
np.random.shuffle(temp)
Xtrain,ytrain=Xtrain[temp],ytrain[temp]
train_score,valid_score= validation_curve(SVR(),Xtrain,ytrain,"gamma",np.logspace(-1,3,3),cv=6)
#print(train_score)
#print(valid_score)
#print(prediction)
plt.plot(prediction)
# plt.show()
plt.figure(1)
plt.plot(ytest)
plt.legend(['Prediction','Real'])
plt.savefig('RIDGE_prediction.png')
plt.show()

# plt.plot(prediction)
# plt.plot(ytest)
# plt.show()
print(valid_score)
plt.figure(2)
plt.plot(valid_score)
plt.legend(['Valid Score'])
plt.savefig('RIDGE_validation.png')
plt.show()
# plt.show()
# print(score)
#print(score)
#print(prediction)
#print(train_score) #15 datas
#print(valid_score) #15 datas
# plt.plot(ytest)
# plt.show()

# print((prediction))
plt.figure(3)
plt.plot(sqerror)
plt.legend(['Squared Error'])
plt.savefig('RIDGE_squareerror.png')
plt.show()
