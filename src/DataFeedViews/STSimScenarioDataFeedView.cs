﻿// prms: SyncroSim Base Package that integrates the PRMS hydrologic model with ST-Sim.
// Copyright © 2007-2019 Apex Resource Management Solution Ltd. (ApexRMS). All rights reserved.

using SyncroSim.Core;
using SyncroSim.Core.Forms;
using System.Windows.Forms;

namespace SyncroSim.PRMS
{
    public partial class STSimScenarioDataFeedView : DataFeedView
    {
        public STSimScenarioDataFeedView()
        {
            InitializeComponent();
        }

        public override void LoadDataFeed(DataFeed dataFeed)
        {
            base.LoadDataFeed(dataFeed);

            this.SetTextBoxBinding(this.TextBoxLibraryFile, "STSimLibraryFile");
            this.SetTextBoxBinding(this.TextBoxResultScenarioID, "ResultScenarioID");
            this.SetTextBoxBinding(this.TextBoxStateAttributeName, "StateAttributeName");

            this.AddStandardCommands();
        }

        private void SetData(string columnName, object data)
        {
            DataSheet ds = this.DataFeed.GetDataSheet("PRMS_InputSTSimScenario");
            ds.SetSingleRowData(columnName, data);
        }

        private void ClearData(string columnName, object data)
        {
            DataSheet ds = this.DataFeed.GetDataSheet("PRMS_InputSTSimScenario");
            ds.SetSingleRowData(columnName, null);
        }        

        private void ButtonChoose_Click(object sender, System.EventArgs e)
        {
            OpenFileDialog d = new OpenFileDialog();

            d.Title = "Choose ST-Sim Library";
            d.Filter = "ST-Sim Library (*.ssim)|*.ssim";

            if (d.ShowDialog(this) == DialogResult.OK)
            {
                this.SetData("STSimLibraryFile", d.FileName);
            }
        }

        private void ButtonClear_Click(object sender, System.EventArgs e)
        {
            this.ClearData("STSimLibraryFile", null);
        }
    }
}
