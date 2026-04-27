using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DisasterProject
{
    public partial class AddResource : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            string role = Session["Role"].ToString();
            if (role != "Administrator" && role != "Warehouse Manager")
                Response.Redirect("Dashboard.aspx");

            if (!IsPostBack)
                LoadWarehouses();
        }

        private void LoadWarehouses()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT WarehouseID, WarehouseName FROM WAREHOUSES", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlWarehouse.DataSource = dt;
                ddlWarehouse.DataTextField = "WarehouseName";
                ddlWarehouse.DataValueField = "WarehouseID";
                ddlWarehouse.DataBind();
                ddlWarehouse.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Warehouse --", ""));
            }
        }

        protected void btnAddResource_Click(object sender, EventArgs e)
        {
            string warehouseId = ddlWarehouse.SelectedValue;
            string resourceName = txtResourceName.Text.Trim();
            string resourceType = ddlResourceType.SelectedValue;
            string qtyText = txtQuantity.Text.Trim();
            string thresholdText = txtThreshold.Text.Trim();
            string unit = txtUnit.Text.Trim();

            if (string.IsNullOrEmpty(warehouseId) ||
                string.IsNullOrEmpty(resourceName) ||
                string.IsNullOrEmpty(resourceType) ||
                string.IsNullOrEmpty(qtyText) ||
                string.IsNullOrEmpty(thresholdText))
            {
                lblMessage.Text = "Please fill all required fields.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            decimal quantity = Convert.ToDecimal(qtyText);
            decimal threshold = Convert.ToDecimal(thresholdText);

            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"INSERT INTO RESOURCES (WarehouseID, ResourceName, ResourceType, QuantityAvailable, ThresholdLevel, Unit)
                                 VALUES (@wh, @name, @type, @qty, @thresh, @unit)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@wh", warehouseId);
                cmd.Parameters.AddWithValue("@name", resourceName);
                cmd.Parameters.AddWithValue("@type", resourceType);
                cmd.Parameters.AddWithValue("@qty", quantity);
                cmd.Parameters.AddWithValue("@thresh", threshold);
                cmd.Parameters.AddWithValue("@unit", string.IsNullOrEmpty(unit) ? (object)DBNull.Value : unit);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Resource added successfully!";
            lblMessage.ForeColor = System.Drawing.Color.DarkGreen;

            txtResourceName.Text = "";
            ddlResourceType.SelectedIndex = 0;
            txtQuantity.Text = "";
            txtThreshold.Text = "";
            txtUnit.Text = "";
        }
    }
}