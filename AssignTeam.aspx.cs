using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace DisasterProject
{
    public partial class AssignTeam : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            string role = Session["Role"].ToString();
            if (role != "Administrator" && role != "Emergency Operator")
                Response.Redirect("Dashboard.aspx");

            if (!IsPostBack)
            {
                LoadIncidents();
                LoadTeams();
            }
        }
        private void LoadIncidents()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT ReportID, Location + ' (' + DisasterType + ')' AS Display FROM EMERGENCY_REPORTS WHERE Status IN ('Open','In-Progress')", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlIncident.DataSource = dt;
                ddlIncident.DataTextField = "Display";
                ddlIncident.DataValueField = "ReportID";
                ddlIncident.DataBind();
                ddlIncident.Items.Insert(0, new ListItem("-- Select Incident --", ""));
            }
        }

        private void LoadTeams()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT TeamID, TeamName + ' (' + TeamType + ' - ' + CurrentLocation + ')' AS Display FROM RESCUE_TEAMS WHERE AvailabilityStatus = 'Available'", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rblTeams.DataSource = dt;
                rblTeams.DataTextField = "Display";
                rblTeams.DataValueField = "TeamID";
                rblTeams.DataBind();
            }
        }

        protected void btnAssign_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlIncident.SelectedValue) || string.IsNullOrEmpty(rblTeams.SelectedValue))
            {
                lblMessage.Text = "Please select both an incident and a team.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int reportId = Convert.ToInt32(ddlIncident.SelectedValue);
            int teamId = Convert.ToInt32(rblTeams.SelectedValue);

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"INSERT INTO TEAM_ASSIGNMENTS (TeamID, ReportID, AssignmentStatus)
                                 VALUES (@teamId, @reportId, 'Active')";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@teamId", teamId);
                cmd.Parameters.AddWithValue("@reportId", reportId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Team assigned successfully!";
            lblMessage.ForeColor = System.Drawing.Color.DarkGreen;
            ddlIncident.SelectedIndex = 0;
            LoadTeams(); // refresh available teams
        }
    }
}