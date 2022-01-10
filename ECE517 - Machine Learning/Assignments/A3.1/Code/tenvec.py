# -*- coding: utf-8 -*-
"""
Created on Sun Sep 24 21:42:31 2017

@author: cattius
"""
import numpy as np
import numpy.matlib as matlib
def data(N,sigma):
    x = [[]*10]*4
    
    w=np.ones(10)/np.sqrt(10)
    
    w1=[ 1,  1,  1,  1 , 1 ,-1 ,-1 ,-1 ,-1, -1]*w
    
    w2=[-1 ,-1,  0 , 1 , 1 ,-1 ,-1, 0,  1,  1]*w
    
    w2=w2/np.linalg.norm(w2)
    
    x[0]=np.zeros(10)
    
    x[1]=x[0]+sigma*w1
    
    x[2]=x[1]+sigma*w2

    x[3]=x[2]+sigma*w1
    
    X1=x+sigma*np.matlib.repmat(w,4,1)/2
    
    X2=x-sigma*np.matlib.repmat(w,4,1)/2
    
    X1=np.matlib.repmat(X1,2*N,1)
    
    X2=np.matlib.repmat(X2,2*N,1)
    
    X=np.concatenate((X1,X2))
    
    X = np.array(X)
   
    Yn= np.array([1]*4*2*N+[-1]*4*2*N)
    
    Z=np.random.permutation(8*2*N)
    
    Z=Z[0:N]
    
    X=X[Z]+np.matlib.repmat(0.2*sigma*np.random.randn(np.size(X[Z],1)),N,1)
    
    Yn=Yn[Z]
    
    return [X,Yn]