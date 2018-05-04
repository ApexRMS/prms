# STSimPRMS:A SyncroSim Module for post processing ST - Sim outputs with PRMS.
# Copyright © 2007 - 2018 Apex Resource Management Solution Ltd.(ApexRMS) . All rights reserved.

require(methods)
library(rgdal)
library(raster)
library(rsyncrosim)

GetDataSheet <- function(name, scen){
  ds = datasheet(scen, name)
  if (NROW(ds)==0){stop(paste0("No data for: ", name))}
  return(ds)
}

GetSingleValue <- function(ds, name){
  v = ds[,name]
  if (is.na(v)) {stop(paste0("Missing data for: ", name))}
  return (v)
}

GetFile <- function(ds, name){
  f = GetSingleValue(ds, name)
  if (!file.exists(f)){stop(paste0("The file does not exist: ", f))}
  return(f)
}

ProcessTemplateControlFile = function(templateFile, outputFile) {
  
  f1 = file(templateFile, "r")
  f2 = file(outputFile, "w")
  
  while (TRUE){
    
    line = readLines(f1, n = 1)
    
    if (length(line) == 0 ) {
      break
    }
    
    writeLines(line, f2)
  }
  
  close(f1)
  close(f2)
}

Scen = scenario()
Env = ssimEnvironment()
RunControl = GetDataSheet("PRMS_RunControl", Scen)
STSimInput = GetDataSheet("PRMS_InputSTSimScenario", Scen)

MaxIteration = GetSingleValue(RunControl, "MaximumIteration")
MinIteration = GetSingleValue(RunControl, "MinimumIteration")
MinTimestep = GetSingleValue(RunControl, "MinimumTimestep")
MaxTimestep = GetSingleValue(RunControl, "MaximumTimestep")

LibraryFile = GetFile(STSimInput, "STSimLibraryFile")
ResultScenarioID = GetSingleValue(STSimInput,"ResultScenarioID")

for (Iteration in MinIteration:MaxIteration) {
  
  for (Timestep in MinTimestep:MaxTimestep) {
    
  }
}

