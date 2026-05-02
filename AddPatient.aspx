<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddPatient.aspx.cs" Inherits="DisasterProject.AddPatient" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admit Patient – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; margin: 0; }
        .topbar { background: #0b3b5f; color: white; padding: 12px 30px; display: flex; justify-content: space-between; }
        .topbar h3 { margin: 0; font-size: 18px; }
        .topbar a { color: #ffcccc; text-decoration: none; font-size: 14px; }
        .container-main { padding: 20px; max-width: 550px; margin: 0 auto; }
        .card { background: white; border-radius: 8px; padding: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 5px solid #0b3b5f; }
        .card h4 { color: #0b3b5f; font-weight: bold; margin-bottom: 20px; font-size: 20px; }
        label { font-weight: bold; color: #333; display: block; margin-top: 12px; font-size: 14px; }
        .form-control { border: 1px solid #ccc; border-radius: 5px; padding: 8px; width: 100%; box-sizing: border-box; font-size: 14px; }
        .btn-submit { background: #0b3b5f; color: white; font-weight: bold; border: none; border-radius: 5px; cursor: pointer; }
        .btn-cancel { background: #999; color: white; border: none; border-radius: 5px; cursor: pointer; }
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
                <h4>Admit New Patient</h4>

                <label>Patient Name *</label>
                <asp:TextBox ID="txtPatientName" runat="server" CssClass="form-control" placeholder="e.g. Mohammad Bilal" />

                <label>Age *</label>
                <asp:TextBox ID="txtAge" runat="server" CssClass="form-control" TextMode="Number" placeholder="e.g. 34" />

                <label>Hospital *</label>
                <asp:DropDownList ID="ddlHospital" runat="server" CssClass="form-control"></asp:DropDownList>

                <label>Related Incident</label>
                <asp:DropDownList ID="ddlIncident" runat="server" CssClass="form-control"></asp:DropDownList>

                <label>Case Type *</label>
                <asp:DropDownList ID="ddlCaseType" runat="server" CssClass="form-control">
                    <asp:ListItem Text="-- Select --" Value="" />
                    <asp:ListItem Text="Normal" Value="Normal" />
                    <asp:ListItem Text="Critical" Value="Critical" />
                    <asp:ListItem Text="Emergency" Value="Emergency" />
                </asp:DropDownList>

                <div style="display:flex; gap:12px; align-items:center; justify-content:center; margin-top:20px;">
                    <asp:Button ID="btnSubmit" runat="server" Text="ADMIT PATIENT" CssClass="btn-submit" OnClick="btnSubmit_Click" style="padding:10px 25px; font-size:14px; width:160px;" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel" OnClick="btnCancel_Click" style="padding:10px 25px; font-size:14px; width:160px;" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>