using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace DisasterProject
{
    public partial class HospitalStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
                LoadData();
        }

        private void LoadData()
        {
            string connString = ConfigurationManager.ConnectionStrings["DisasterDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Chart data - total available vs occupied
                string bedQuery = "SELECT SUM(AvailableBeds) AS Available, SUM(TotalBeds - AvailableBeds) AS Occupied FROM HOSPITALS";
                SqlCommand bedCmd = new SqlCommand(bedQuery, conn);
                conn.Open();
                SqlDataReader reader = bedCmd.ExecuteReader();
                int avail = 0, occupied = 0;
                if (reader.Read())
                {
                    avail = reader["Available"] != DBNull.Value ? Convert.ToInt32(reader["Available"]) : 0;
                    occupied = reader["Occupied"] != DBNull.Value ? Convert.ToInt32(reader["Occupied"]) : 0;
                }
                reader.Close();
                litBedData.Text = avail + "," + occupied;

                // Hospitals table
                string hospQuery = @"SELECT HospitalID, HospitalName, Location, TotalBeds, AvailableBeds, 
                                           (TotalBeds - AvailableBeds) AS OccupiedBeds,
                                           CASE WHEN AvailableBeds = 0 THEN 'FULL' 
                                                WHEN AvailableBeds < 10 THEN 'CRITICAL' 
                                                ELSE 'OK' END AS Status
                                    FROM HOSPITALS ORDER BY AvailableBeds ASC";
                SqlDataAdapter daHosp = new SqlDataAdapter(hospQuery, conn);
                DataTable dtHosp = new DataTable();
                daHosp.Fill(dtHosp);
                gvHospitals.DataSource = dtHosp;
                gvHospitals.DataBind();

                // Patients table
                string patQuery = @"SELECT p.PatientID, p.PatientName, p.Age, p.CaseType, 
                                          p.AdmittedAt, h.HospitalName, er.Location AS IncidentLocation
                                   FROM PATIENTS p
                                   JOIN HOSPITALS h ON p.HospitalID = h.HospitalID
                                   LEFT JOIN EMERGENCY_REPORTS er ON p.ReportID = er.ReportID
                                   WHERE p.DischargedAt IS NULL
                                   ORDER BY p.AdmittedAt DESC";
                SqlDataAdapter daPat = new SqlDataAdapter(patQuery, conn);
                DataTable dtPat = new DataTable();
                daPat.Fill(dtPat);
                gvPatients.DataSource = dtPat;
                gvPatients.DataBind();
            }
        }

        protected void gvHospitals_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView drv = (DataRowView)e.Row.DataItem;
                string status = drv["Status"].ToString();

                if (status == "FULL")
                    e.Row.CssClass = "full";
                else if (status == "CRITICAL")
                    e.Row.CssClass = "critical";
            }
        }
    }
}