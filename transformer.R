# STSimPRMS:A SyncroSim Module for post processing ST - Sim outputs with PRMS.
# Copyright © 2007 - 2018 Apex Resource Management Solution Ltd.(ApexRMS) . All rights reserved.

require(methods)
library(rsyncrosim)

scen = scenario()
stsimScenario = datasheet(scen, name = "PRMS_InputSTSimScenario")
