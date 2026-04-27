using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class ResourceRequest : System.Web.UI.Page
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
                // load open incidents
                SqlDataAdapter daInc = new SqlDataAdapter(
                    "SELECT ReportID, Location + ' (' + DisasterType + ')' AS Display FROM EMERGENCY_REPORTS WHERE Status IN ('Open','In-Progress')", conn);
                DataTable dtInc = new DataTable();
                daInc.Fill(dtInc);
                ddlIncident.DataSource = dtInc;
                ddlIncident.DataTextField = "Display";
                ddlIncident.DataValueField = "ReportID";
                ddlIncident.DataBind();
                ddlIncident.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Incident --", ""));

                // load resources
                SqlDataAdapter daRes = new SqlDataAdapter(
                    "SELECT ResourceID, ResourceName + ' (' + CAST(QuantityAvailable AS VARCHAR) + ' ' + Unit + ')' AS Display FROM RESOURCES WHERE QuantityAvailable > 0", conn);
                DataTable dtRes = new DataTable();
                daRes.Fill(dtRes);
                ddlResource.DataSource = dtRes;
                ddlResource.DataTextField = "Display";
                ddlResource.DataValueField = "ResourceID";
                ddlResource.DataBind();
                ddlResource.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Resource --", ""));
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlIncident.SelectedValue) ||
                string.IsNullOrEmpty(ddlResource.SelectedValue) ||
                string.IsNullOrEmpty(txtQuantity.Text))
            {
                lblMessage.Text = "Please fill all required fields.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int incidentId = Convert.ToInt32(ddlIncident.SelectedValue);
            int resourceId = Convert.ToInt32(ddlResource.SelectedValue);
            decimal quantity = Convert.ToDecimal(txtQuantity.Text);

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"INSERT INTO RESOURCE_ALLOCATIONS 
                    (ResourceID, ReportID, RequestedByUserID, QuantityRequested, Status)
                    VALUES (@resId, @repId, @userId, @qty, 'Pending')";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@resId", resourceId);
                cmd.Parameters.AddWithValue("@repId", incidentId);
                cmd.Parameters.AddWithValue("@userId", Session["UserID"].ToString());
                cmd.Parameters.AddWithValue("@qty", quantity);
                conn.Open();
                cmd.ExecuteNonQuery();

                // Get the new AllocationID
                string getIdQuery = "SELECT MAX(AllocationID) FROM RESOURCE_ALLOCATIONS";
                SqlCommand getIdCmd = new SqlCommand(getIdQuery, conn);
                int allocationId = Convert.ToInt32(getIdCmd.ExecuteScalar());

                // Insert into APPROVAL_REQUESTS
                string approvalQuery = @"INSERT INTO APPROVAL_REQUESTS 
    (RequestType, ReferenceID, RequestedByUserID, Status) 
    VALUES ('ResourceDistribution', @refId, @userId, 'Pending')";
                SqlCommand approvalCmd = new SqlCommand(approvalQuery, conn);
                approvalCmd.Parameters.AddWithValue("@refId", allocationId);
                approvalCmd.Parameters.AddWithValue("@userId", Session["UserID"].ToString());
                approvalCmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Request submitted! Pending approval.";
            lblMessage.ForeColor = System.Drawing.Color.DarkGreen;
            txtQuantity.Text = "";
            ddlIncident.SelectedIndex = 0;
            ddlResource.SelectedIndex = 0;
        }
    
    }
}