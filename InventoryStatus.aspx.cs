using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace DisasterProject
{
    public partial class InventoryStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadInventory("All");
        }

        protected void ddlFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadInventory(ddlFilter.SelectedValue);
        }

        private void LoadInventory(string filter)
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT r.ResourceID, r.ResourceName, r.ResourceType, r.QuantityAvailable, 
                                        r.ThresholdLevel, r.Unit, w.WarehouseName
                                 FROM RESOURCES r
                                 JOIN WAREHOUSES w ON r.WarehouseID = w.WarehouseID";
                if (filter != "All")
                    query += " WHERE r.ResourceType = @filter";
                query += " ORDER BY r.ResourceType, r.QuantityAvailable ASC";

                SqlCommand cmd = new SqlCommand(query, conn);
                if (filter != "All")
                    cmd.Parameters.AddWithValue("@filter", filter);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvInventory.DataSource = dt;
                gvInventory.DataBind();
            }
        }

        protected void gvInventory_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView drv = (DataRowView)e.Row.DataItem;
                decimal qty = Convert.ToDecimal(drv["QuantityAvailable"]);
                decimal threshold = Convert.ToDecimal(drv["ThresholdLevel"]);
                if (qty < threshold)
                    e.Row.CssClass = "low-stock";
            }
        }
    }
}