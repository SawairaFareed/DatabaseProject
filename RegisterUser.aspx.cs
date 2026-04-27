using System;
using System.Configuration;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class RegisterUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string selectedRole = ddlRole.SelectedValue;
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();

            if (string.IsNullOrEmpty(selectedRole) ||
                string.IsNullOrEmpty(username) ||
                string.IsNullOrEmpty(password) ||
                string.IsNullOrEmpty(fullName))
            {
                lblMessage.Text = "Please fill all required fields.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // Insert into USERS
                string userQuery = @"INSERT INTO USERS (Username, PasswordHash, FullName, Email, Phone, IsActive)
                                     VALUES (@user, @pass, @name, @email, @phone, 1);
                                     SELECT SCOPE_IDENTITY();";

                SqlCommand userCmd = new SqlCommand(userQuery, conn);
                userCmd.Parameters.AddWithValue("@user", username);
                userCmd.Parameters.AddWithValue("@pass", password);
                userCmd.Parameters.AddWithValue("@name", fullName);
                userCmd.Parameters.AddWithValue("@email", string.IsNullOrEmpty(email) ? (object)DBNull.Value : email);
                userCmd.Parameters.AddWithValue("@phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);

                int newUserId = Convert.ToInt32(userCmd.ExecuteScalar());

                // Find RoleID
                string roleQuery = "SELECT RoleID FROM ROLES WHERE RoleName = @role";
                SqlCommand roleCmd = new SqlCommand(roleQuery, conn);
                roleCmd.Parameters.AddWithValue("@role", selectedRole);
                int roleId = Convert.ToInt32(roleCmd.ExecuteScalar());

                // Insert into USER_ROLES
                string urQuery = "INSERT INTO USER_ROLES (UserID, RoleID) VALUES (@uid, @rid)";
                SqlCommand urCmd = new SqlCommand(urQuery, conn);
                urCmd.Parameters.AddWithValue("@uid", newUserId);
                urCmd.Parameters.AddWithValue("@rid", roleId);
                urCmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Registration successful! Redirecting to login...";
            lblMessage.ForeColor = System.Drawing.Color.DarkGreen;

            // Redirect after a short delay
            Response.AddHeader("REFRESH", "2;URL=Login.aspx");
        }
    }
}