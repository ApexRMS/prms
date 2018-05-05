namespace SyncroSim.STSimPRMS
{
    partial class STSimScenarioDataFeedView
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.TextBoxLibraryFile = new System.Windows.Forms.TextBox();
            this.ButtonChoose = new System.Windows.Forms.Button();
            this.ButtonClear = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.TextBoxResultScenarioID = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.TextBoxStateAttributeName = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 15);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(90, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "ST-Sim library file:";
            // 
            // TextBoxLibraryFile
            // 
            this.TextBoxLibraryFile.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.TextBoxLibraryFile.Location = new System.Drawing.Point(16, 42);
            this.TextBoxLibraryFile.Name = "TextBoxLibraryFile";
            this.TextBoxLibraryFile.Size = new System.Drawing.Size(452, 20);
            this.TextBoxLibraryFile.TabIndex = 1;
            // 
            // ButtonChoose
            // 
            this.ButtonChoose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.ButtonChoose.Location = new System.Drawing.Point(475, 40);
            this.ButtonChoose.Name = "ButtonChoose";
            this.ButtonChoose.Size = new System.Drawing.Size(75, 23);
            this.ButtonChoose.TabIndex = 2;
            this.ButtonChoose.Text = "Choose";
            this.ButtonChoose.UseVisualStyleBackColor = true;
            this.ButtonChoose.Click += new System.EventHandler(this.ButtonChoose_Click);
            // 
            // ButtonClear
            // 
            this.ButtonClear.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.ButtonClear.Location = new System.Drawing.Point(555, 40);
            this.ButtonClear.Name = "ButtonClear";
            this.ButtonClear.Size = new System.Drawing.Size(75, 23);
            this.ButtonClear.TabIndex = 3;
            this.ButtonClear.Text = "Clear";
            this.ButtonClear.UseVisualStyleBackColor = true;
            this.ButtonClear.Click += new System.EventHandler(this.ButtonClear_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(13, 78);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(97, 13);
            this.label2.TabIndex = 4;
            this.label2.Text = "Result scenario ID:";
            // 
            // TextBoxResultScenarioID
            // 
            this.TextBoxResultScenarioID.Location = new System.Drawing.Point(127, 74);
            this.TextBoxResultScenarioID.Name = "TextBoxResultScenarioID";
            this.TextBoxResultScenarioID.Size = new System.Drawing.Size(199, 20);
            this.TextBoxResultScenarioID.TabIndex = 5;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(13, 106);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(105, 13);
            this.label3.TabIndex = 6;
            this.label3.Text = "State attribute name:";
            // 
            // TextBoxStateAttributeName
            // 
            this.TextBoxStateAttributeName.Location = new System.Drawing.Point(127, 104);
            this.TextBoxStateAttributeName.Name = "TextBoxStateAttributeName";
            this.TextBoxStateAttributeName.Size = new System.Drawing.Size(199, 20);
            this.TextBoxStateAttributeName.TabIndex = 7;
            // 
            // STSimScenarioDataFeedView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.TextBoxStateAttributeName);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.TextBoxResultScenarioID);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.ButtonClear);
            this.Controls.Add(this.ButtonChoose);
            this.Controls.Add(this.TextBoxLibraryFile);
            this.Controls.Add(this.label1);
            this.Name = "STSimScenarioDataFeedView";
            this.Size = new System.Drawing.Size(637, 291);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox TextBoxLibraryFile;
        private System.Windows.Forms.Button ButtonChoose;
        private System.Windows.Forms.Button ButtonClear;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox TextBoxResultScenarioID;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox TextBoxStateAttributeName;
    }
}
