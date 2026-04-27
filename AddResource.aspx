<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddResource.aspx.cs" Inherits="DisasterProject.AddResource" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Resource – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; margin: 0; }
        .topbar { background: #0b3b5f; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .topbar h3 { margin: 0; }
        .topbar a { color: #ffcccc; text-decoration: none; }
        .container-main { padding: 30px; max-width: 600px; margin: 0 auto; }
        .card { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 5px solid #0b3b5f; }
        .card h4 { color: #0b3b5f; font-weight: bold; margin-bottom: 25px; }
        label { font-weight: bold; color: #333; display: block; margin-top: 15px; }
        .form-control { border: 1px solid #ccc; border-radius: 5px; padding: 10px; width: 100%; box-sizing: border-box; margin-bottom: 10px; }
        .btn-submit { background: #0b3b5f; color: white; font-weight: bold; border: none; border-radius: 5px; padding: 12px 30px; font-size: 16px; cursor: pointer; }
        .btn-submit:hover { background: #0a2f4a; }
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
                <h4>Add New Resource</h4>

                <label>Warehouse *</label>
                <asp:DropDownList ID="ddlWarehouse" runat="server" CssClass="form-control"></asp:DropDownList>

                <label>Resource Name *</label>
                <asp:TextBox ID="txtResourceName" runat="server" CssClass="form-control" placeholder="e.g. Rice (50kg)" />

                <label>Resource Type *</label>
                <asp:DropDownList ID="ddlResourceType" runat="server" CssClass="form-control">
                    <asp:ListItem Text="-- Select --" Value="" />
                    <asp:ListItem Text="Food" Value="Food" />
                    <asp:ListItem Text="Water" Value="Water" />
                    <asp:ListItem Text="Medicine" Value="Medicine" />
                    <asp:ListItem Text="Shelter" Value="Shelter" />
                </asp:DropDownList>

                <label>Quantity Available *</label>
                <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control" TextMode="Number" placeholder="e.g. 500" />

                <label>Threshold Level *</label>
                <asp:TextBox ID="txtThreshold" runat="server" CssClass="form-control" TextMode="Number" placeholder="e.g. 50" />

                <label>Unit</label>
                <asp:TextBox ID="txtUnit" runat="server" CssClass="form-control" placeholder="e.g. bags, liters, strips" />

                <br />
                <asp:Button ID="btnAddResource" runat="server" Text="ADD RESOURCE" CssClass="btn-submit" OnClick="btnAddResource_Click" />

                <asp:Label ID="lblMessage" runat="server" CssClass="msg" />
            </div>
        </div>
    </form>
</body>
</html>