using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
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

            lblUserName.Text = (Session["FullName"] ?? string.Empty).ToString();
            lblRole.Text = (Session["Role"] ?? string.Empty).ToString();

            string role = (Session["Role"] ?? string.Empty).ToString();
            grpReports.Visible = (role == "Administrator" || role == "Emergency Operator");
            grpResources.Visible = (role == "Administrator" || role == "Warehouse Manager");
            grpTeams.Visible = (role == "Administrator" || role == "Emergency Operator");
            grpFinance.Visible = (role == "Administrator" || role == "Finance Officer");
            grpAdmin.Visible = (role == "Administrator");
            grpStatus.Visible = true;                                                      // sab dekh sakte hain (MIS Reports)
            grpTeamStatus.Visible = (role == "Administrator" || role == "Field Officer"); // sirf Admin aur Field Officer

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

        private int GetScalarInt(string query)
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    object result = cmd.ExecuteScalar();
                    if (result == null || result == DBNull.Value)
                        return 0;
                    return Convert.ToInt32(result);
                }
            }
        }
         
        private void LoadDashboard()
        {
            lblOpenIncidents.Text = GetScalarInt("SELECT COUNT(*) FROM EMERGENCY_REPORTS WHERE Status IN ('Open','In-Progress')").ToString();
            lblAvailableTeams.Text = GetScalarInt("SELECT COUNT(*) FROM RESCUE_TEAMS WHERE AvailabilityStatus = 'Available'").ToString();
            lblLowStock.Text = GetScalarInt("SELECT COUNT(*) FROM RESOURCES WHERE QuantityAvailable < ThresholdLevel").ToString();
            lblPendingApprovals.Text = GetScalarInt("SELECT COUNT(*) FROM APPROVAL_REQUESTS WHERE Status = 'Pending'").ToString();

            DataTable dtIncidents = GetData("SELECT DisasterType, COUNT(*) AS Count FROM EMERGENCY_REPORTS GROUP BY DisasterType");
            var labelsBuilder = new StringBuilder();
            var dataBuilder = new StringBuilder();
            foreach (DataRow row in dtIncidents.Rows)
            {
                var label = row["DisasterType"] == DBNull.Value ? "Unknown" : row["DisasterType"].ToString();
                label = label.Replace("'", "\\'");
                labelsBuilder.AppendFormat("'{0}',", label);
                dataBuilder.AppendFormat("{0},", row["Count"]);
            }
            litChartLabels.Text = labelsBuilder.Length > 0 ? labelsBuilder.ToString().TrimEnd(',') : string.Empty;
            litChartData.Text = dataBuilder.Length > 0 ? dataBuilder.ToString().TrimEnd(',') : string.Empty;

            int dispatched = GetScalarInt("SELECT COUNT(*) FROM RESOURCE_ALLOCATIONS WHERE Status='Dispatched'");
            int pending = GetScalarInt("SELECT COUNT(*) FROM RESOURCE_ALLOCATIONS WHERE Status='Pending'");
            int approved = GetScalarInt("SELECT COUNT(*) FROM RESOURCE_ALLOCATIONS WHERE Status='Approved'");
            litResLabels.Text = "'Dispatched','Pending','Approved'";
            litResData.Text = $"{dispatched},{pending},{approved}";

            gvRecentReports.DataSource = GetData("SELECT TOP 10 ReportID, Location, DisasterType, SeverityLevel, CONVERT(varchar, ReportTime, 120) AS ReportTime, Status FROM EMERGENCY_REPORTS ORDER BY ReportTime DESC");
            gvRecentReports.DataBind();
        }
    }
}