using SyncroSim.Core;
using SyncroSim.Core.Forms;

namespace SyncroSim.STSimPRMS
{
    public partial class RunControlDataFeedView : DataFeedView
    {
        public RunControlDataFeedView()
        {
            InitializeComponent();
        }

        public override void LoadDataFeed(DataFeed dataFeed)
        {
            base.LoadDataFeed(dataFeed);

            this.SetTextBoxBinding(this.TextBoxStartTimestep, "MinimumTimestep");
            this.SetTextBoxBinding(this.TextBoxEndTimestep, "MaximumTimestep");
            this.SetTextBoxBinding(this.TextBoxTotalIterations, "MaximumIteration");

            this.AddStandardCommands();
        }
    }
}
