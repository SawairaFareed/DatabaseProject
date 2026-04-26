<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeamStatusUpdate.aspx.cs" Inherits="DisasterProject.TeamStatusUpdate" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Update Team Status – Disaster MIS</title>
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
        .btn-complete { background: #28a745; color: white; border: none; padding: 5px 15px; border-radius: 4px; cursor: pointer; }
        .msg { font-weight: bold; margin-top: 15px; }
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
                <h4>My Active Assignments</h4>
                <asp:GridView ID="gvAssignments" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered"
                    OnRowCommand="gvAssignments_RowCommand" DataKeyNames="AssignmentID"
                    HeaderStyle-BackColor="#0b3b5f" HeaderStyle-ForeColor="White">
                    <Columns>
                        <asp:BoundField DataField="AssignmentID" HeaderText="Assignment ID" />
                        <asp:BoundField DataField="TeamName" HeaderText="Team" />
                        <asp:BoundField DataField="IncidentLocation" HeaderText="Incident Location" />
                        <asp:BoundField DataField="DisasterType" HeaderText="Disaster Type" />
                        <asp:BoundField DataField="AssignedAt" HeaderText="Assigned At" />
                        <asp:BoundField DataField="AssignmentStatus" HeaderText="Status" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnComplete" runat="server" Text="Mark Completed" CssClass="btn-complete"
                                    CommandName="Complete" CommandArgument='<%# Eval("AssignmentID") %>' />
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