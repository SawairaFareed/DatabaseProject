<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryStatus.aspx.cs" Inherits="DisasterProject.InventoryStatus" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Inventory Status – Disaster MIS</title>
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
        .low-stock { background: #ffe0e0 !important; }
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
                <h4>Inventory Status</h4>
                <asp:DropDownList ID="ddlFilter" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" CssClass="form-select" style="width:200px; margin-bottom:20px;">
                    <asp:ListItem Text="All Types" Value="All" />
                    <asp:ListItem Text="Food" Value="Food" />
                    <asp:ListItem Text="Water" Value="Water" />
                    <asp:ListItem Text="Medicine" Value="Medicine" />
                    <asp:ListItem Text="Shelter" Value="Shelter" />
                </asp:DropDownList>
               <asp:GridView ID="gvInventory" runat="server" AutoGenerateColumns="True" CssClass="table table-bordered" 
    OnRowDataBound="gvInventory_RowDataBound" 
    HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White" />
            </div>
        </div>
    </form>
</body>
</html>