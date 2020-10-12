% Nise, N.S. 
% Control Systems Engineering, 8th ed. 
% John Wiley & Sons, Hoboken, NJ, 07030
%
% Control Systems Engineering Toolbox Version 8.0 
% Copyright © 2019 by John Wiley & Sons, Inc.
%
% ch6apF2  (Example 6.9)    MATLAB's Symbolic Math Toolbox also may
% be used conveniently to calculate  the values in a Routh table
% that contains a variable gain, K. The technique is similar to the
% previous example, ch6apF1, except that K, rather than e, is used as the 
% symbolic object. We now demonstrate the solution of Example 6.9 in the
% text using MATLAB and MATLAB's Symbolic Math Toolbox.

'(ch6apF2)  Example 6.9'      % Display label.
% -det([si() si();sj() sj()])/sj()
                              % Template for use in each cell.
syms K                        % Construct a symbolic object for 
                              % gain, K.
s3=[1   77   0   0];          % Create s^3 row of Routh table.
s2=[18   K   0   0];          % Create s^2 row of Routh table.
s1=[-det([s3(1) s3(2);s2(1) s2(2)])/s2(1)...
 -det([s3(1) s3(3);s2(1) s2(3)])/s2(1)   0   0];
                              % Create s^1 row of Routh table.
s0=[-det([s2(1) s2(2);s1(1) s1(2)])/s1(1)... 
 -det([s2(1) s2(3);s1(1) s1(3)])/s1(1)   0   0];
                              % Create s^0 row of Routh table.
's3'                          % Display label.
s3=sym(s3);                   % Convert s3 to a symbolic object.
s3=simplify(s3);              % Simplify terms in s^3 row.
pretty(s3)                    % Pretty print s^3 row.
's2'                          % Display label.
s2=sym(s2);                   % Convert s2 to a symbolic object.
s2=simplify(s2);              % Simplify terms in s^2 row.
pretty(s2)                    % Pretty print s^2 row.
's1'                          % Display label.
s1=sym(s1);                   % Convert s1 to a symbolic object.
s1=simplify(s1);              % Simplify terms in s^1 row.
pretty(s1)                    % Pretty print s^1 row.
's0'                          % Display label.
s0=sym(s0);                   % Convert s0 to a symbolic object.
s0=simplify(s0);              % Simplify terms in s^0 row.
pretty(s0)                    % Pretty print s^0 row.
