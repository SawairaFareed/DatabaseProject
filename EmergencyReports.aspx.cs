using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class EmergencyReports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            string role = Session["Role"].ToString();
            if (role != "Administrator" && role != "Emergency Operator")
                Response.Redirect("Dashboard.aspx");

            if (!IsPostBack)
                LoadReports();
        }
        private void LoadReports()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT ReportID, Location, DisasterType, SeverityLevel, 
                                        ReportTime, Status 
                                 FROM EMERGENCY_REPORTS 
                                 ORDER BY ReportTime DESC";
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                gvReports.DataSource = dt;
                gvReports.DataBind();
            }
        }
    }
}