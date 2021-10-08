clear
% Loading the data
load("dataset.mat")

% Random Splitting dataset into Training(70%) and Testing(30%)
% As each time the  data gets split randomly using ramdomIndex
% the result will keep changing and will not be constand
splitPercentage = 0.70;
randomIndex = randperm(length(x));

xTrain = x(randomIndex(1:splitPercentage*length(x)),:);
yTrain = y(randomIndex(1:splitPercentage*length(x)),:);

xTest = x(randomIndex(round(splitPercentage*length(x))+1:end),:);
yTest = y(randomIndex(round(splitPercentage*length(x))+1:end),:);


% Post trial and error, an upper bound taken
% where graph was anyway overfitting. 
% Also keeping in mind computation times and complexity.
% Note: We can take it to be  further more as well, 
% this helps in generating
% better focused graphs
upperBoundDegreeOfPolynomial = 60;

%Generating errorTesting and errorTraining vectors from polynomialRegression function
errTrainingVector = [];
errTestingVector  = [];

for i = 1:upperBoundDegreeOfPolynomial
    [err,model,errT] = polynomialRegression(xTrain,yTrain,i,xTest,yTest);
    errTrainingVector= [errTrainingVector ; err];
    errTestingVector = [errTestingVector  ; errT];
end

errTrainingVector;
errTestingVector;

polynomialDegree = (1:upperBoundDegreeOfPolynomial);

% Using the errorTesting and errorTraining Computed, plotting a graph
% between the two for cross validation
clf
figure("Name","CrossValidation");
plot(polynomialDegree,errTrainingVector,'red');

hold on 
plot(polynomialDegree,errTestingVector,'blue')

xlabel('Degree of the polynomial')
ylabel('Rempirical Error')

% Using the ErrTestingVector, Computing the point where it is minimum and
% also that index will be the degree of the polynomial.
% Note*: as in matlab there is no 0 index, the degree computed here will be
% used to compute the actual degree = degree-1 (e.g degree here is 6,
% actual will be 5 in polynomial terms)
[minimumRempTesting, optimumDegreePolynomial] = min(errTestingVector);
xline(optimumDegreePolynomial,'green')
legend('Training Error','Testing Error','Optimal Degree for minError')

% Finding Remp

% Building the polynomial matrix for optimumDegree, using the dataset 'x'
% as Remp will be calculated over the whole data.
xPolynomialMatrix=[];
for i = 1:optimumDegreePolynomial
    xPolynomialMatrix =[xPolynomialMatrix,x.^(i-1)];
end

% Getting the optimal Theta for the optimumDegree for
% the dataset 'x' and 'y'

figure("Name","ModelFitting Over Optimal Degree");
[RempErrTrain,model,RempErrTest] = polynomialRegression(xTrain,yTrain,optimumDegreePolynomial,xTest,yTest);

RempErrTrain 

RempErrTest  

ActualDegree = optimumDegreePolynomial - 1

Theta = model'
