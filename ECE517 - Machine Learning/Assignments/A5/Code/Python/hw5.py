import pandas as pd
from sklearn.svm import SVR
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv("data.csv",header =None,index_col=None)
df1 = df.iloc[:,0:2] # Remember that Python does not slice inclusive of the ending index.
ftest = df.iloc[:,0]
ftrain = df.iloc[:,1]
Xtest = df.iloc[:,2:20]
Xtrain = df.iloc[:,21:39]
ytest = df.iloc[:,40]
ytrain = df.iloc[:,41]

#print(df)
#a = df[0;3]
#print(df1)
#Xtrain = df
clf = SVR(gamma = 'scale', C = 1., epsilon = 0.2)
regr = clf.fit(Xtrain,ytrain)
pred = clf.predict(Xtest)
plt.plot(pred)
plt.show()
