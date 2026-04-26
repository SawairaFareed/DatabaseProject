<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewEmergencyReport.aspx.cs" Inherits="DisasterProject.NewEmergencyReport" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>New Report – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; margin: 0; }
        .topbar { background: #0b3b5f; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .topbar h3 { margin: 0; }
        .topbar a { color: #ffcccc; text-decoration: none; }
        .container-main { padding: 30px; max-width: 700px; margin: 0 auto; }
        .card { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 5px solid #0b3b5f; }
        .card h4 { color: #0b3b5f; font-weight: bold; margin-bottom: 25px; }
        label { font-weight: bold; color: #333; display: block; margin-top: 15px; }
        .form-control { border: 1px solid #ccc; border-radius: 5px; padding: 10px; width: 100%; box-sizing: border-box; margin-bottom: 10px; }
        .btn-submit { background: #0b3b5f; color: white; font-weight: bold; border: none; border-radius: 5px; padding: 12px 30px; font-size: 16px; cursor: pointer; }
        .btn-cancel { background: #999; color: white; border: none; border-radius: 5px; padding: 12px 30px; font-size: 16px; cursor: pointer; margin-left: 10px; }
        .btn-submit:hover { background: #0a2f4a; }
        .btn-cancel:hover { background: #777; }
        .msg { margin-top: 15px; font-weight: bold; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="topbar">
            <h3>Smart Disaster Response MIS</h3>
            <a href="Dashboard.aspx">← Back to Dashboard</a>
        </div>

        <div class="container-main">
            <div class="card">
                <h4>New Emergency Report</h4>

                <label>Location *</label>
                <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" placeholder="e.g. Karachi, Sindh" />

                <label>Disaster Type *</label>
                <asp:DropDownList ID="ddlDisasterType" runat="server" CssClass="form-control">
                    <asp:ListItem Text="-- Select --" Value="" />
                    <asp:ListItem Text="Flood" Value="Flood" />
                    <asp:ListItem Text="Earthquake" Value="Earthquake" />
                    <asp:ListItem Text="Fire" Value="Fire" />
                    <asp:ListItem Text="Other" Value="Other" />
                </asp:DropDownList>

                <label>Severity Level *</label>
                <asp:DropDownList ID="ddlSeverity" runat="server" CssClass="form-control">
                    <asp:ListItem Text="-- Select --" Value="" />
                    <asp:ListItem Text="Low" Value="Low" />
                    <asp:ListItem Text="Medium" Value="Medium" />
                    <asp:ListItem Text="High" Value="High" />
                    <asp:ListItem Text="Critical" Value="Critical" />
                </asp:DropDownList>

                <br />
                <asp:Button ID="btnSubmit" runat="server" Text="CREATE REPORT" CssClass="btn-submit" OnClick="btnSubmit_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel" OnClick="btnCancel_Click" />

                <asp:Label ID="lblMessage" runat="server" CssClass="msg" />
            </div>
        </div>
    </form>
</body>
</html>