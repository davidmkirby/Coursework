% Nise, N.S. 
% Control Systems Engineering, 8th ed. 
% John Wiley & Sons, Hoboken, NJ, 07030
%
% Control Systems Engineering Toolbox Version 8.0 
% Copyright © 2019 by John Wiley & Sons, Inc.
%
% (ch6apB3) Example 6.11: We can use MATLAB to determine the stability of a system 
% represented in state space by using the command eig(A) to find the eigenvalues 
% of the system matrix, A. Let us apply the concept to Example 6.11 in the text.

'(ch6apB3) Example 6.11'            % Display label.
A=[0 3 1;2 8 1;-10 -5 -2]           % Define system matrix, A.
eigenvalues=eig(A)                  % Find eigenvalues.
