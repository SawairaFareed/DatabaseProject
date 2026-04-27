<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FinancialEntry.aspx.cs" Inherits="DisasterProject.FinancialEntry" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Financial Entry – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; margin: 0; }
        .topbar { background: #0b3b5f; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .topbar h3 { margin: 0; }
        .topbar a { color: #ffcccc; text-decoration: none; }
        .container-main { padding: 30px; max-width: 800px; margin: 0 auto; }
        .card { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 5px solid #0b3b5f; margin-bottom: 25px; }
        .card h4 { color: #0b3b5f; font-weight: bold; margin-bottom: 25px; }
        label { font-weight: bold; color: #333; display: block; margin-top: 15px; }
        .form-control { border: 1px solid #ccc; border-radius: 5px; padding: 10px; width: 100%; box-sizing: border-box; margin-bottom: 10px; }
        .btn-submit { background: #0b3b5f; color: white; font-weight: bold; border: none; border-radius: 5px; padding: 12px 30px; font-size: 16px; cursor: pointer; }
        .btn-submit:hover { background: #0a2f4a; }
        .msg { margin-top: 15px; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #0b3b5f; color: white; padding: 10px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
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
                <h4>Record Financial Transaction</h4>

                <label>Transaction Type *</label>
                <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control">
                    <asp:ListItem Text="-- Select --" Value="" />
                    <asp:ListItem Text="Donation" Value="Donation" />
                    <asp:ListItem Text="Expense" Value="Expense" />
                    <asp:ListItem Text="Procurement" Value="Procurement" />
                </asp:DropDownList>

                <label>Amount (PKR) *</label>
                <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" placeholder="Enter amount" TextMode="Number" />

                <label>Related Incident</label>
                <asp:DropDownList ID="ddlIncident" runat="server" CssClass="form-control"></asp:DropDownList>

                <label>Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Brief description..." />

                <br />
                <asp:Button ID="btnSubmit" runat="server" Text="RECORD TRANSACTION" CssClass="btn-submit" OnClick="btnSubmit_Click" />

                <asp:Label ID="lblMessage" runat="server" CssClass="msg" />
            </div>

            <div class="card">
                <h4>Recent Transactions</h4>
             <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="True" CssClass="table" 
    HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White" />     
            </div>
        </div>
    </form>
</body>
</html>