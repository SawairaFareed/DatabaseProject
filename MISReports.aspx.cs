using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class MISReports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadReports();
        }
        private object GetScalar(string query)
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(query, conn);
                return cmd.ExecuteScalar();
            }
        }

        private DataTable GetData(string query)
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        private void LoadReports()
        {
            // Severity chart data
            litSevData.Text = GetScalar("SELECT COUNT(*) FROM EMERGENCY_REPORTS WHERE SeverityLevel='Low'") + "," +
                              GetScalar("SELECT COUNT(*) FROM EMERGENCY_REPORTS WHERE SeverityLevel='Medium'") + "," +
                              GetScalar("SELECT COUNT(*) FROM EMERGENCY_REPORTS WHERE SeverityLevel='High'") + "," +
                              GetScalar("SELECT COUNT(*) FROM EMERGENCY_REPORTS WHERE SeverityLevel='Critical'");

            // Response times
            gvResponseTimes.DataSource = GetData(@"SELECT er.ReportID, er.Location, er.DisasterType,
                                                     DATEDIFF(MINUTE, er.ReportTime, MIN(ta.AssignedAt)) AS ResponseMins
                                                  FROM EMERGENCY_REPORTS er
                                                  LEFT JOIN TEAM_ASSIGNMENTS ta ON er.ReportID = ta.ReportID
                                                  GROUP BY er.ReportID, er.Location, er.DisasterType, er.ReportTime");
            gvResponseTimes.DataBind();

            // Fulfillment chart
            litFulfillData.Text = GetScalar("SELECT COUNT(*) FROM RESOURCE_ALLOCATIONS WHERE Status='Dispatched'") + "," +
                                  GetScalar("SELECT COUNT(*) FROM RESOURCE_ALLOCATIONS WHERE Status IN ('Pending','Approved')");

            // Financial summary
            gvFinancial.DataSource = GetData(@"SELECT er.ReportID, er.Location, er.DisasterType,
                                                 COALESCE(SUM(CASE WHEN ft.TransactionType='Donation' THEN ft.Amount END),0) AS Donations,
                                                 COALESCE(SUM(CASE WHEN ft.TransactionType='Expense' THEN ft.Amount END),0) AS Expenses,
                                                 COALESCE(SUM(CASE WHEN ft.TransactionType='Procurement' THEN ft.Amount END),0) AS Procurement
                                              FROM EMERGENCY_REPORTS er
                                              LEFT JOIN FINANCIAL_TRANSACTIONS ft ON er.ReportID = ft.ReportID
                                              GROUP BY er.ReportID, er.Location, er.DisasterType");
            gvFinancial.DataBind();
        }
    }
}