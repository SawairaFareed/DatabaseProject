using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace DisasterProject
{
    public partial class ApproveRequests : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            string role = Session["Role"].ToString();
            if (role != "Administrator")
                Response.Redirect("Dashboard.aspx");

            if (!IsPostBack)
                LoadPending();
        }
        private void LoadPending()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT ar.ApprovalID, ar.RequestType, ar.ReferenceID, 
                             u.FullName AS RequestedBy, ar.RequestedAt, ar.Status
                      FROM APPROVAL_REQUESTS ar
                      JOIN USERS u ON ar.RequestedByUserID = u.UserID
                      WHERE ar.Status = 'Pending'
                      ORDER BY ar.RequestedAt", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvPending.DataSource = dt;
                gvPending.DataBind();
            }
        }

        protected void gvPending_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int approvalId = Convert.ToInt32(e.CommandArgument);
            string newStatus = e.CommandName == "Approve" ? "Approved" : "Rejected";

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"UPDATE APPROVAL_REQUESTS 
                                SET Status = @status, ReviewedAt = GETDATE(), ApprovedByUserID = @userId
                                WHERE ApprovalID = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@status", newStatus);
                cmd.Parameters.AddWithValue("@userId", Session["UserID"].ToString());
                cmd.Parameters.AddWithValue("@id", approvalId);
                conn.Open();
                cmd.ExecuteNonQuery();
                
                if (newStatus == "Approved")
                {
                     string getRefQuery = "SELECT ReferenceID FROM APPROVAL_REQUESTS WHERE ApprovalID = @id";
                    SqlCommand refCmd = new SqlCommand(getRefQuery, conn);
                    refCmd.Parameters.AddWithValue("@id", approvalId);
                    int refId = Convert.ToInt32(refCmd.ExecuteScalar());

                    string updateAlloc = "UPDATE RESOURCE_ALLOCATIONS SET Status = 'Approved' WHERE AllocationID = @refId";
                    SqlCommand allocCmd = new SqlCommand(updateAlloc, conn);
                    allocCmd.Parameters.AddWithValue("@refId", refId);
                    allocCmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = $"Request {newStatus}.";
            lblMessage.ForeColor = System.Drawing.Color.DarkGreen;
            LoadPending();
        }
    }
}