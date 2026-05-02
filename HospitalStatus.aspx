<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HospitalStatus.aspx.cs" Inherits="DisasterProject.HospitalStatus" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Hospital Status – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; margin: 0; }
        .topbar { background: #0b3b5f; color: white; padding: 12px 30px; display: flex; justify-content: space-between; }
        .topbar h3 { margin: 0; font-size: 18px; }
        .topbar a { color: #ffcccc; text-decoration: none; font-size: 14px; }
        .container-main { padding: 20px; }
        .chart-box { background: white; border-radius: 8px; padding: 20px; max-width: 350px; margin: 0 auto 25px auto; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .chart-box h5 { color: #0b3b5f; font-weight: bold; margin-bottom: 15px; text-align: center; }
        .card { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 25px; }
        .card h4 { color: #0b3b5f; font-weight: bold; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #0b3b5f; color: white; padding: 10px; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        .critical { background: #fff0f0; }
        .full { background: #ffe0e0; font-weight: bold; color: red; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="topbar">
            <h3>Smart Disaster Response MIS</h3>
            <a href="Dashboard.aspx">← Back to Dashboard</a>
        </div>

        <div class="container-main">
            <div class="chart-box">
                <h5>📊 Bed Occupancy</h5>
                <canvas id="chartBeds" width="200" height="130"></canvas>
            </div>

            <div class="card">
                <h4>🏥 Hospital Status</h4>
                <asp:GridView ID="gvHospitals" runat="server" AutoGenerateColumns="True" CssClass="table table-bordered"
                    HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White" OnRowDataBound="gvHospitals_RowDataBound" />
            </div>

            <div class="card">
                <h4>🛏️ Admitted Patients</h4>
                <asp:GridView ID="gvPatients" runat="server" AutoGenerateColumns="True" CssClass="table table-bordered"
                    HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White" />
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script type="text/javascript">
        var ctx = document.getElementById('chartBeds').getContext('2d');
new Chart(ctx, {
    type: 'doughnut',
    data: {
        labels: ['Available', 'Occupied'],
        datasets: [{
            data: [<asp:Literal ID = "litBedData" runat = "server" > </asp:Literal>],
            backgroundColor: ['#28a745', '#dc3545']
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: { legend: { position: 'bottom' } }
    }
});
    </script>
</body>
</html>