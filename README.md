# Automatic Transmission with Simulink Specifications Benchmark
Version: 1.0.0 

This repository contains all data and models related to the benchmark paper "Industrial Temporal Logic Specifications for Falsification of Cyber-Physical Systems".

## Organization 

### Models 

- `AT_and_specifications.slx` The main Simulink model at the top level folder 
Simulink models are located in the specRefModels folder. It references the automatic transmission model and the specification models.
- `AT_logged_signals.mdl` Automatic transmission model. 
- `specRefModels/*.slx` Models for all requirements. 

### STL files 

STL files are pre-generated and stored in the STLFiles folder. There is one file per requirement, with comments at the beginning indicating which model they were generated from. Note that most of the file consists of comments generated during the conversion from Simulink to STL as performed by the tool specTransformer. The actual STL formula is the last (possibly long) line  of the form: 

```
phi_MODELNAME_req := some long formula
```

These files can be re-generated using scripts provided in the repo. 

## Running basic falsification problems

### Getting tools 

We provide scripts and functions to get started with the falsification. The tools Breach and specTransformer are provided for testing and experimentation. They are provided as submodules for the repo. To get them, you need to run the following after cloning this repo: 

```
$ git submodule init
$ git submodule update

```
No additional steps should be needed to install these tools.

### Testing

Running 
```
>> run_corners_pseudo_random 
```
will let you choose first specification models to convert into STL formulas, and then specific instances of parameter values. Several requirement can be chose but you should pick either 'base' or one of the 'hard' instances for each requirement. By default, 'base' instances should be easy to falsify whereas 'hard' instances should be more challenging. 

The script will run falsification for 50 corners samples and 100 random samples then provide a summary of the result. 





