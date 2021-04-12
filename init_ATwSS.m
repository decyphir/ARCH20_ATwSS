%% Initialiaze paths for executing ATSS benchmarks 
addpath('./breach');
InitBreach;
addpath('./specTransformer/');
addpath('./src');
addpath('./specRefModels');
addpath('./specRefModelsArtificial');
addpath('./STLFiles')
addpath('./STLFiles_artificial')

bdclose('AT_and_specifications_breach');
bdclose('AT_and_specifications_artificial_breach');


%% init instances
initializeReqParameters;

%Bparams = BreachSet(params);




