using System;
using System.Configuration;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class NewEmergencyReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Public access allowed — citizens can report without login
            // No redirect to Login.aspx
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string location = txtLocation.Text.Trim();
            string disasterType = ddlDisasterType.SelectedValue;
            string severity = ddlSeverity.SelectedValue;

            if (string.IsNullOrEmpty(location) || string.IsNullOrEmpty(disasterType) || string.IsNullOrEmpty(severity))
            {
                lblMessage.Text = "Please fill all fields.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"INSERT INTO EMERGENCY_REPORTS (Location, DisasterType, SeverityLevel, ReportedByUserID, Status) 
                                 VALUES (@loc, @type, @sev, @user, 'Open')";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@loc", location);
                cmd.Parameters.AddWithValue("@type", disasterType);
                cmd.Parameters.AddWithValue("@sev", severity);

                // If logged in, use UserID. If public (citizen), store NULL.
                if (Session["UserID"] != null)
                    cmd.Parameters.AddWithValue("@user", Session["UserID"].ToString());
                else
                    cmd.Parameters.AddWithValue("@user", DBNull.Value);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Report submitted successfully!";
            lblMessage.ForeColor = System.Drawing.Color.DarkGreen;
            txtLocation.Text = "";
            ddlDisasterType.SelectedIndex = 0;
            ddlSeverity.SelectedIndex = 0;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // If logged in, go to Dashboard. If public, go to Login.
            if (Session["UserID"] != null)
                Response.Redirect("Dashboard.aspx");
            else
                Response.Redirect("Login.aspx");
        }
    }
}