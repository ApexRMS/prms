namespace SyncroSim.STSimPRMS
{
    partial class RunControlDataFeedView
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
            this.LabelMinTimestep = new System.Windows.Forms.Label();
            this.LabelMaxTimestep = new System.Windows.Forms.Label();
            this.LabelTotalIterations = new System.Windows.Forms.Label();
            this.TextBoxStartTimestep = new System.Windows.Forms.TextBox();
            this.TextBoxEndTimestep = new System.Windows.Forms.TextBox();
            this.TextBoxTotalIterations = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // LabelMinTimestep
            // 
            this.LabelMinTimestep.AutoSize = true;
            this.LabelMinTimestep.Location = new System.Drawing.Point(13, 17);
            this.LabelMinTimestep.Name = "LabelMinTimestep";
            this.LabelMinTimestep.Size = new System.Drawing.Size(93, 13);
            this.LabelMinTimestep.TabIndex = 0;
            this.LabelMinTimestep.Text = "Minimum timestep:";
            // 
            // LabelMaxTimestep
            // 
            this.LabelMaxTimestep.AutoSize = true;
            this.LabelMaxTimestep.Location = new System.Drawing.Point(13, 43);
            this.LabelMaxTimestep.Name = "LabelMaxTimestep";
            this.LabelMaxTimestep.Size = new System.Drawing.Size(96, 13);
            this.LabelMaxTimestep.TabIndex = 1;
            this.LabelMaxTimestep.Text = "Maximum timestep:";
            // 
            // LabelTotalIterations
            // 
            this.LabelTotalIterations.AutoSize = true;
            this.LabelTotalIterations.Location = new System.Drawing.Point(13, 69);
            this.LabelTotalIterations.Name = "LabelTotalIterations";
            this.LabelTotalIterations.Size = new System.Drawing.Size(77, 13);
            this.LabelTotalIterations.TabIndex = 2;
            this.LabelTotalIterations.Text = "Total Iterations";
            // 
            // TextBoxStartTimestep
            // 
            this.TextBoxStartTimestep.Location = new System.Drawing.Point(128, 12);
            this.TextBoxStartTimestep.Name = "TextBoxStartTimestep";
            this.TextBoxStartTimestep.Size = new System.Drawing.Size(100, 20);
            this.TextBoxStartTimestep.TabIndex = 3;
            // 
            // TextBoxEndTimestep
            // 
            this.TextBoxEndTimestep.Location = new System.Drawing.Point(128, 38);
            this.TextBoxEndTimestep.Name = "TextBoxEndTimestep";
            this.TextBoxEndTimestep.Size = new System.Drawing.Size(100, 20);
            this.TextBoxEndTimestep.TabIndex = 4;
            // 
            // TextBoxTotalIterations
            // 
            this.TextBoxTotalIterations.Location = new System.Drawing.Point(128, 64);
            this.TextBoxTotalIterations.Name = "TextBoxTotalIterations";
            this.TextBoxTotalIterations.Size = new System.Drawing.Size(100, 20);
            this.TextBoxTotalIterations.TabIndex = 5;
            // 
            // RunControlDataFeedView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.TextBoxTotalIterations);
            this.Controls.Add(this.TextBoxEndTimestep);
            this.Controls.Add(this.TextBoxStartTimestep);
            this.Controls.Add(this.LabelTotalIterations);
            this.Controls.Add(this.LabelMaxTimestep);
            this.Controls.Add(this.LabelMinTimestep);
            this.Name = "RunControlDataFeedView";
            this.Size = new System.Drawing.Size(253, 97);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label LabelMinTimestep;
        private System.Windows.Forms.Label LabelMaxTimestep;
        private System.Windows.Forms.Label LabelTotalIterations;
        private System.Windows.Forms.TextBox TextBoxStartTimestep;
        private System.Windows.Forms.TextBox TextBoxEndTimestep;
        private System.Windows.Forms.TextBox TextBoxTotalIterations;
    }
}
