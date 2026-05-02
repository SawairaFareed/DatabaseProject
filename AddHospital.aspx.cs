using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace DisasterProject
{
    public partial class AddHospital : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string name = txtHospitalName.Text.Trim();
            string location = txtLocation.Text.Trim();
            string totalBeds = txtTotalBeds.Text.Trim();
            string availBeds = txtAvailableBeds.Text.Trim();
            string phone = txtPhone.Text.Trim();

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(location) ||
                string.IsNullOrEmpty(totalBeds) || string.IsNullOrEmpty(availBeds) ||
                string.IsNullOrEmpty(phone))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('⚠️ Warning\\n\\nPlease fill all required fields.');", true);
                return;
            }

            int total, avail;
            if (!int.TryParse(totalBeds, out total) || !int.TryParse(availBeds, out avail))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('⚠️ Warning\\n\\nPlease enter valid numbers for beds.');", true);
                return;
            }

            if (total < 0 || avail < 0)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('⚠️ Warning\\n\\nEnter valid number of beds! Beds cannot be negative.');", true);
                return;
            }

            if (avail > total)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('⚠️ Warning\\n\\nAvailable beds cannot exceed total beds.');", true);
                return;
            }

            if (!Regex.IsMatch(phone, @"^[0-9\-\(\)\s\+]+$"))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('⚠️ Warning\\n\\nEnter a valid phone number! Only digits, +, -, (, ) allowed.');", true);
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"INSERT INTO HOSPITALS (HospitalName, Location, TotalBeds, AvailableBeds, ContactPhone)
                                 VALUES (@name, @loc, @total, @avail, @phone)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@loc", location);
                cmd.Parameters.AddWithValue("@total", total);
                cmd.Parameters.AddWithValue("@avail", avail);
                cmd.Parameters.AddWithValue("@phone", phone);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ClientScript.RegisterStartupScript(this.GetType(), "success",
                "alert('✅ Hospital added successfully!');", true);

            txtHospitalName.Text = "";
            txtLocation.Text = "";
            txtTotalBeds.Text = "";
            txtAvailableBeds.Text = "";
            txtPhone.Text = "";
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }
}