<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="DisasterProject.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; margin: 0; }
        .topbar { background: #0b3b5f; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .topbar h3 { margin: 0; }
        .topbar .user-info { font-size: 14px; }
        .topbar .logout-btn { color: #ffcccc; text-decoration: none; margin-left: 15px; }
        .container-main { padding: 30px; }
        .stat-cards { display: flex; gap: 20px; margin-bottom: 30px; flex-wrap: wrap; }
        .stat-card { background: white; border-radius: 8px; padding: 20px; flex: 1; min-width: 200px; border-left: 5px solid #0b3b5f; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .stat-card .number { font-size: 32px; font-weight: bold; color: #0b3b5f; }
        .stat-card .label { color: #666; font-size: 14px; }
        .nav-links { display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 30px; }
        .link-group { background: white; border-radius: 8px; padding: 15px; flex: 1; min-width: 180px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .link-group b { color: #0b3b5f; display: block; margin-bottom: 10px; }
        .link-group a { display: block; margin-bottom: 6px; color: #333; text-decoration: none; font-size: 14px; }
        .link-group a:hover { color: #0b3b5f; }
        .charts-row { display: flex; gap: 20px; margin-bottom: 30px; flex-wrap: wrap; }
        .chart-box { background: white; border-radius: 8px; padding: 20px; flex: 1; min-width: 300px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .chart-box h5 { color: #0b3b5f; font-weight: bold; margin-bottom: 15px; }
        .table-box { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .table-box h5 { color: #0b3b5f; font-weight: bold; margin-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #0b3b5f; color: white; padding: 10px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="topbar">
            <h3>Smart Disaster Response MIS</h3>
            <div class="user-info">
                Welcome, <asp:Label ID="lblUserName" runat="server" Text="" /> |
                <asp:Label ID="lblRole" runat="server" Text="" />
                <a href="Login.aspx" class="logout-btn">Logout</a>
            </div>
        </div>

        <div class="container-main">
            <!-- Navigation categories -->
            <div class="nav-links">
                <div class="link-group">
                    <b>📋 Reports</b>
                    <a href="NewEmergencyReport.aspx">New Report</a>
                    <a href="EmergencyReports.aspx">View Reports</a>
                </div>
                <div class="link-group">
                    <b>📦 Resources</b>
                    <a href="ResourceRequest.aspx">Request Resources</a>
                    <a href="InventoryStatus.aspx">Inventory</a>
                    <a href="AddResource.aspx">Add Resource</a>
                </div>
                <div class="link-group">
                    <b>🚑 Teams</b>
                    <a href="AssignTeam.aspx">Assign Team</a>
                    <a href="AddRescueTeam.aspx">Add Team</a>
                </div>
                <div class="link-group">
                    <b>💰 Finance</b>
                    <a href="FinancialEntry.aspx">Financial Entry</a>
                </div>
                <div class="link-group">
                    <b>🔒 Admin</b>
                    <a href="ApproveRequests.aspx">Approvals</a>
                    <a href="AuditLogs.aspx">Audit Logs</a>
                </div>
                <div class="link-group">
                    <b>📊 Reports & Status</b>
                    <a href="TeamStatusUpdate.aspx">Update Team Status</a>
                    <a href="MISReports.aspx">MIS Reports</a>
                </div>
            </div>

            <!-- Stat Cards -->
            <div class="stat-cards">
                <div class="stat-card">
                    <div class="number"><asp:Label ID="lblOpenIncidents" runat="server" Text="0" /></div>
                    <div class="label">Open Incidents</div>
                </div>
                <div class="stat-card">
                    <div class="number"><asp:Label ID="lblAvailableTeams" runat="server" Text="0" /></div>
                    <div class="label">Available Teams</div>
                </div>
                <div class="stat-card">
                    <div class="number"><asp:Label ID="lblLowStock" runat="server" Text="0" /></div>
                    <div class="label">Low Stock Alerts</div>
                </div>
                <div class="stat-card">
                    <div class="number"><asp:Label ID="lblPendingApprovals" runat="server" Text="0" /></div>
                    <div class="label">Pending Approvals</div>
                </div>
            </div>

            <!-- Charts -->
            <div class="charts-row">
    <div class="chart-box" style="max-width:350px; margin:0 auto;">
        <h5>Incidents by Disaster Type</h5>
        <canvas id="chartIncidents" width="200" height="130"></canvas>
    </div>
    <div class="chart-box" style="max-width:350px; margin:0 auto;">
        <h5>Resource Fulfillment</h5>
        <canvas id="chartResources" width="200" height="130"></canvas>
    </div>
</div>

            <!-- Recent Reports -->
            <div class="table-box">
                <h5>Recent Emergency Reports</h5>
                <asp:GridView ID="gvRecentReports" runat="server" AutoGenerateColumns="True" CssClass="table"
                    HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White" />
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script>
        var ctx1 = document.getElementById('chartIncidents').getContext('2d');
        new Chart(ctx1, {
            type: 'bar',
            data: {
                labels: [<asp:Literal ID="litChartLabels" runat="server" />],
                datasets: [{
                    label: 'Incidents',
                    data: [<asp:Literal ID="litChartData" runat="server" />],
                    backgroundColor: ['#0b3b5f', '#1a5276', '#2e86c1', '#85c1e9']
                }]
            }
        });

        var ctx2 = document.getElementById('chartResources').getContext('2d');
        new Chart(ctx2, {
            type: 'doughnut',
            data: {
                labels: [<asp:Literal ID="litResLabels" runat="server" />],
                datasets: [{
                    data: [<asp:Literal ID="litResData" runat="server" />],
                    backgroundColor: ['#0b3b5f', '#1a5276', '#2e86c1', '#85c1e9', '#aed6f1']
                }]
            }
        });
        var chartOptions = { responsive: true, maintainAspectRatio: false };
    </script>
</body>
</html>