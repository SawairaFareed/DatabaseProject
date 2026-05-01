<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MISReports.aspx.cs" Inherits="DisasterProject.MISReports" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MIS Reports – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; margin: 0; }
        .topbar { background: #0b3b5f; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .topbar h3 { margin: 0; }
        .topbar a { color: #ffcccc; text-decoration: none; }
        .container-main { padding: 30px; }

        .charts-row { display: flex; gap: 20px; margin-bottom: 40px; flex-wrap: wrap; justify-content: center; }
        .chart-box { background: white; border-radius: 8px; padding: 20px; flex: 1; min-width: 300px; max-width: 450px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin: 10px; }
        .chart-box h5 { color: #0b3b5f; font-weight: bold; margin-bottom: 10px; font-size: 14px; }
        .card { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 25px; }
        .card h5 { color: #0b3b5f; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #0b3b5f; color: white; padding: 10px; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="topbar">
            <h3>Smart Disaster Response MIS</h3>
            <a href="Dashboard.aspx">← Back</a>
        </div>

        <div class="container-main">
            <div class="charts-row">
                <div class="chart-box">
                    <h5>Incident Statistics by Severity</h5>
                    <canvas id="chartSeverity" width="300" height="200"></canvas>
                </div>
                <div class="chart-box">
                    <h5>Resource Utilization (Fulfillment %)</h5>
                    <canvas id="chartFulfillment" width="300" height="200"></canvas>
                </div>
            </div>

            <div class="card">
                <h5>Response Time Summary</h5>
                <asp:GridView ID="gvResponseTimes" runat="server" AutoGenerateColumns="True" CssClass="table table-bordered"
                    HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White" />
            </div>

            <div class="card">
                <h5>Financial Summary</h5>
                <asp:GridView ID="gvFinancial" runat="server" AutoGenerateColumns="True" CssClass="table table-bordered"
                    HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White" />
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script>
         var ctx1 = document.getElementById('chartSeverity').getContext('2d');
        new Chart(ctx1, {
            type: 'bar',
            data: {
                labels: ['Low', 'Medium', 'High', 'Critical'],
                datasets: [{
                    label: 'Incident Count',
                    data: [<asp:Literal ID="litSevData" runat="server" />],
                    backgroundColor: ['#85c1e9', '#2e86c1', '#1a5276', '#0b3b5f']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: { legend: { display: false } }
            }
        });

        var ctx2 = document.getElementById('chartFulfillment').getContext('2d');
        new Chart(ctx2, {
            type: 'doughnut',
            data: {
                labels: ['Fulfilled', 'Pending'],
                datasets: [{
                    data: [<asp:Literal ID="litFulfillData" runat="server" />],
                    backgroundColor: ['#28a745', '#ffc107']
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