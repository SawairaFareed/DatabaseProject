using System;
using System.Configuration;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT u.UserID, u.FullName, r.RoleName 
                                 FROM USERS u
                                 JOIN USER_ROLES ur ON u.UserID = ur.UserID
                                 JOIN ROLES r ON ur.RoleID = r.RoleID
                                 WHERE u.Username = @user AND u.PasswordHash = @pass AND u.IsActive = 1";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@user", username);
                cmd.Parameters.AddWithValue("@pass", password);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    Session["UserID"] = reader["UserID"].ToString();
                    Session["FullName"] = reader["FullName"].ToString();
                    Session["Role"] = reader["RoleName"].ToString();
                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    Response.Write("<script>alert('Invalid credentials!');</script>");
                }
            }
        }
    }
}