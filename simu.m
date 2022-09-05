% AUTHOR : ROHIT BAGDI
% DATE : 04 APR. 2022
% TITAL : LOW FREQUENCY MODE ESTIMATION USING AMBIENT DATA
% BEFORE TO RUN THIS CODE YOU HAVE TO IMPORT DATA IN COLUMN VECTOR FORM AS PowerInMW
% FOR COMPLETE IMPORT DATA INSTRUCTION  FOLLOQW THE INSTRUCTION WHICH IS
% MENTIONED IN REPORT 
% AFTER THAT DO  clear AND clc IN MATLAB THAN RUN THE CODE 
%----------------------------------------------------------------------------
%----------------------------------------------------------------------------


% Finding the length of data which we have importred 

N=length(PowerInMW);
M=20;

% Finding the Autocorrelation function
for i=1:M+1
    r(i)=0;
    for j = i:N
    r(i)= r(i) +  PowerInMW(j)*PowerInMW(j-i+1);
    end
    r(i)=r(i)/N;
end


rc=zeros(M,1);

% estimation of correlation verctor
for i=2:M+1
    rc(i-1,1)=r(i);
end

% estimation of Auto-correlation matrix
R=zeros(M,M);

for i=1:M
    for j=1:M
        if i==j
            R(i,j)=r(1);
        else
            if i>j
                R(i,j)=r(i-j+1);
            end
            if i<j
                R(i,j)=r(j-i+1);
            end
        end
    end
end

% the FIR filter
w = inv(R)*rc;
%  denominator
den=[1 -w'];

zz=zeros(1,2000);
% numinator for transfer function
num=[1 zz];

H=tf(num,den,1/3);
P=pole(H);
P_n=3*log(P);
nun=[1];
den=[P_n]';
k=1;
S=zpk(nun,den,k);
r=pzplot(S);
system = tf(nun,den);
