format long g
%Read the xls file
A=xlsread('C:\Work\COURSES\SEM-1\MACHINE LEARNIN\ML Project-1\university data.xlsx','university_data','C2:F50');

%Mean of Matrix
MeanA= mean(A);
mu1=MeanA(1);
mu2=MeanA(2);
mu3=MeanA(3);
mu4=MeanA(4);

%Variance of Matrix
VarA=var(A);
var1=VarA(1);
var2=VarA(2);
var3=VarA(3);
var4=VarA(4);

%Standard Deviation of Matrix
SigmaA=std(A);
sigma1=SigmaA(1);
sigma2=SigmaA(2);
sigma3=SigmaA(3);
sigma4=SigmaA(4);

% Covariance of Matrix (4x4 matrix)
covarianceMat= cov(A);

%Correlation of Matrix (4x4 matrix)
correlationMat= corrcoef(A);

% Finding the Log Liklihood of the Matrix
N1= normpdf(A(:,1),mu1,sigma1);
N2= normpdf(A(:,2),mu2,sigma2);
N3= normpdf(A(:,3),mu3,sigma3);
N4= normpdf(A(:,4),mu4,sigma4);
L1=sum(log(N1));
L2=sum(log(N2));
L3=sum(log(N3));
L4=sum(log(N4));
logLikelihood=L1+L2+L3+L4;

%for 4x4 matrix there are 2^16=65535 possible graphs and computing the Directed Acyclic Graphs.
DAGs = [];
j=1;

for n=1:65535
    M=str2num(reshape((dec2bin(n,16))',[],1))';
    R(:,:,(n+1))=reshape(M,[4,4]);
    temp = R(:,:,n);
    if graphisdag(sparse(temp))
        DAGs(:,:,j) = temp;
        j = j+1;
    end
end

% to create a list of parent nodes from the DAGs and compute the mvnpdf
PA=[];
Index=1;
GIndex=[];
for k=1:532
    current = DAGs(:,:,k);
    
    P =0;
    for i=1:4
        temp1 =[];
        for j=1:4
            if (current(j,i) == 1)
                temp1 = [temp1 j];
            end
        end
        if size(temp1)==0
            Den=0;
        else
            Den= sum(log( mvnpdf( A(:, temp1), MeanA(temp1), covarianceMat(temp1,temp1))));
        end
        temp1= [temp1 i];
        Num= sum(log( mvnpdf( A(:, temp1), MeanA(temp1), covarianceMat(temp1,temp1))));
        P = P + (Num-Den);
    end
    PA(Index)=P;
    GIndex(:,Index)= reshape(current,[1,16]);
    Index =Index+1;
end
[BNlogLikelihood, z] = max(PA);
BNgraph= reshape(GIndex(:,z),4,4);

%UB ID Details
UbitName = 'rnayak';
personNumber = 50169647;
        
        
                
                
                
                
       

    

