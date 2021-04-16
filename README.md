# Automatic Transmission with Simulink Specifications Benchmark
Version: 2.0

This repository contains all data and models related to the benchmark paper "Industrial Temporal Logic Specifications for Falsification of Cyber-Physical Systems". 

The version 2 adds the following:
- a GUI and struct-based configurator to make it easier to initialize falsification problems with custom subsets of the requirements
- A set of configurations adding 11 artificial input signals and corresponding artificial requirements making the falsification problems harder to solve 


## Getting started with falsification

### Getting breach and specTransformer submodules 

We provide scripts and functions to get started with the falsification. The tools Breach and specTransformer are provided for testing and experimentation. They are provided as submodules for the repo. To get them, you need to run the following after cloning this repo: 

```
$ git submodule init
$ git submodule update

```
No additional steps should be needed to install these tools.

### Benchmark initialization and configuration scripts

Running 
```
>> run_ATwSS_with_gui
```
will let you choose the (set of) of requirement(s) you want to configure for falsification and run a short falsification problem. For several requirement, there is a 'base' and possibly several 'hard' instances. By default, 'base' instances should be easy to falsify whereas 'hard' instances should be more challenging.  `Run_ATwSS_with_precfg` and `Run_ATwSS_with_cfg` demonstrate how to run the setup script programmatically.


The file `initializeReqParameters.m` contains the parameters definition for all instances. For example, the following lines
```
hard_cfg.AFE_req.AFE_speedMin = [59 50];
hard_cfg.AFE_req.AFE_subsystem1_notAlwaysTimeHorizon = [0.1 5];
```
mean that the requirement  `AFE_req` has two hard configurations determined by values of parameters `AFE_speedMin` and `AFE_subsystem1_notAlwaysTimeHorizon`. Other parameters for this requirement are set by the structure `base_cfg.AFE_req`. 


## Organization 

### Models 

- `AT_and_specifications.slx` The main Simulink model at the top level folder. It references Simulink models located in the specRefModels folder. It references the automatic transmission model and the specification models.
- `AT_and_specifications_artificial.slx` The main Simulink model to use with artificial inputs.
- `AT_logged_signals.mdl` Automatic transmission model. 
- `specRefModels/*.slx` Models for all requirements.
- `specRefModelsArtificial/*.slx` Models for artificial requirements. 

### STL files 

STL files are pre-generated and stored in the STLFiles and STLFiles_artificial folder. There is one file per requirement, with comments at the beginning indicating which model they were generated from. Note that most of the file consists of comments generated during the conversion from Simulink to STL as performed by the tool specTransformer. The actual STL formula is the last (possibly long) line of the form: 

```
phi_MODELNAME_req := some long formula
```
These files can be re-generated using scripts provided in the repo, though it is not recommended, unless you are interested in the functionning of specTransformer. 







