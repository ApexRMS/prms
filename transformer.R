# STSimPRMS:A SyncroSim Module for post processing ST - Sim outputs with PRMS.
# Copyright © 2007 - 2018 Apex Resource Management Solution Ltd.(ApexRMS) . All rights reserved.

library(rgdal)
library(raster)
library(rsyncrosim)
library(RSQLite)

GetDataSheet <- function(name, scen) {

    ds = datasheet(scen, name)
    if (nrow(ds) == 0) { stop(paste0("No data for: ", name)) }
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

Enquote <- function(value) {
    return (paste0('\"', value, '\"'))
}

WinFile <- function(fileName) {
    return(gsub("/", "\\", fileName, fixed = T))
}

UnixFile <- function(fileName) {
    return(gsub("\\", "/",  fileName, fixed = T))
}

CreateRuntimeFileName <- function(scen, prefix, basinName, iteration, timestep, extension) {

    outputFolder = envTempFolder("PRMS")
    outputFile = paste0(prefix, ".", basinName, ".it", iteration, ".ts", timestep, ".", extension)
    outputFile = file.path(outputFolder, outputFile)

    return(outputFile)
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

GetStateAttributeRasterName <- function(stsimInputSheet, iteration, timestep) {

    libraryFile = GetFile(stsimInputSheet, "STSimLibraryFile")
    resultscenarioId = GetSingleValue(stsimInputSheet, "ResultScenarioID")
    stateAttributeName = GetSingleValue(stsimInputSheet, "StateAttributeName")

    con = dbConnect(RSQLite::SQLite(), libraryFile)
    on.exit(dbDisconnect(con))

    attrs = dbGetQuery(con, "SELECT * FROM STSim_StateAttributeType")
    r = subset(attrs, Name == stateAttributeName)

    if (nrow(r) == 0) {
        stop(paste0("Cannot find state attribute: ", stateAttributeName))
    }

    id = r$StateAttributeTypeID
    sidpart = paste0("Scenario-", resultscenarioId)

    outputFolder = file.path(paste0(libraryFile, ".output"))
    outputFolder = gsub("\\", "/", outputFolder, fixed = T)
    outputFolder = file.path(outputFolder, sidpart, "STSim_OutputSpatialStateAttribute", fsep = .Platform$file.sep)

    fileName = paste0("sa_", id, ".it", iteration, ".ts", timestep, ".tif")
    fileName = file.path(outputFolder, fileName)

    if (!file.exists(fileName)) {
        stop(paste0("Cannot find file: ", fileName))
    }

    return(fileName)
}

GetVeg30Prj <- function(stsimInputSheet, iteration, timestep) {

    attributeRaster = GetStateAttributeRasterName(stsimInputSheet, iteration, timestep)

    Veg30 <- raster(attributeRaster)
    Veg30prj <- projectRaster(Veg30, res = 30, crs = basinCRS, method = 'ngb')

    return(Veg30prj)
}

GetNHRUValue <- function(templateParameterFile) {

    value = NA
    f1 = file(templateParameterFile, "r")

    while (TRUE) {

        line = readLines(f1, n = 1)

        if (length(line) == 0) {
            break
        }

        if (line == "nhru") {
            value = readLines(f1, n = 1)
            break
        }
    }

    close(f1)

    if (is.na(value)) {
        stop(paste0("Could not find nhru value in: ", templateParameterFile))
    }

    return(value)
}

CreateControlFile = function(
    scen, templateControlFile, basinName, iteration, timestep,
    climateFile, paramFile) {

    outputFile = CreateRuntimeFileName(scen, "gsflow", basinName, iteration, timestep, "control")

    f1 = file(templateControlFile, "r")
    f2 = file(outputFile, "wb")

    while (TRUE) {

        line = readLines(f1, n = 1)

        if (length(line) == 0) {
            break
        }

        if (line == "STSimPRMS_StartTimestep") {
            line = as.character(timestep - 1 + 1986)
        } else if (line == "STSimPRMS_EndTimestep") {
            line = as.character(timestep + 1986)
        } else if (line == "STSimPRMS_InputClimateFile") {
            line = climateFile
        } else if (line == "STSimPRMS_InputParameterFile") {
            line = WinFile(paramFile)
        } else if (line == "STSimPRMS_GSFLOWOutputFile") {
            line = WinFile(CreateRuntimeFileName(scen, "gsflow", basinName, iteration, timestep, "out"))
        } else if (line == "STSimPRMS_ModelOutputFile") {
            line = WinFile(CreateRuntimeFileName(scen, "prms", basinName, iteration, timestep, "out"))
        } else if (line == "STSimPRMS_CSVOutputFile") {
            line = WinFile(CreateRuntimeFileName(scen, "gsflow", basinName, iteration, timestep, "csv"))
        } else if (line == "STSimPRMS_StatVarFile") {
            line = WinFile(CreateRuntimeFileName(scen, "statvar", basinName, iteration, timestep, "dat"))
        } else if (line == "STSimPRMS_AniOutputFile") {
            line = WinFile(CreateRuntimeFileName(scen, "animation", basinName, iteration, timestep, "out"))
        } else if (line == "STSimPRMS_VarSaveFile") {
            line = WinFile(CreateRuntimeFileName(scen, "prms_ic", basinName, iteration, timestep, "out"))
        }

        writeLines(line, f2)
    }

    close(f1)
    close(f2)

    return(outputFile)
}

WriteParamData <- function(values, nhru, f1, f2) {

    # Header lines
    writeLines(readLines(f1, n = 1), f2)
    writeLines(readLines(f1, n = 1), f2)
    writeLines(readLines(f1, n = 1), f2)
    writeLines(readLines(f1, n = 1), f2)

    # Data
    for (i in 1:nhru) {
        readLines(f1, n = 1)
        writeLines(as.character(values[i]), f2)
    }
}

CreateParamFile = function(
    scen, templateParameterFile, basinName, iteration, timestep, nhru,
    cov_type_basin, covden_sum_basin, covden_win_basin, radtrnscf_basin, snow_intcp_basin, srain_intcp_basin, wrain_intcp_basin) {

    outputFile = CreateRuntimeFileName(scen, "gsflow", basinName, iteration, timestep, "param")

    f1 = file(templateParameterFile, "r")
    f2 = file(outputFile, "wb")

    cov_type_found = FALSE
    covden_sum_found = FALSE
    covden_win_found = FALSE
    radtrnscf_found = FALSE
    snow_intcp_found = FALSE
    srain_intcp_found = FALSE
    wrain_intcp_found = FALSE

    while (TRUE) {

        line = readLines(f1, n = 1)

        if (length(line) == 0) {
            break
        }

        if (line == "cov_type 0") {
            writeLines(line, f2)
            WriteParamData(cov_type_basin, nhru, f1, f2)
            cov_type_found = TRUE

        } else if (line == "covden_sum 0") {
            writeLines(line, f2)
            WriteParamData(covden_sum_basin, nhru, f1, f2)
            covden_sum_found = TRUE

        } else if (line == "covden_win 0") {
            writeLines(line, f2)
            WriteParamData(covden_win_basin, nhru, f1, f2)
            covden_win_found = TRUE

        } else if (line == "rad_trncf 15") {
            writeLines(line, f2)
            WriteParamData(radtrnscf_basin, nhru, f1, f2)
            radtrnscf_found = TRUE

        } else if (line == "snow_intcp 0") {
            writeLines(line, f2)
            WriteParamData(snow_intcp_basin, nhru, f1, f2)
            snow_intcp_found = TRUE

        } else if (line == "srain_intcp 0") {
            writeLines(line, f2)
            WriteParamData(srain_intcp_basin, nhru, f1, f2)
            srain_intcp_found = TRUE

        } else if (line == "wrain_intcp 0") {
            writeLines(line, f2)
            WriteParamData(wrain_intcp_basin, nhru, f1, f2)
            wrain_intcp_found = TRUE

        } else {
            writeLines(line, f2)
        }
    }

    close(f1)
    close(f2)

    if (!cov_type_found) { stop(paste0("[cov_type] not found in: ", templateParameterFile)) }
    if (!covden_sum_found) { stop(paste0("[covden_sum] not found in: ", templateParameterFile)) }
    if (!covden_win_found) { stop(paste0("[covden_win] not found in: ", templateParameterFile)) }
    if (!radtrnscf_found) { stop(paste0("[rad_trncf] not found in: ", templateParameterFile)) }
    if (!snow_intcp_found) { stop(paste0("[snow_intcp] not found in: ", templateParameterFile)) }
    if (!srain_intcp_found) { stop(paste0("[srain_intcp] not found in: ", templateParameterFile)) }
    if (!wrain_intcp_found) { stop(paste0("[wrain_intcp] not found in: ", templateParameterFile)) }

    return(outputFile)
}

Call_gsflow_nws <- function(controlFile) {

    e = ssimEnvironment()
    exe = Enquote(UnixFile(file.path(e$ModuleDirectory, "gsflow_nws.exe")))
    cmd = paste(c(exe, Enquote(WinFile(controlFile))), collapse = " ")

    system(cmd, intern = T)
}

# Globals

proj = rsyncrosim::project()
scen = rsyncrosim::scenario()
basinSheet = GetDataSheet("PRMS_Basin", proj)
runControlSheet = GetDataSheet("PRMS_RunControl", scen)
stsimInputSheet = GetDataSheet("PRMS_InputSTSimScenario", scen)
climateInputSheet = GetDataSheet("PRMS_ClimateInput", scen)
inputSheet = GetDataSheet("PRMS_PRMSInput", scen)
outputSheet = datasheet(scen, name = "PRMS_OutputFiles")
maxIteration = GetSingleValue(runControlSheet, "MaximumIteration")
minIteration = GetSingleValue(runControlSheet, "MinimumIteration")
minTimestep = GetSingleValue(runControlSheet, "MinimumTimestep")
maxTimestep = GetSingleValue(runControlSheet, "MaximumTimestep")
inputFolder = envInputFolder(scen, "PRMS_PRMSInput")

# Basin, Iteration, Timestep loop

totalIterations = (maxIteration - minIteration + 1)
totalTimesteps = (maxTimestep - minTimestep + 1)
envBeginSimulation(totalIterations * totalTimesteps)

for (basinRowIndex in 1:nrow(basinSheet)) {

    basinName = basinSheet[basinRowIndex, "Name"]
    basinCRS = basinSheet[basinRowIndex, "CRS"]

    inputRow = GetRowByBasin(inputSheet, basinName)

    if (is.null(inputRow)) {
        next
    }

    templateControlFile = GetSingleValue(inputRow, "TemplateControlFile")
    templateParameterFile = GetSingleValue(inputRow, "TemplateParameterFile")
    initialHRUValueFile = GetSingleValue(inputRow, "InitialHRUValueFile")
    centroidHRUFile = GetSingleValue(inputRow, "HRUCentroidFile")
    attributePRMSLookupFile = GetSingleValue(inputRow, "AttributePRMSLookupFile")
    basinPt <- read.table(centroidHRUFile, header = T)
    vegtype_prms <- read.csv(file = attributePRMSLookupFile)
    basin_prms_orig <- read.csv(file = initialHRUValueFile)
    nHRU = GetNHRUValue(templateParameterFile)

    for (iteration in minIteration:maxIteration) {

        climateRow = GetRowByBasinAndIteration(climateInputSheet, basinName, iteration)

        if (is.null(climateRow)) {
            next
        }

        climateFile = GetSingleValue(climateRow, "InputClimateFile")

        for (timestep in minTimestep:maxTimestep) {

            envReportProgress(iteration, timestep)
            Veg30prj = GetVeg30Prj(stsimInputSheet, iteration, timestep)

            # Create cov_type, covden_sum, covden_win, rad_trnscf, snow_intcp, 
            # srain_intcp, and wrain_intcp rasters using subs function

            cov_type <- subs(Veg30prj, vegtype_prms, by = 1, which = 2)
            covden_sum <- subs(Veg30prj, vegtype_prms, by = 1, which = 3)
            covden_win <- subs(Veg30prj, vegtype_prms, by = 1, which = 4)
            radtrnscf <- subs(Veg30prj, vegtype_prms, by = 1, which = 5)
            snow_intcp <- subs(Veg30prj, vegtype_prms, by = 1, which = 6)
            msrain_intcp <- subs(Veg30prj, vegtype_prms, by = 1, which = 7)
            mwrain_intcp <- subs(Veg30prj, vegtype_prms, by = 1, which = 8)
            ltsrain_intcp <- subs(Veg30prj, vegtype_prms, by = 1, which = 7)
            ltwrain_intcp <- subs(Veg30prj, vegtype_prms, by = 1, which = 8)

            # Aggregation for cov_type using mode to aggregate to 300 m

            cov_type300 <- aggregate(cov_type, fact = 10, fun = 'modal')
            
            # Aggregation for covden_sum, covden_win, radtrnscf, snow_intcp, srain_intcp, wrain_intcp using mean
            
            covden_sum300 <- aggregate(covden_sum, fact = 10, fun = 'mean')
            covden_win300 <- aggregate(covden_win, fact = 10, fun = 'mean')
            radtrnscf300 <- aggregate(radtrnscf, fact = 10, fun = 'mean')
            snow_intcp300 <- aggregate(snow_intcp, fact = 10, fun = 'mean')
            msrain_intcp300 <- aggregate(msrain_intcp, fact = 10, fun = 'mean')
            mwrain_intcp300 <- aggregate(mwrain_intcp, fact = 10, fun = 'mean')
            ltsrain_intcp300 <- aggregate(ltsrain_intcp, fact = 10, fun = 'mean')
            ltwrain_intcp300 <- aggregate(ltwrain_intcp, fact = 10, fun = 'mean')
            
            # Extract the values in the raster layers to a dataframe

            cov_type_extract <- extract(cov_type300, basinPt, method = 'simple', cellnumbers = T, df = T)
            covden_sum_extract <- extract(covden_sum300, basinPt, method = 'simple', cellnumbers = T, df = T)
            covden_win_extract <- extract(covden_win300, basinPt, method = 'simple', cellnumbers = T, df = T)
            radtrnscf_extract <- extract(radtrnscf300, basinPt, method = 'simple', cellnumbers = T, df = T)
            snow_intcp_extract <- extract(snow_intcp300, basinPt, method = 'simple', cellnumbers = T, df = T)
            msrain_intcp_extract <- extract(msrain_intcp300, basinPt, method = 'simple', cellnumbers = T, df = T)
            mwrain_intcp_extract <- extract(mwrain_intcp300, basinPt, method = 'simple', cellnumbers = T, df = T)

            # Create placeholder matrices for parameter
            
            cov_type_basin <- rep(0, nHRU)
            covden_sum_basin <- rep(0, nHRU)
            covden_win_basin <- rep(0, nHRU)
            radtrnscf_basin <- rep(0, nHRU)
            snow_intcp_basin <- rep(0, nHRU)
            srain_intcp_basin <- rep(0, nHRU)
            wrain_intcp_basin <- rep(0, nHRU)

            # Replace values in the matrices with original PRMS values
            
            for (i in 1:nHRU) { cov_type_basin[i] <- basin_prms_orig[i, 4] }
            for (i in 1:nHRU) { covden_sum_basin[i] <- basin_prms_orig[i, 5] }
            for (i in 1:nHRU) { covden_win_basin[i] <- basin_prms_orig[i, 6] }
            for (i in 1:nHRU) { radtrnscf_basin[i] <- basin_prms_orig[i, 7] }
            for (i in 1:nHRU) { snow_intcp_basin[i] <- basin_prms_orig[i, 8] }
            for (i in 1:nHRU) { srain_intcp_basin[i] <- basin_prms_orig[i, 9] }
            for (i in 1:nHRU) { wrain_intcp_basin[i] <- basin_prms_orig[i, 10] }

            # Replace values with LCF extracted values if code in column 1 of [?orig] is 1
            # Dynamic based on ST_Sim

            for (i in 1:nHRU) {
                if (basin_prms_orig[i, 1] == 1) {
                    cov_type_basin[i] <- cov_type_extract[i, 3]
                    covden_sum_basin[i] <- covden_sum_extract[i, 3]
                    covden_win_basin[i] <- covden_win_extract[i, 3]
                    radtrnscf_basin[i] <- radtrnscf_extract[i, 3]
                    snow_intcp_basin[i] <- snow_intcp_extract[i, 3]
                    srain_intcp_basin[i] <- msrain_intcp_extract[i, 3]
                    wrain_intcp_basin[i] <- mwrain_intcp_extract[i, 3]
                }
            }

            paramFile = CreateParamFile(
                scen, templateParameterFile, basinName, iteration, timestep, nHRU,
                cov_type_basin, covden_sum_basin, covden_win_basin, radtrnscf_basin, snow_intcp_basin, srain_intcp_basin, wrain_intcp_basin)

            controlFile = CreateControlFile(
                scen, templateControlFile, basinName, iteration, timestep,
                climateFile, paramFile)

            Call_gsflow_nws(controlFile)

            outputSheet = addRow(outputSheet,
                data.frame(
                    Iteration = iteration, Timestep = timestep, BasinID = basinName,
                    PRMS_OutFile = WinFile(CreateRuntimeFileName(scen, "prms", basinName, iteration, timestep, "out")),
                    PRMS_IC_OutFile = WinFile(CreateRuntimeFileName(scen, "prms_ic", basinName, iteration, timestep, "out")),
                    StatVarDat_OutFile = WinFile(CreateRuntimeFileName(scen, "statvar", basinName, iteration, timestep, "dat"))
                ))

            envStepSimulation()
        }
    }
}

saveDatasheet(scen, outputSheet, "PRMS_OutputFiles")
envEndSimulation()
