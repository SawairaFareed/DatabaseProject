<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="DisasterProject.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login – Disaster MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #e8f0f8; font-family: 'Segoe UI', sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .login-card { background: #fff; border-radius: 10px; padding: 40px; width: 400px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-left: 5px solid #0b3b5f; }
        .login-card h2 { color: #0b3b5f; font-weight: bold; text-align: center; margin-bottom: 10px; font-size: 22px; }
        .subtitle { color: #666; text-align: center; font-size: 13px; margin-bottom: 30px; }
        label { font-weight: bold; color: #333; font-size: 14px; display: block; margin-top: 10px; }
        .form-control { border: 1px solid #ccc; border-radius: 5px; padding: 10px; margin-bottom: 15px; width: 100%; box-sizing: border-box; }
        .btn-login { background: #0b3b5f; color: #fff; font-weight: bold; border: none; border-radius: 5px; padding: 12px; width: 100%; font-size: 16px; cursor: pointer; margin-top: 10px; }
        .btn-login:hover { background: #0a2f4a; }
        .register-link { display: block; text-align: center; margin-top: 15px; color: #0b3b5f; font-size: 14px; text-decoration: none; font-weight: bold; }
        .register-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-card">
            <h2>DISASTER RESPONSE MIS</h2>
            <p class="subtitle">Smart Disaster Response Management</p>

            <label>Login As *</label>
            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                <asp:ListItem Text="-- Select Role --" Value="" />
                <asp:ListItem Text="Administrator" Value="Administrator" />
                <asp:ListItem Text="Emergency Operator" Value="Emergency Operator" />
                <asp:ListItem Text="Field Officer" Value="Field Officer" />
                <asp:ListItem Text="Warehouse Manager" Value="Warehouse Manager" />
                <asp:ListItem Text="Finance Officer" Value="Finance Officer" />
            </asp:DropDownList>

            <label>Username</label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter username" />

            <label>Password</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter password" />

            <asp:Button ID="btnLogin" runat="server" Text="SIGN IN" CssClass="btn-login" OnClick="btnLogin_Click" />

            <a href="RegisterUser.aspx" class="register-link">Not registered? Register Now</a>
        <a href="NewEmergencyReport.aspx" style="color:red; font-weight:bold; display:block; text-align:right; margin-top:15px; text-decoration:none;">⚠️ <span onmouseover="this.style.textDecoration='underline'" onmouseout="this.style.textDecoration='none'">Report Emergency</span></a>
        </div>
    </form>
</body>
</html>