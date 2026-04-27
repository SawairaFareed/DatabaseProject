<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmergencyReports.aspx.cs" Inherits="DisasterProject.EmergencyReports" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Emergency Reports – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; margin: 0; }
        .topbar { background: #0b3b5f; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .topbar h3 { margin: 0; }
        .topbar a { color: #ffcccc; text-decoration: none; }
        .container-main { padding: 30px; }
        .card { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .card h4 { color: #0b3b5f; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #0b3b5f; color: white; padding: 10px; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f5f8fc; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="topbar">
            <h3>Smart Disaster Response MIS</h3>
            <a href="Dashboard.aspx">← Back</a>
        </div>
        <div class="container-main">
            <div class="card">
                <h4>All Emergency Reports</h4>
                <asp:GridView ID="gvReports" runat="server" AutoGenerateColumns="True" CssClass="table table-bordered"
                    HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White" />
            </div>
        </div>
    </form>
</body>
</html>