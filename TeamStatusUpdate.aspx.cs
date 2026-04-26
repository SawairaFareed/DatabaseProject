using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace DisasterProject
{
    public partial class TeamStatusUpdate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadAssignments();
        }

        private void LoadAssignments()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // For simplicity, show all active assignments (ideally filtered by logged-in field officer)
                string query = @"SELECT ta.AssignmentID, rt.TeamName, er.Location AS IncidentLocation, 
                                        er.DisasterType, ta.AssignedAt, ta.AssignmentStatus
                                 FROM TEAM_ASSIGNMENTS ta
                                 JOIN RESCUE_TEAMS rt ON ta.TeamID = rt.TeamID
                                 JOIN EMERGENCY_REPORTS er ON ta.ReportID = er.ReportID
                                 WHERE ta.AssignmentStatus = 'Active'";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvAssignments.DataSource = dt;
                gvAssignments.DataBind();
            }
        }

        protected void gvAssignments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Complete")
            {
                int assignmentId = Convert.ToInt32(e.CommandArgument);
                string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = @"UPDATE TEAM_ASSIGNMENTS 
                                     SET AssignmentStatus = 'Completed', CompletedAt = GETDATE()
                                     WHERE AssignmentID = @id";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@id", assignmentId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = "Assignment marked as completed. Team is now available.";
                lblMessage.ForeColor = System.Drawing.Color.DarkGreen;
                LoadAssignments();
            }
        }
    }
}