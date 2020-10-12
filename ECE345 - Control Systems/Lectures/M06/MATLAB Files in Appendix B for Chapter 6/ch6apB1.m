% Nise, N.S. 
% Control Systems Engineering, 8th ed. 
% John Wiley & Sons, Hoboken, NJ, 07030
%
% Control Systems Engineering Toolbox Version 8.0 
% Copyright © 2019 by John Wiley & Sons, Inc.
%
% Chapter 6: Stability
%
% (ch6apB1) Example 6.7: MATLAB can solve for the poles of a transfer function in 
% order to determine stability. To solve for the poles of T(s) use the pole(T) 
% command. Let us look at Example 6.7 in the text.

'(ch6apB1) Example 6.7'             % Display label.
numg=1;                             % Define numerator of G(s).
deng=conv([1 0],[2 3 2 3 2]);       % Define denominator of G(s).
G=tf(numg,deng);                    % Create G(s) object.
'T(s)'                              % Display label.
T=feedback(G,1)                     % Calculate closed-loop T(s) object.
                                    % Negative feedback is default when 
                                    % there is no sign parameter.
poles=pole(T)                       % Find poles of T(s).
                                   
