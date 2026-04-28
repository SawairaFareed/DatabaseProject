using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class AuditLogs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            string role = Session["Role"].ToString();
            if (role != "Administrator")
                Response.Redirect("Dashboard.aspx");

            if (!IsPostBack)
                LoadLogs();
        }
        private void LoadLogs()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT al.LogID, u.FullName AS UserName, al.ActionType, al.TableAffected, 
                                        al.RecordID, al.OldValue, al.NewValue, al.Timestamp
                                 FROM AUDIT_LOGS al
                                 LEFT JOIN USERS u ON al.UserID = u.UserID
                                 ORDER BY al.Timestamp ASC";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvAuditLogs.DataSource = dt;
                gvAuditLogs.DataBind();
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadLogs();
        }

        protected void gvAuditLogs_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvAuditLogs.PageIndex = e.NewPageIndex;
            LoadLogs();
        }
    }
}