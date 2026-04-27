using System;
using System.Configuration;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class AddRescueTeam : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            // Only Admin and Emergency Operator can add teams
            string role = Session["Role"].ToString();
            if (role != "Administrator" && role != "Emergency Operator")
                Response.Redirect("Dashboard.aspx");
        }

        protected void btnAddTeam_Click(object sender, EventArgs e)
        {
            string teamName = txtTeamName.Text.Trim();
            string teamType = ddlTeamType.SelectedValue;
            string location = txtLocation.Text.Trim();

            if (string.IsNullOrEmpty(teamName) || string.IsNullOrEmpty(teamType) || string.IsNullOrEmpty(location))
            {
                lblMessage.Text = "Please fill all required fields.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"INSERT INTO RESCUE_TEAMS (TeamName, TeamType, CurrentLocation, AvailabilityStatus)
                                 VALUES (@name, @type, @loc, 'Available')";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@name", teamName);
                cmd.Parameters.AddWithValue("@type", teamType);
                cmd.Parameters.AddWithValue("@loc", location);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Team added successfully!";
            lblMessage.ForeColor = System.Drawing.Color.DarkGreen;

            txtTeamName.Text = "";
            ddlTeamType.SelectedIndex = 0;
            txtLocation.Text = "";
        }
    }
}