# STSimPRMS:A SyncroSim Module for post processing ST - Sim outputs with PRMS.
# Copyright © 2007 - 2018 Apex Resource Management Solution Ltd.(ApexRMS) . All rights reserved.

library(rgdal)
library(raster)
library(rsyncrosim)

GetDataSheet <- function(name, scen) {
    ds = datasheet(scen, name)
    if (NROW(ds) == 0) { stop(paste0("No data for: ", name)) }
    return(ds)
}

GetSingleValue <- function(ds, name) {
    v = ds[, name]
    if (is.na(v)) { stop(paste0("Missing data for: ", name)) }
    return(v)
}

GetFile <- function(ds, name) {
    f = GetSingleValue(ds, name)
    if (!file.exists(f)) { stop(paste0("The file does not exist: ", f)) }
    return(f)
}

GetRowByBasin <- function(df, basinName) {

    r = subset(df, BasinID == basinName)

    if (nrow(r) > 1) {
        stop(paste0("Not expecting multiple rows for basin: ", basinName))
    }

    if (nrow(r) == 1) {
        return(r)
    }
    else {
        return(NULL)
    }
}

GetRowByBasinAndIteration <- function(df, basinName, iteration) {

    r = subset(df, BasinID == basinName & Iteration == iteration & !is.na(Iteration))

    if (nrow(r) > 1) {
        stop(paste0("Not expecting multiple (explicit iteration) rows for basin: ", basinName))
    }

    if (nrow(r) == 1) {
        return(r)
    }

    r = subset(df, BasinID == basinName & is.na(Iteration))

    if (nrow(r) > 1) {
        stop(paste0("Not expecting multiple (wildcard iteration) rows for basin: ", basinName))
    }

    if (nrow(r) == 1) {
        return(r)
    }

    return(NULL)
}

ProcessTemplateControlFile = function(templateFile, outputFile) {

    f1 = file(templateFile, "r")
    f2 = file(outputFile, "w")

    while (TRUE) {

        line = readLines(f1, n = 1)

        if (length(line) == 0) {
            break
        }

        writeLines(line, f2)
    }

    close(f1)
    close(f2)
}

# Globals

Proj = project()
Scen = scenario()
PRMSBasin = GetDataSheet("PRMS_Basin", Proj)
RunControl = GetDataSheet("PRMS_RunControl", Scen)
STSimInput = GetDataSheet("PRMS_InputSTSimScenario", Scen)
ClimateInput = GetDataSheet("PRMS_ClimateInput", Scen)
PRMSInput = GetDataSheet("PRMS_PRMSInput", Scen)
MaxIteration = GetSingleValue(RunControl, "MaximumIteration")
MinIteration = GetSingleValue(RunControl, "MinimumIteration")
MinTimestep = GetSingleValue(RunControl, "MinimumTimestep")
MaxTimestep = GetSingleValue(RunControl, "MaximumTimestep")
LibraryFile = GetFile(STSimInput, "STSimLibraryFile")
ResultScenarioID = GetSingleValue(STSimInput, "ResultScenarioID")
StateAttributeName = GetSingleValue(STSimInput, "StateAttributeName")

for (i in 1:nrow(PRMSBasin)) {

    BasinName = PRMSBasin[i, "Name"]
    PRMSInputRow = GetRowByBasin(PRMSInput, BasinName)

    if (is.null(PRMSInputRow)) {
        next
    }

    BoundaryShapeFile = GetSingleValue(PRMSInputRow, "BoundaryShapeFile")
    TemplateControlFile = GetSingleValue(PRMSInputRow, "TemplateControlFile")
    TemplateParameterFile = GetSingleValue(PRMSInputRow, "TemplateParameterFile")
    InitialHRUValueFile = GetSingleValue(PRMSInputRow, "InitialHRUValueFile")
    HRUCentroidFile = GetSingleValue(PRMSInputRow, "HRUCentroidFile")
    AttributePRMSLookupFile = GetSingleValue(PRMSInputRow, "AttributePRMSLookupFile")

    for (Iteration in MinIteration:MaxIteration) {

        ClimateInputRow = GetRowByBasinAndIteration(ClimateInput, BasinName, Iteration)

        if (is.null(ClimateInputRow)) {
            next
        }

        InputClimateFile = GetSingleValue(ClimateInputRow, "InputClimateFile")

        for (Timestep in MinTimestep:MaxTimestep) {

            # Prepare the GSFLOW input file (e.g. "Basin1-it1-ts1.control")
            # Prepare the GSFLOW param file (e.g. "Basin1-it1-ts1.param")

            # Call GSFLOW

            # Retrieve GSFLOW output and put in output table

        }
    }
}
