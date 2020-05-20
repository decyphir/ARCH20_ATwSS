%% Initialiaze paths for executing ATSS benchmarks 
addpath('./breach');
InitBreach;
addpath('./specTransformer/');
addpath('./src');
addpath('./specRefModels');
bdclose('AT_and_specifications_breach');

%% init instances
initializeReqParameters;

%Bparams = BreachSet(params);




