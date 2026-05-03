# DatabaseProject
# 🚨 Smart Disaster Response MIS

![.NET](https://img.shields.io/badge/.NET-4.8-blue)
![SQL Server](https://img.shields.io/badge/SQL%20Server-LocalDB-red)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.2-purple)
![Chart.js](https://img.shields.io/badge/Chart.js-4.4-orange)

---

# 📖 Smart Disaster Response Management Information System

The **Smart Disaster Response Management Information System (MIS)** is a full-stack enterprise-level web application developed to improve disaster response coordination and operational efficiency.

Built using **ASP.NET Web Forms**, **C#**, and **SQL Server**, the system enables seamless collaboration between:

- 🚑 Emergency Operators
- 🧑‍🚒 Field Officers
- 📦 Warehouse Managers
- 💰 Finance Officers
- 🛡️ Administrators

The platform supports:

- Real-time emergency reporting
- Rescue team coordination
- Resource and warehouse management
- Hospital bed monitoring
- Financial tracking
- Approval workflows
- Audit logging

---

# ✨ Key Features

## 🔐 Role-Based Access Control (RBAC)

| Role | Dashboard Access | Core Functionalities |
|------|------------------|----------------------|
| **Administrator** | Full Dashboard | Complete system control, approvals, audit monitoring |
| **Emergency Operator** | Reports, Teams, Status | Report emergencies, assign rescue teams |
| **Field Officer** | Team Status | Update assignment progress and completion |
| **Warehouse Manager** | Inventory, Resources | Manage stock and dispatch resources |
| **Finance Officer** | Financial Dashboard | Record donations, expenses, procurement |

---

## 🚨 Emergency Reporting

- Public users can submit disaster reports **without authentication**
- Capture:
  - Disaster Type
  - Severity Level
  - Location
  - Description
- Real-time status workflow:
  - Open
  - In-Progress
  - Resolved
  - Closed

---

## 🚑 Rescue Team Management

- Assign teams dynamically
- Auto-update team availability
- Maintain historical assignment records
- Trigger-based status synchronization

---

## 📦 Resource & Warehouse Management

- Warehouse-wise inventory tracking
- Low-stock threshold alerts
- Resource allocation workflow
- Automatic stock deduction after dispatch

---

## 🏥 Hospital Coordination

- Real-time hospital bed availability
- Patient admission tracking
- Automatic bed count updates
- Doughnut chart visualization using Chart.js

## 💰 Financial Management

- Track:
  - Donations
  - Expenses
  - Procurement
- Validation alerts
- Audit trail logging via SQL triggers

---

## ✅ Approval Workflow

- Pending → Approved/Rejected flow
- Approval history maintenance
- Administrative review controls

---

# 🛠️ Technology Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | ASP.NET Web Forms (.NET Framework 4.8), Bootstrap 5, Chart.js |
| **Backend** | C#, ADO.NET |
| **Database** | SQL Server LocalDB / SQL Server Express |
| **IDE** | Visual Studio 2022 |
| **Version Control** | Git & GitHub |

---

# 🗄️ Database Schema

## 📋 Tables Overview (15 Tables)

| # | Table Name | Description |
|---|------------|-------------|
| 1 | `USERS` | Stores all system users |
| 2 | `ROLES` | Stores predefined roles |
| 3 | `USER_ROLES` | User-role mapping |
| 4 | `EMERGENCY_REPORTS` | Disaster incident reports |
| 5 | `RESCUE_TEAMS` | Rescue team information |
| 6 | `TEAM_ASSIGNMENTS` | Team assignment tracking |
| 7 | `WAREHOUSES` | Warehouse details |
| 8 | `RESOURCES` | Inventory resources |
| 9 | `RESOURCE_ALLOCATIONS` | Resource dispatch records |
| 10 | `HOSPITALS` | Hospital information |
| 11 | `PATIENTS` | Patient admission records |
| 12 | `FINANCIAL_TRANSACTIONS` | Financial entries |
| 13 | `APPROVAL_REQUESTS` | Request approval workflow |
| 14 | `AUDIT_LOGS` | User action logs |
| 15 | `TRANSACTION_AUDIT` | Trigger-generated financial audit logs |

---

# ⚡ Database Automation

## 🔄 SQL Triggers (6 Triggers)

| Trigger | Event | Purpose |
|---------|------|---------|
| `trg_update_stock` | Resource dispatch | Deduct stock automatically |
| `trg_prevent_neg_stock` | Stock update | Prevent negative inventory |
| `trg_team_status_assign` | Team assignment | Set status to Assigned |
| `trg_team_status_complete` | Assignment completion | Restore Available status |
| `trg_financial_audit_insert` | New transaction | Create audit log |
| `trg_financial_audit_update` | Transaction update | Track old/new values |

---

# 📄 System Pages

## 🌐 Application Pages (18 Pages)

| # | Page | Access Level |
|---|------|--------------|
| 1 | `Login.aspx` | Public |
| 2 | `RegisterUser.aspx` | Public |
| 3 | `Dashboard.aspx` | All Roles |
| 4 | `NewEmergencyReport.aspx` | Public / Admin / Emergency Operator |
| 5 | `EmergencyReports.aspx` | Admin / Emergency Operator |
| 6 | `ResourceRequest.aspx` | Admin / Warehouse Manager |
| 7 | `InventoryStatus.aspx` | Admin / Warehouse Manager |
| 8 | `AddResource.aspx` | Admin / Warehouse Manager |
| 9 | `AssignTeam.aspx` | Admin / Emergency Operator |
| 10 | `AddRescueTeam.aspx` | Admin / Emergency Operator |
| 11 | `FinancialEntry.aspx` | Admin / Finance Officer |
| 12 | `ApproveRequests.aspx` | Admin |
| 13 | `AuditLogs.aspx` | Admin |
| 14 | `AddHospital.aspx` | Admin |
| 15 | `AddPatient.aspx` | Admin / Emergency Operator |
| 16 | `HospitalStatus.aspx` | All Roles |
| 17 | `TeamStatusUpdate.aspx` | Admin / Field Officer |
| 18 | `MISReports.aspx` | All Roles |

---

# 🧪 Test Credentials

| Role | Username | Password |
|------|----------|----------|
| Administrator | `admin` | `admin123` |
| Emergency Operator | `sara` | `sara123` |
| Field Officer | `umar` | `umar123` |
| Warehouse Manager | `zainab` | `zainab123` |
| Finance Officer | `hassan` | `hassan123` |

---

# 🚀 How to Run the Project

## ✅ Prerequisites

Install the following before running the project:

- Visual Studio 2022
- SQL Server LocalDB or SQL Server Express
- .NET Framework 4.8

---

## ⚙️ Setup Instructions

### 1️⃣ Clone Repository

```bash
git clone https://github.com/SawairaFareed/DatabaseProject.git
```

---

### 2️⃣ Open Solution

Open:

```plaintext
DisasterProject.sln
```

using Visual Studio 2022.

---

### 3️⃣ Setup Database

- Open **SQL Server Object Explorer**
- Connect to:

```plaintext
(localdb)\MSSQLLocalDB
```

- Run:

```plaintext
DB_Project_Schema.sql
```

This script contains:

- Tables
- Constraints
- Triggers
- Views
- Indexes
- Transactions
- Sample Data

---

### 4️⃣ Configure Connection String

If required, update:

```plaintext
Web.config
```

Example:

```xml
<connectionStrings>
  <add name="DisasterDB"
       connectionString="Data Source=(localdb)\MSSQLLocalDB;
       Initial Catalog=DisasterMIS;
       Integrated Security=True"
       providerName="System.Data.SqlClient"/>
</connectionStrings>
```

---

### 5️⃣ Build & Run

Press:

```plaintext
Ctrl + F5
```

Then log in using the provided credentials.

---

# 📁 Project Structure

```plaintext
DisasterProject/
│
├── App_Code/
│   └── DbHelper.cs
│
├── *.aspx
├── *.aspx.cs
├── *.aspx.designer.cs
│
├── Web.config
├── Global.asax
├── packages.config
├── DisasterProject.sln
│
├── DB_Project_Schema.sql
│
├── ERD.drawio.svg
├── RelationalSchema.drawio.svg
│
├── C_G11_i243043_i243180_i243150.pdf
│
└── README.md
```

---

# 📊 ERD & Relational Schema

| Diagram | File |
|---------|------|
| ERD | `ERD.drawio.svg` |
| Relational Schema | `RelationalSchema.drawio.svg` |

> 📝 `.drawio.svg` files can be previewed directly on GitHub and edited using draw.io.

---

# 👥 Team Members

| Roll Number | Name |
|------------|------|
| 24I-3043 | Sawaira Fareed |
| 24I-3150 | Hanzala Ahsan |
| 24I-3180 | Ermish Tabassum |

---

# 📜 License

This project was developed for academic purposes as part of the **Database Systems** course at **FAST-NUCES**.

All rights reserved © 2026.

---

# 💡 Project Vision

> *"In times of disaster, every second matters. Systems that coordinate efficiently save lives."*

---

# ⭐ Future Enhancements

Potential future upgrades include:

- 🌍 GIS & live map integration
- 📱 Mobile application support
- 🔔 SMS & Email notifications
- 🤖 AI-based disaster prediction
- ☁️ Cloud deployment (Azure/AWS)
- 📡 IoT sensor integration
- 🔐 JWT Authentication & APIs

---

# 🔥 Repository Highlights

✅ Enterprise-style architecture  
✅ SQL triggers & transaction handling  
✅ Role-based authorization  
✅ MIS dashboards & reporting  
✅ Hospital coordination module  
✅ Inventory automation  
✅ Financial audit system  

---

