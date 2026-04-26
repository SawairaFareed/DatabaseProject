using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace DisasterProject
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            lblUserName.Text = Session["FullName"].ToString();
            lblRole.Text = Session["Role"].ToString();

            if (!IsPostBack)
                LoadDashboard();
        }

        private DataTable GetData(string query)
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlDataAdapter adapter = new SqlDataAdapter(query, conn))
                {
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    return dt;
                }
            }
        }

        private object GetScalar(string query)
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    return cmd.ExecuteScalar();
                }
            }
        }

        private void LoadDashboard()
        {
            // Open Incidents
            lblOpenIncidents.Text = GetScalar("SELECT COUNT(*) FROM EMERGENCY_REPORTS WHERE Status IN ('Open','In-Progress')").ToString();

            // Available Teams
            lblAvailableTeams.Text = GetScalar("SELECT COUNT(*) FROM RESCUE_TEAMS WHERE AvailabilityStatus = 'Available'").ToString();

            // Low Stock
            lblLowStock.Text = GetScalar(@"
                SELECT COUNT(*) FROM RESOURCES 
                WHERE QuantityAvailable < ThresholdLevel").ToString();

            // Pending Approvals
            lblPendingApprovals.Text = GetScalar("SELECT COUNT(*) FROM APPROVAL_REQUESTS WHERE Status = 'Pending'").ToString();

            // Chart Data - Incidents by Type
            DataTable dtIncidents = GetData("SELECT DisasterType, COUNT(*) AS Count FROM EMERGENCY_REPORTS GROUP BY DisasterType");
            string labels = "", data = "";
            foreach (DataRow row in dtIncidents.Rows)
            {
                labels += "'" + row["DisasterType"] + "',";
                data += row["Count"] + ",";
            }
            litChartLabels.Text = labels.TrimEnd(',');
            litChartData.Text = data.TrimEnd(',');

            // Chart Data - Resource Fulfillment
            litResLabels.Text = "'Dispatched','Pending','Approved'";
            litResData.Text = GetScalar("SELECT COUNT(*) FROM RESOURCE_ALLOCATIONS WHERE Status='Dispatched'") + "," +
                              GetScalar("SELECT COUNT(*) FROM RESOURCE_ALLOCATIONS WHERE Status='Pending'") + "," +
                              GetScalar("SELECT COUNT(*) FROM RESOURCE_ALLOCATIONS WHERE Status='Approved'");

            // Recent Reports
            gvRecentReports.DataSource = GetData(@"SELECT TOP 10 ReportID, Location, DisasterType, SeverityLevel, 
                                                   CONVERT(varchar, ReportTime, 120) AS ReportTime, Status 
                                                   FROM EMERGENCY_REPORTS ORDER BY ReportTime DESC");
            gvRecentReports.DataBind();
        }
    }
}