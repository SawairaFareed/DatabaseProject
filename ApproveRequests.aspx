<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ApproveRequests.aspx.cs" Inherits="DisasterProject.ApproveRequests" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Approve Requests – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; margin: 0; }
        .topbar { background: #0b3b5f; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .topbar h3 { margin: 0; }
        .topbar a { color: #ffcccc; text-decoration: none; }
        .container-main { padding: 30px; }
        .card { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .card h5 { color: #0b3b5f; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { background: #0b3b5f; color: white; padding: 10px; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        .btn-sm { padding: 5px 15px; font-size: 14px; border-radius: 4px; border: none; cursor: pointer; color: white; }
        .btn-approve { background: #28a745; }
        .btn-reject { background: #dc3545; }
        .msg { font-weight: bold; margin-top: 10px; }
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
                <h5>Pending Approvals</h5>
                <asp:GridView ID="gvPending" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered" 
                    OnRowCommand="gvPending_RowCommand" DataKeyNames="ApprovalID"
                     HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White">
                    <Columns>
                        <asp:BoundField DataField="ApprovalID" HeaderText="ID" />
                        <asp:BoundField DataField="RequestType" HeaderText="Request Type" />
                        <asp:BoundField DataField="ReferenceID" HeaderText="Reference ID" />
                        <asp:BoundField DataField="RequestedBy" HeaderText="Requested By" />
                        <asp:BoundField DataField="RequestedAt" HeaderText="Requested At" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnApprove" runat="server" Text="Approve" CssClass="btn-sm btn-approve" 
                                    CommandName="Approve" CommandArgument='<%# Eval("ApprovalID") %>' />
                                <asp:Button ID="btnReject" runat="server" Text="Reject" CssClass="btn-sm btn-reject" 
                                    CommandName="Reject" CommandArgument='<%# Eval("ApprovalID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:Label ID="lblMessage" runat="server" CssClass="msg" />
            </div>
        </div>
    </form>
</body>
</html>