<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterUser.aspx.cs" Inherits="DisasterProject.RegisterUser" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .register-card { background: #fff; border-radius: 10px; padding: 40px; width: 450px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-left: 5px solid #0b3b5f; }
        .register-card h2 { color: #0b3b5f; font-weight: bold; text-align: center; margin-bottom: 20px; font-size: 22px; }
        label { font-weight: bold; color: #333; font-size: 14px; display: block; margin-top: 10px; }
        .form-control { border: 1px solid #ccc; border-radius: 5px; padding: 10px; margin-bottom: 15px; width: 100%; box-sizing: border-box; }
        .btn-register { background: #0b3b5f; color: #fff; font-weight: bold; border: none; border-radius: 5px; padding: 12px; width: 100%; font-size: 16px; cursor: pointer; margin-top: 10px; }
        .btn-register:hover { background: #0a2f4a; }
        .login-link { display: block; text-align: center; margin-top: 15px; color: #0b3b5f; font-size: 14px; text-decoration: none; font-weight: bold; }
        .login-link:hover { text-decoration: underline; }
        .msg { text-align: center; font-weight: bold; margin-top: 15px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-card">
            <h2>Create New Account</h2>

            <label>Register As *</label>
            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                <asp:ListItem Text="-- Select Role --" Value="" />
                <asp:ListItem Text="Administrator" Value="Administrator" />
                <asp:ListItem Text="Emergency Operator" Value="Emergency Operator" />
                <asp:ListItem Text="Field Officer" Value="Field Officer" />
                <asp:ListItem Text="Warehouse Manager" Value="Warehouse Manager" />
                <asp:ListItem Text="Finance Officer" Value="Finance Officer" />
            </asp:DropDownList>

            <label>Username *</label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose a username" />

            <label>Password *</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Create password" />

            <label>Full Name *</label>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter full name" />

            <label>Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="email@example.com" TextMode="Email" />

            <label>Phone</label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="03XX-XXXXXXX" />

            <asp:Button ID="btnRegister" runat="server" Text="REGISTER" CssClass="btn-register" OnClick="btnRegister_Click" />

            <asp:Label ID="lblMessage" runat="server" CssClass="msg" />

            <a href="Login.aspx" class="login-link">Already have an account? Login</a>
        </div>
    </form>
</body>
</html>