//*********************************************************************************************
// STSimPRMS: A SyncroSim Module for post processing ST-Sim outputs with PRMS.
//
// Copyright © 2007-2018 Apex Resource Management Solution Ltd. (ApexRMS). All rights reserved.
//
//*********************************************************************************************

using System.IO;
using System.Data;
using SyncroSim.Core;

namespace SyncroSim.STSimPRMS
{
    class PRMSInputDataSheet : DataSheet
    {
        public override void AddExternalInputFile(string fileName, DataRow dr, string columnName)
        {
            base.AddExternalInputFile(fileName, dr, columnName);

            if (columnName == "BoundaryShapeFile")
            {
                this.AddRelatedFile(fileName, ".shp.xml", dr, "BoundaryShapeFileSHPXML");
                this.AddRelatedFile(fileName, ".cpg", dr, "BoundaryShapeFileCPG");
                this.AddRelatedFile(fileName, ".dbf", dr, "BoundaryShapeFileDBF");
                this.AddRelatedFile(fileName, ".prj", dr, "BoundaryShapeFilePRJ");
                this.AddRelatedFile(fileName, ".sbn", dr, "BoundaryShapeFileSBN");
                this.AddRelatedFile(fileName, ".sbx", dr, "BoundaryShapeFileSBX");

                this.Changes.Add(new ChangeRecord(this, "Added related shape files"));       
            }
        }

        private void AddRelatedFile(string fileName, string extension, DataRow dr, string columnName)
        {
            string BaseName = Path.GetFileNameWithoutExtension(fileName) + extension;
            string Fullname = Path.Combine(Path.GetDirectoryName(fileName), BaseName);

            if (File.Exists(Fullname))
            {
                dr[columnName] = BaseName;
                base.AddExternalInputFile(Fullname, dr, columnName);
            }
        }
    }
}
