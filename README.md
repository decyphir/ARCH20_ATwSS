# Automatic Transmission with Simulink Specifications Benchmark
# Version 1.0.0 

This repository contains all data and models related to the benchmark paper "Industrial Temporal Logic Specifications for Falsification of Cyber-Physical Systems".

# Organization 

## Models 

- AT_and_specifications.slx The main Simulink model is at the top level folder 
Simulink models are located in the specRefModels folder. It references the automatic transmission model and the specification models.
- AT_logged_signals.mdl Automatic transmission model. 
- specRefModels/*.slx Models for all requirements. 

## STL files 

STL files are pre-generated and stored in the STLFiles folder. There is one file per requirement, with comments at the beginning indicating which model they were generated from. Note that most of the file consists of comments generated during the conversion from Simulink to STL as performed by the tool specTransformer. The actual STL formula is the last (possibly long) line  of the form 

phi_SPECMODEL_req_or_act := some long formula


# Testing and using

We provide couple of scripts and functions to get started with the falsification. 






