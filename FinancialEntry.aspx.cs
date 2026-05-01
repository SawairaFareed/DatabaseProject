using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class FinancialEntry : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            string role = Session["Role"].ToString();
            if (role != "Administrator" && role != "Finance Officer")
                Response.Redirect("Dashboard.aspx");

            if (!IsPostBack)
            {
                LoadIncidents();
                LoadTransactions();
            }
        }
        private void LoadIncidents()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT ReportID, Location + ' (' + DisasterType + ')' AS Display FROM EMERGENCY_REPORTS ORDER BY ReportTime DESC", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlIncident.DataSource = dt;
                ddlIncident.DataTextField = "Display";
                ddlIncident.DataValueField = "ReportID";
                ddlIncident.DataBind();
                ddlIncident.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- None --", ""));
            }
        }

        private void LoadTransactions()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT TransactionID, TransactionType, Amount, TransactionDate, Description 
  FROM FINANCIAL_TRANSACTIONS ORDER BY TransactionID ASC", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlType.SelectedValue) || string.IsNullOrEmpty(txtAmount.Text))
            {
                lblMessage.Text = "Please fill Transaction Type and Amount.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }
            decimal amount;
            if (!decimal.TryParse(txtAmount.Text, out amount) || amount <= 0)
            {
                lblMessage.Text = "Please enter a valid positive amount.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

        
            string type = ddlType.SelectedValue;
            string desc = txtDescription.Text.Trim();
            string incidentId = string.IsNullOrEmpty(ddlIncident.SelectedValue) ? "NULL" : ddlIncident.SelectedValue;

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = $@"INSERT INTO FINANCIAL_TRANSACTIONS 
                    (TransactionType, Amount, Description, ReportID, RecordedByUserID)
                    VALUES ('{type}', {amount}, '{desc}', {incidentId}, {Session["UserID"]})";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Transaction recorded!";
            lblMessage.ForeColor = System.Drawing.Color.DarkGreen;
            txtAmount.Text = "";
            txtDescription.Text = "";
            ddlType.SelectedIndex = 0;
            ddlIncident.SelectedIndex = 0;
            LoadTransactions();
        }
    }
}