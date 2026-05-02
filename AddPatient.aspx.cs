using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class AddPatient : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadDropdowns();
        }

        private void LoadDropdowns()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Load hospitals
                SqlDataAdapter daHosp = new SqlDataAdapter(
                    "SELECT HospitalID, HospitalName + ' (' + CAST(AvailableBeds AS VARCHAR) + ' beds)' AS Display FROM HOSPITALS WHERE AvailableBeds > 0", conn);
                DataTable dtHosp = new DataTable();
                daHosp.Fill(dtHosp);
                ddlHospital.DataSource = dtHosp;
                ddlHospital.DataTextField = "Display";
                ddlHospital.DataValueField = "HospitalID";
                ddlHospital.DataBind();
                ddlHospital.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Hospital --", ""));

                // Load open incidents
                SqlDataAdapter daInc = new SqlDataAdapter(
                    "SELECT ReportID, Location + ' (' + DisasterType + ')' AS Display FROM EMERGENCY_REPORTS WHERE Status IN ('Open','In-Progress')", conn);
                DataTable dtInc = new DataTable();
                daInc.Fill(dtInc);
                ddlIncident.DataSource = dtInc;
                ddlIncident.DataTextField = "Display";
                ddlIncident.DataValueField = "ReportID";
                ddlIncident.DataBind();
                ddlIncident.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- None --", ""));
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string name = txtPatientName.Text.Trim();
            string ageText = txtAge.Text.Trim();
            string hospitalId = ddlHospital.SelectedValue;
            string incidentId = ddlIncident.SelectedValue;
            string caseType = ddlCaseType.SelectedValue;

            // Validation
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(ageText) ||
                string.IsNullOrEmpty(hospitalId) || string.IsNullOrEmpty(caseType))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('⚠️ Warning\\n\\nPlease fill all required fields.');", true);
                return;
            }

            int age;
            if (!int.TryParse(ageText, out age))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('⚠️ Warning\\n\\nPlease enter a valid age.');", true);
                return;
            }

            if (age < 0 || age > 120)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('⚠️ Warning\\n\\nPlease enter a valid age (0-120).');", true);
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Check if hospital has available beds
                string bedQuery = "SELECT AvailableBeds FROM HOSPITALS WHERE HospitalID = @hid";
                SqlCommand bedCmd = new SqlCommand(bedQuery, conn);
                bedCmd.Parameters.AddWithValue("@hid", hospitalId);
                conn.Open();
                int availBeds = Convert.ToInt32(bedCmd.ExecuteScalar());

                if (availBeds <= 0)
                {
                    conn.Close();
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        "alert('⚠️ Warning\\n\\nSelected hospital has no available beds!');", true);
                    return;
                }

                // Insert patient
                string query = @"INSERT INTO PATIENTS (HospitalID, ReportID, PatientName, Age, CaseType)
                                 VALUES (@hid, @rid, @name, @age, @case)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@hid", hospitalId);
                cmd.Parameters.AddWithValue("@rid", string.IsNullOrEmpty(incidentId) ? (object)DBNull.Value : incidentId);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@age", age);
                cmd.Parameters.AddWithValue("@case", caseType);
                cmd.ExecuteNonQuery();

                // Reduce available beds by 1
                string updateBeds = "UPDATE HOSPITALS SET AvailableBeds = AvailableBeds - 1 WHERE HospitalID = @hid";
                SqlCommand updateCmd = new SqlCommand(updateBeds, conn);
                updateCmd.Parameters.AddWithValue("@hid", hospitalId);
                updateCmd.ExecuteNonQuery();
            }

            ClientScript.RegisterStartupScript(this.GetType(), "success",
                "alert('✅ Patient admitted successfully!');", true);

            txtPatientName.Text = "";
            txtAge.Text = "";
            ddlHospital.SelectedIndex = 0;
            ddlIncident.SelectedIndex = 0;
            ddlCaseType.SelectedIndex = 0;
            LoadDropdowns();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }
}