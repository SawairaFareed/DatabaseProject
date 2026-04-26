-- ============================================================
--  Smart Disaster Response MIS — Complete SQL File
--  SQL Server (T-SQL)
--  Includes: DDL, DML, Triggers, Views, Indexes, Transactions
-- ============================================================

USE master;
GO
DROP DATABASE disasterDB;
GO
CREATE DATABASE disasterDB;
GO
USE disasterDB;
GO

-- ============================================================
--  SECTION 1: TABLE CREATION (DDL — 15 Tables)
-- ============================================================

-- 1.1 ROLES
CREATE TABLE ROLES (
    RoleID      INT          NOT NULL IDENTITY(1,1),
    RoleName    VARCHAR(50)  NOT NULL,
    Description VARCHAR(255) NULL,
    CONSTRAINT pk_roles PRIMARY KEY (RoleID),
    CONSTRAINT uq_roles_name UNIQUE (RoleName)
);
GO

-- 1.2 USERS
CREATE TABLE USERS (
    UserID       INT          NOT NULL IDENTITY(1,1),
    Username     VARCHAR(50)  NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName     VARCHAR(100) NOT NULL,
    Email        VARCHAR(100) NULL,
    Phone        VARCHAR(20)  NULL,
    IsActive     BIT          NOT NULL DEFAULT 1,
    CreatedAt    DATETIME2    NOT NULL DEFAULT GETDATE(),
    CONSTRAINT pk_users PRIMARY KEY (UserID),
    CONSTRAINT uq_users_username UNIQUE (Username),
    CONSTRAINT uq_users_email    UNIQUE (Email)
);
GO

-- 1.3 USER_ROLES
CREATE TABLE USER_ROLES (
    UserID     INT       NOT NULL,
    RoleID     INT       NOT NULL,
    AssignedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT pk_user_roles PRIMARY KEY (UserID, RoleID),
    CONSTRAINT fk_ur_user FOREIGN KEY (UserID) REFERENCES USERS(UserID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ur_role FOREIGN KEY (RoleID) REFERENCES ROLES(RoleID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 1.4 EMERGENCY_REPORTS
CREATE TABLE EMERGENCY_REPORTS (
    ReportID         INT           NOT NULL IDENTITY(1,1),
    ReportedByUserID INT           NULL,
    Location         VARCHAR(255)  NOT NULL,
    DisasterType     VARCHAR(20)   NOT NULL,
    SeverityLevel    VARCHAR(20)   NOT NULL,
    ReportTime       DATETIME2     NOT NULL DEFAULT GETDATE(),
    Status           VARCHAR(20)   NOT NULL DEFAULT 'Open',
    CONSTRAINT pk_emergency_reports PRIMARY KEY (ReportID),
    CONSTRAINT chk_disaster_type CHECK (DisasterType IN ('Flood','Earthquake','Fire','Other')),
    CONSTRAINT chk_severity_level CHECK (SeverityLevel IN ('Low','Medium','High','Critical')),
    CONSTRAINT chk_report_status CHECK (Status IN ('Open','In-Progress','Resolved','Closed')),
    CONSTRAINT fk_er_user FOREIGN KEY (ReportedByUserID)
        REFERENCES USERS(UserID) ON DELETE SET NULL ON UPDATE CASCADE
);
GO

-- 1.5 RESCUE_TEAMS
CREATE TABLE RESCUE_TEAMS (
    TeamID             INT          NOT NULL IDENTITY(1,1),
    TeamName           VARCHAR(100) NOT NULL,
    TeamType           VARCHAR(20)  NOT NULL,
    CurrentLocation    VARCHAR(200) NULL,
    AvailabilityStatus VARCHAR(20)  NOT NULL DEFAULT 'Available',
    CONSTRAINT pk_rescue_teams PRIMARY KEY (TeamID),
    CONSTRAINT chk_team_type CHECK (TeamType IN ('Medical','Fire','Rescue')),
    CONSTRAINT chk_team_status CHECK (AvailabilityStatus IN ('Available','Assigned','Busy','Completed'))
);
GO

-- 1.6 TEAM_ASSIGNMENTS
CREATE TABLE TEAM_ASSIGNMENTS (
    AssignmentID     INT         NOT NULL IDENTITY(1,1),
    TeamID           INT         NOT NULL,
    ReportID         INT         NOT NULL,
    AssignedAt       DATETIME2   NOT NULL DEFAULT GETDATE(),
    CompletedAt      DATETIME2   NULL,
    AssignmentStatus VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT pk_team_assignments PRIMARY KEY (AssignmentID),
    CONSTRAINT chk_assignment_status CHECK (AssignmentStatus IN ('Active','Completed','Cancelled')),
    CONSTRAINT fk_ta_team FOREIGN KEY (TeamID)
        REFERENCES RESCUE_TEAMS(TeamID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_ta_report FOREIGN KEY (ReportID)
        REFERENCES EMERGENCY_REPORTS(ReportID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 1.7 WAREHOUSES
CREATE TABLE WAREHOUSES (
    WarehouseID   INT          NOT NULL IDENTITY(1,1),
    WarehouseName VARCHAR(100) NOT NULL,
    Location      VARCHAR(200) NULL,
    ManagerUserID INT          NULL,
    CONSTRAINT pk_warehouses PRIMARY KEY (WarehouseID),
    CONSTRAINT fk_wh_manager FOREIGN KEY (ManagerUserID)
        REFERENCES USERS(UserID) ON DELETE SET NULL ON UPDATE NO ACTION
);
GO

-- 1.8 RESOURCES
CREATE TABLE RESOURCES (
    ResourceID        INT           NOT NULL IDENTITY(1,1),
    WarehouseID       INT           NOT NULL,
    ResourceName      VARCHAR(100)  NOT NULL,
    ResourceType      VARCHAR(20)   NOT NULL,
    QuantityAvailable DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    ThresholdLevel    DECIMAL(10,2) NOT NULL DEFAULT 10.00,
    Unit              VARCHAR(30)   NULL,
    CONSTRAINT pk_resources PRIMARY KEY (ResourceID),
    CONSTRAINT chk_resource_type CHECK (ResourceType IN ('Food','Water','Medicine','Shelter')),
    CONSTRAINT chk_qty_nonneg CHECK (QuantityAvailable >= 0),
    CONSTRAINT fk_res_warehouse FOREIGN KEY (WarehouseID)
        REFERENCES WAREHOUSES(WarehouseID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 1.9 RESOURCE_ALLOCATIONS
CREATE TABLE RESOURCE_ALLOCATIONS (
    AllocationID       INT           NOT NULL IDENTITY(1,1),
    ResourceID         INT           NOT NULL,
    ReportID           INT           NOT NULL,
    RequestedByUserID  INT           NULL,
    QuantityRequested  DECIMAL(10,2) NOT NULL,
    QuantityDispatched DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    RequestedAt        DATETIME2     NOT NULL DEFAULT GETDATE(),
    Status             VARCHAR(20)   NOT NULL DEFAULT 'Pending',
    CONSTRAINT pk_resource_allocations PRIMARY KEY (AllocationID),
    CONSTRAINT chk_alloc_status CHECK (Status IN ('Pending','Approved','Dispatched','Cancelled')),
    CONSTRAINT fk_ra_resource FOREIGN KEY (ResourceID)
        REFERENCES RESOURCES(ResourceID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_ra_report FOREIGN KEY (ReportID)
        REFERENCES EMERGENCY_REPORTS(ReportID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_ra_user FOREIGN KEY (RequestedByUserID)
        REFERENCES USERS(UserID) ON DELETE SET NULL ON UPDATE NO ACTION
);
GO

-- 1.10 HOSPITALS
CREATE TABLE HOSPITALS (
    HospitalID    INT          NOT NULL IDENTITY(1,1),
    HospitalName  VARCHAR(150) NOT NULL,
    Location      VARCHAR(200) NULL,
    TotalBeds     INT          NOT NULL DEFAULT 0,
    AvailableBeds INT          NOT NULL DEFAULT 0,
    ContactPhone  VARCHAR(20)  NULL,
    CONSTRAINT pk_hospitals PRIMARY KEY (HospitalID),
    CONSTRAINT chk_beds_nonneg CHECK (AvailableBeds >= 0),
    CONSTRAINT chk_avail_lte_total CHECK (AvailableBeds <= TotalBeds)
);
GO

-- 1.11 PATIENTS
CREATE TABLE PATIENTS (
    PatientID    INT          NOT NULL IDENTITY(1,1),
    HospitalID   INT          NOT NULL,
    ReportID     INT          NULL,
    PatientName  VARCHAR(100) NOT NULL,
    Age          INT          NULL,
    CaseType     VARCHAR(20)  NOT NULL DEFAULT 'Normal',
    AdmittedAt   DATETIME2    NOT NULL DEFAULT GETDATE(),
    DischargedAt DATETIME2    NULL,
    CONSTRAINT pk_patients PRIMARY KEY (PatientID),
    CONSTRAINT chk_case_type CHECK (CaseType IN ('Normal','Critical','Emergency')),
    CONSTRAINT fk_pat_hospital FOREIGN KEY (HospitalID)
        REFERENCES HOSPITALS(HospitalID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_pat_report FOREIGN KEY (ReportID)
        REFERENCES EMERGENCY_REPORTS(ReportID) ON DELETE SET NULL ON UPDATE NO ACTION
);
GO

-- 1.12 FINANCIAL_TRANSACTIONS
CREATE TABLE FINANCIAL_TRANSACTIONS (
    TransactionID    INT           NOT NULL IDENTITY(1,1),
    ReportID         INT           NULL,
    RecordedByUserID INT           NULL,
    TransactionType  VARCHAR(20)   NOT NULL,
    Amount           DECIMAL(15,2) NOT NULL,
    TransactionDate  DATETIME2     NOT NULL DEFAULT GETDATE(),
    Description      VARCHAR(300)  NULL,
    CONSTRAINT pk_financial_transactions PRIMARY KEY (TransactionID),
    CONSTRAINT chk_txn_type CHECK (TransactionType IN ('Donation','Expense','Procurement')),
    CONSTRAINT chk_amount_pos CHECK (Amount > 0),
    CONSTRAINT fk_fin_report FOREIGN KEY (ReportID)
        REFERENCES EMERGENCY_REPORTS(ReportID) ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT fk_fin_user FOREIGN KEY (RecordedByUserID)
        REFERENCES USERS(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 1.13 APPROVAL_REQUESTS
CREATE TABLE APPROVAL_REQUESTS (
    ApprovalID        INT          NOT NULL IDENTITY(1,1),
    RequestType       VARCHAR(30)  NOT NULL,
    ReferenceID       INT          NOT NULL,
    RequestedByUserID INT          NULL,
    ApprovedByUserID  INT          NULL,
    Status            VARCHAR(20)  NOT NULL DEFAULT 'Pending',
    RequestedAt       DATETIME2    NOT NULL DEFAULT GETDATE(),
    ReviewedAt        DATETIME2    NULL,
    Remarks           VARCHAR(300) NULL,
    CONSTRAINT pk_approval_requests PRIMARY KEY (ApprovalID),
    CONSTRAINT chk_request_type CHECK (RequestType IN ('ResourceDistribution','RescueDeployment','FinancialApproval')),
    CONSTRAINT chk_apr_status CHECK (Status IN ('Pending','Approved','Rejected')),
    CONSTRAINT fk_apr_requester FOREIGN KEY (RequestedByUserID)
        REFERENCES USERS(UserID) ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT fk_apr_approver FOREIGN KEY (ApprovedByUserID)
        REFERENCES USERS(UserID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- 1.14 AUDIT_LOGS
CREATE TABLE AUDIT_LOGS (
    LogID         INT          NOT NULL IDENTITY(1,1),
    UserID        INT          NULL,
    ActionType    VARCHAR(10)  NOT NULL,
    TableAffected VARCHAR(50)  NULL,
    RecordID      INT          NULL,
    OldValue      VARCHAR(MAX) NULL,
    NewValue      VARCHAR(MAX) NULL,
    Timestamp     DATETIME2    NOT NULL DEFAULT GETDATE(),
    CONSTRAINT pk_audit_logs PRIMARY KEY (LogID),
    CONSTRAINT chk_action_type CHECK (ActionType IN ('INSERT','UPDATE','DELETE','LOGIN','LOGOUT')),
    CONSTRAINT fk_aud_user FOREIGN KEY (UserID)
        REFERENCES USERS(UserID) ON DELETE SET NULL ON UPDATE NO ACTION
);
GO

-- 1.15 TRANSACTION_AUDIT
CREATE TABLE TRANSACTION_AUDIT (
    AuditID       INT           NOT NULL IDENTITY(1,1),
    TransactionID INT           NOT NULL,
    Operation     VARCHAR(10)   NOT NULL,
    OldAmount     DECIMAL(15,2) NULL,
    NewAmount     DECIMAL(15,2) NULL,
    ChangedAt     DATETIME2     NOT NULL DEFAULT GETDATE(),
    CONSTRAINT pk_transaction_audit PRIMARY KEY (AuditID),
    CONSTRAINT chk_audit_op CHECK (Operation IN ('INSERT','UPDATE','DELETE')),
    CONSTRAINT fk_ta_transaction FOREIGN KEY (TransactionID)
        REFERENCES FINANCIAL_TRANSACTIONS(TransactionID) ON DELETE CASCADE ON UPDATE NO ACTION
);
GO

-- ============================================================
--  SECTION 2: TRIGGERS (6 Triggers)
-- ============================================================

-- 2.1 Stock update on dispatch
CREATE OR ALTER TRIGGER trg_update_stock
ON RESOURCE_ALLOCATIONS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN deleted d ON i.AllocationID = d.AllocationID
        WHERE i.Status = 'Dispatched' AND d.Status != 'Dispatched'
    )
    BEGIN
        UPDATE r
        SET QuantityAvailable = r.QuantityAvailable - i.QuantityDispatched
        FROM RESOURCES r
        INNER JOIN inserted i ON r.ResourceID = i.ResourceID
        INNER JOIN deleted d ON i.AllocationID = d.AllocationID
        WHERE i.Status = 'Dispatched' AND d.Status != 'Dispatched';
    END
END
GO

-- 2.2 Prevent negative stock
CREATE OR ALTER TRIGGER trg_prevent_neg_stock
ON RESOURCES
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE QuantityAvailable < 0)
    BEGIN
        THROW 50000, 'ERROR: Insufficient stock — QuantityAvailable cannot be negative.', 1;
        ROLLBACK TRANSACTION;
    END
END
GO

-- 2.3 Team status to Assigned
CREATE OR ALTER TRIGGER trg_team_status_assign
ON TEAM_ASSIGNMENTS
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE rt
    SET AvailabilityStatus = 'Assigned'
    FROM RESCUE_TEAMS rt
    INNER JOIN inserted i ON rt.TeamID = i.TeamID
    WHERE i.AssignmentStatus = 'Active';
END
GO

-- 2.4 Team status to Available on completion
CREATE OR ALTER TRIGGER trg_team_status_complete
ON TEAM_ASSIGNMENTS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN deleted d ON i.AssignmentID = d.AssignmentID
        WHERE i.AssignmentStatus = 'Completed' AND d.AssignmentStatus != 'Completed'
    )
    BEGIN
        UPDATE rt
        SET AvailabilityStatus = 'Available'
        FROM RESCUE_TEAMS rt
        INNER JOIN inserted i ON rt.TeamID = i.TeamID;
    END
END
GO

-- 2.5 Financial audit on INSERT
CREATE OR ALTER TRIGGER trg_financial_audit_insert
ON FINANCIAL_TRANSACTIONS
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO TRANSACTION_AUDIT (TransactionID, Operation, OldAmount, NewAmount)
    SELECT TransactionID, 'INSERT', NULL, Amount FROM inserted;
END
GO

-- 2.6 Financial audit on UPDATE
CREATE OR ALTER TRIGGER trg_financial_audit_update
ON FINANCIAL_TRANSACTIONS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Amount)
    BEGIN
        INSERT INTO TRANSACTION_AUDIT (TransactionID, Operation, OldAmount, NewAmount)
        SELECT i.TransactionID, 'UPDATE', d.Amount, i.Amount
        FROM inserted i
        INNER JOIN deleted d ON i.TransactionID = d.TransactionID
        WHERE i.Amount != d.Amount;
    END
END
GO

-- ============================================================
--  SECTION 3: VIEWS (4 Views)
-- ============================================================

-- 3.1 Incident Dashboard
CREATE OR ALTER VIEW vw_IncidentDashboard AS
SELECT
    er.ReportID,
    er.Location,
    er.DisasterType,
    er.SeverityLevel,
    er.ReportTime,
    er.Status AS IncidentStatus,
    u.FullName AS ReportedBy,
    COUNT(DISTINCT ta.AssignmentID) AS TeamsAssigned,
    COALESCE(SUM(ra.QuantityDispatched), 0) AS TotalResourcesDispatched
FROM EMERGENCY_REPORTS er
LEFT JOIN USERS u ON er.ReportedByUserID = u.UserID
LEFT JOIN TEAM_ASSIGNMENTS ta ON er.ReportID = ta.ReportID
LEFT JOIN RESOURCE_ALLOCATIONS ra ON er.ReportID = ra.ReportID
GROUP BY er.ReportID, er.Location, er.DisasterType, er.SeverityLevel, er.ReportTime, er.Status, u.FullName;
GO

-- 3.2 Finance Officer View
CREATE OR ALTER VIEW vw_FinanceOfficerView AS
SELECT
    ft.TransactionID,
    ft.ReportID,
    er.Location AS IncidentLocation,
    er.DisasterType,
    ft.TransactionType,
    ft.Amount,
    ft.TransactionDate,
    ft.Description,
    u.FullName AS RecordedBy
FROM FINANCIAL_TRANSACTIONS ft
LEFT JOIN EMERGENCY_REPORTS er ON ft.ReportID = er.ReportID
LEFT JOIN USERS u ON ft.RecordedByUserID = u.UserID;
GO

-- 3.3 Resource Status (with Low Stock Flag)
CREATE OR ALTER VIEW vw_ResourceStatus AS
SELECT
    r.ResourceID,
    r.ResourceName,
    r.ResourceType,
    r.QuantityAvailable,
    r.ThresholdLevel,
    r.Unit,
    w.WarehouseName,
    w.Location AS WarehouseLocation,
    CASE WHEN r.QuantityAvailable < r.ThresholdLevel THEN 1 ELSE 0 END AS LowStockFlag
FROM RESOURCES r
JOIN WAREHOUSES w ON r.WarehouseID = w.WarehouseID;
GO

-- 3.4 Field Officer Assignments
CREATE OR ALTER VIEW vw_FieldOfficerAssignments AS
SELECT
    ta.AssignmentID,
    rt.TeamName,
    rt.TeamType,
    rt.CurrentLocation AS TeamLocation,
    ta.ReportID,
    er.Location AS IncidentLocation,
    er.DisasterType,
    er.SeverityLevel,
    ta.AssignedAt,
    ta.AssignmentStatus
FROM TEAM_ASSIGNMENTS ta
JOIN RESCUE_TEAMS rt ON ta.TeamID = rt.TeamID
JOIN EMERGENCY_REPORTS er ON ta.ReportID = er.ReportID
WHERE ta.AssignmentStatus = 'Active';
GO

-- ============================================================
--  SECTION 4: INDEXES (13 Indexes)
-- ============================================================

CREATE INDEX idx_report_location   ON EMERGENCY_REPORTS (Location);
CREATE INDEX idx_report_type       ON EMERGENCY_REPORTS (DisasterType);
CREATE INDEX idx_report_status     ON EMERGENCY_REPORTS (Status);
CREATE INDEX idx_resource_type     ON RESOURCES (ResourceType);
CREATE INDEX idx_fin_date          ON FINANCIAL_TRANSACTIONS (TransactionDate);
CREATE INDEX idx_fin_type          ON FINANCIAL_TRANSACTIONS (TransactionType);
CREATE INDEX idx_audit_user        ON AUDIT_LOGS (UserID);
CREATE INDEX idx_audit_timestamp   ON AUDIT_LOGS (Timestamp);
CREATE INDEX idx_alloc_status      ON RESOURCE_ALLOCATIONS (Status);
CREATE INDEX idx_team_status       ON RESCUE_TEAMS (AvailabilityStatus);
CREATE INDEX idx_report_type_sev   ON EMERGENCY_REPORTS (DisasterType, SeverityLevel);
CREATE INDEX idx_report_status_loc ON EMERGENCY_REPORTS (Status, Location);
CREATE INDEX idx_fin_report_type   ON FINANCIAL_TRANSACTIONS (ReportID, TransactionType);
GO

-- ============================================================
--  SECTION 5: SAMPLE DATA (DML)
-- ============================================================

-- 5.1 Roles
INSERT INTO ROLES (RoleName, Description) VALUES
    ('Administrator',      'Full system access, user management'),
    ('Emergency Operator', 'Manages emergency reports and team dispatch'),
    ('Field Officer',      'Updates team status from the field'),
    ('Warehouse Manager',  'Manages resource inventory and allocations'),
    ('Finance Officer',    'Records donations, expenses, and procurement');

-- 5.2 Users
INSERT INTO USERS (Username, PasswordHash, FullName, Email, Phone) VALUES
    ('admin',    'admin123',  'Ali Ahmed',     'ali@disaster.gov.pk',    '0300-1111111'),
    ('sara',     'sara123',   'Sara Khan',     'sara@disaster.gov.pk',   '0301-2222222'),
    ('umar',     'umar123',   'Umar Farooq',   'umar@disaster.gov.pk',   '0302-3333333'),
    ('zainab',   'zainab123', 'Zainab Malik',  'zainab@disaster.gov.pk', '0303-4444444'),
    ('hassan',   'hassan123', 'Hassan Raza',   'hassan@disaster.gov.pk', '0304-5555555');

-- 5.3 User Roles
INSERT INTO USER_ROLES (UserID, RoleID) VALUES
    (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- 5.4 Emergency Reports
INSERT INTO EMERGENCY_REPORTS (ReportedByUserID, Location, DisasterType, SeverityLevel, Status) VALUES
    (2, 'Karachi, Sindh — Lyari River Basin',      'Flood',      'Critical', 'In-Progress'),
    (2, 'Peshawar, KPK — City Centre',             'Earthquake', 'High',     'Open'),
    (2, 'Lahore, Punjab — Gulberg Industrial Area','Fire',       'Medium',   'Resolved'),
    (2, 'Quetta, Balochistan — Satellite Town',    'Earthquake', 'High',     'Open'),
    (2, 'Rawalpindi, Punjab — Saddar',             'Flood',      'Low',      'Open');

-- 5.5 Rescue Teams
INSERT INTO RESCUE_TEAMS (TeamName, TeamType, CurrentLocation, AvailabilityStatus) VALUES
    ('Alpha Medical Unit',   'Medical', 'Karachi',   'Available'),
    ('Bravo Fire Brigade',   'Fire',    'Lahore',    'Available'),
    ('Charlie Rescue Corps', 'Rescue',  'Islamabad', 'Available'),
    ('Delta Medical Unit',   'Medical', 'Peshawar',  'Available'),
    ('Echo Fire Response',   'Fire',    'Quetta',    'Available');

-- 5.6 Team Assignments
INSERT INTO TEAM_ASSIGNMENTS (TeamID, ReportID, AssignmentStatus) VALUES
    (1, 1, 'Active'),
    (2, 3, 'Completed'),
    (5, 4, 'Active');

-- 5.7 Warehouses
INSERT INTO WAREHOUSES (WarehouseName, Location, ManagerUserID) VALUES
    ('Karachi Central Warehouse', 'Karachi, Sindh',    4),
    ('Lahore Relief Depot',       'Lahore, Punjab',    4),
    ('Islamabad Federal Store',   'Islamabad Capital', 4);

-- 5.8 Resources
INSERT INTO RESOURCES (WarehouseID, ResourceName, ResourceType, QuantityAvailable, ThresholdLevel, Unit) VALUES
    (1, 'Rice (50kg Bags)',       'Food',     480.00,  50.00,  'bags'),
    (1, 'Mineral Water (1L)',     'Water',    9500.00, 500.00, 'liters'),
    (1, 'Paracetamol Strips',     'Medicine', 185.00,  20.00,  'strips'),
    (1, 'Family Tent Sets',       'Shelter',  72.00,   10.00,  'units'),
    (2, 'Blankets (Fleece)',      'Shelter',  310.00,  30.00,  'units'),
    (2, 'Oral Rehydration Salts', 'Medicine', 400.00,  50.00,  'packets'),
    (3, 'Cooking Oil (5L)',       'Food',     120.00,  20.00,  'cans'),
    (3, 'First Aid Kits',         'Medicine', 8.00,    10.00,  'kits');

-- 5.9 Resource Allocations
INSERT INTO RESOURCE_ALLOCATIONS (ResourceID, ReportID, RequestedByUserID, QuantityRequested, QuantityDispatched, Status) VALUES
    (1, 1, 4, 50.00,  20.00, 'Dispatched'),
    (2, 1, 4, 500.00, 500.00,'Dispatched'),
    (4, 1, 4, 10.00,  10.00, 'Dispatched'),
    (5, 2, 4, 80.00,  0.00,  'Pending'),
    (7, 4, 4, 30.00,  0.00,  'Approved');

-- 5.10 Hospitals
INSERT INTO HOSPITALS (HospitalName, Location, TotalBeds, AvailableBeds, ContactPhone) VALUES
    ('Jinnah Postgraduate Medical Centre', 'Karachi, Sindh',    600, 95,  '021-99201300'),
    ('Shaukat Khanum Memorial Hospital',   'Lahore, Punjab',    400, 112, '042-35945100'),
    ('Pakistan Institute of Med Sciences', 'Islamabad Capital', 700, 230, '051-9261170'),
    ('Lady Reading Hospital',              'Peshawar, KPK',     500, 78,  '091-9211291');

-- 5.11 Patients
INSERT INTO PATIENTS (HospitalID, ReportID, PatientName, Age, CaseType, AdmittedAt) VALUES
    (1, 1, 'Mohammad Bilal',  34, 'Critical',  '2026-04-20 11:00:00'),
    (1, 1, 'Fatima Noor',     22, 'Emergency', '2026-04-20 11:45:00'),
    (1, 1, 'Ahmed Kareem',    58, 'Normal',    '2026-04-20 13:00:00'),
    (4, 2, 'Amina Rehman',    45, 'Critical',  '2026-04-21 09:30:00'),
    (4, 2, 'Tariq Mehmood',   67, 'Emergency', '2026-04-21 10:15:00');

-- 5.12 Financial Transactions
INSERT INTO FINANCIAL_TRANSACTIONS (ReportID, RecordedByUserID, TransactionType, Amount, Description) VALUES
    (1, 5, 'Donation',    750000.00, 'Donation from Edhi Foundation for Karachi flood relief'),
    (1, 5, 'Donation',    200000.00, 'Corporate donation from Atlas Honda Limited'),
    (1, 5, 'Expense',      85000.00, 'Fuel and transport cost for resource convoy to Karachi'),
    (1, 5, 'Procurement', 320000.00, 'Emergency medicine procurement for Karachi flood'),
    (2, 5, 'Expense',     120000.00, 'Search and rescue equipment for Peshawar earthquake'),
    (2, 5, 'Procurement', 180000.00, 'Blankets and shelter materials for Peshawar earthquake'),
    (4, 5, 'Expense',      45000.00, 'Field team deployment logistics for Quetta earthquake');

-- 5.13 Approval Requests
INSERT INTO APPROVAL_REQUESTS (RequestType, ReferenceID, RequestedByUserID, ApprovedByUserID, Status, ReviewedAt, Remarks) VALUES
    ('ResourceDistribution', 1, 4, 1, 'Approved', '2026-04-20 10:00:00', 'Approved — critical flood response'),
    ('ResourceDistribution', 2, 4, 1, 'Approved', '2026-04-20 10:05:00', 'Approved — water supply confirmed'),
    ('ResourceDistribution', 4, 4, NULL, 'Pending', NULL, NULL),
    ('RescueDeployment',     1, 2, 1, 'Approved', '2026-04-20 09:00:00', 'Alpha Medical deployed to Karachi'),
    ('FinancialApproval',    1, 5, 1, 'Approved', '2026-04-20 12:00:00', 'Donation recorded and verified');

-- 5.14 Audit Logs
INSERT INTO AUDIT_LOGS (UserID, ActionType, TableAffected, RecordID, OldValue, NewValue) VALUES
    (2, 'INSERT', 'EMERGENCY_REPORTS',     1, NULL, 'Karachi Flood Critical'),
    (4, 'INSERT', 'RESOURCE_ALLOCATIONS',  1, NULL, 'Rice 50 bags requested'),
    (1, 'UPDATE', 'APPROVAL_REQUESTS',     1, 'Pending', 'Approved'),
    (5, 'INSERT', 'FINANCIAL_TRANSACTIONS',1, NULL, 'Donation 750000');

-- ============================================================
--  SECTION 6: TRANSACTION DEMONSTRATIONS
-- ============================================================

-- -------------------------------------------------------
-- Demo 1: Resource Dispatch Workflow (ACID)
-- -------------------------------------------------------
PRINT '========================================';
PRINT 'Demo 1: Resource Dispatch Workflow';
PRINT '========================================';

BEGIN TRANSACTION;
    DECLARE @avail DECIMAL(10,2);
    DECLARE @requested DECIMAL(10,2);

    SELECT @avail = QuantityAvailable FROM RESOURCES WHERE ResourceID = 5;
    SELECT @requested = QuantityRequested FROM RESOURCE_ALLOCATIONS WHERE AllocationID = 4;

    PRINT 'Available: ' + CAST(@avail AS VARCHAR);
    PRINT 'Requested: ' + CAST(@requested AS VARCHAR);

    IF @avail < @requested
    BEGIN
        PRINT 'ERROR: Insufficient stock. Rolling back.';
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        UPDATE RESOURCE_ALLOCATIONS
        SET QuantityDispatched = @requested, Status = 'Dispatched'
        WHERE AllocationID = 4;

        UPDATE APPROVAL_REQUESTS
        SET Status = 'Approved', ReviewedAt = GETDATE(),
            Remarks = 'Approved and dispatched via transaction'
        WHERE RequestType = 'ResourceDistribution' AND ReferenceID = 4 AND Status = 'Pending';

        COMMIT TRANSACTION;
        PRINT 'Demo 1 completed — Resource dispatched successfully.';
    END
GO

-- -------------------------------------------------------
-- Demo 2: Team Assignment with Availability Check
-- -------------------------------------------------------
PRINT '========================================';
PRINT 'Demo 2: Rescue Team Assignment';
PRINT '========================================';

BEGIN TRANSACTION;
    DECLARE @teamStatus VARCHAR(20);

    SELECT @teamStatus = AvailabilityStatus
    FROM RESCUE_TEAMS WITH (UPDLOCK, HOLDLOCK)
    WHERE TeamID = 3;

    PRINT 'Team 3 Current Status: ' + @teamStatus;

    IF @teamStatus != 'Available'
    BEGIN
        PRINT 'ERROR: Team not available. Rolling back.';
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO TEAM_ASSIGNMENTS (TeamID, ReportID) VALUES (3, 2);
        COMMIT TRANSACTION;
        PRINT 'Demo 2 completed — Team 3 assigned to Report 2.';
    END
GO

-- -------------------------------------------------------
-- Demo 3: Financial Entry with Audit Trail
-- -------------------------------------------------------
PRINT '========================================';
PRINT 'Demo 3: Financial Entry with Audit';
PRINT '========================================';

BEGIN TRANSACTION;

    INSERT INTO FINANCIAL_TRANSACTIONS
        (ReportID, RecordedByUserID, TransactionType, Amount, Description)
    VALUES (1, 5, 'Expense', 62500.00, 'Medical supplies delivery — field team Karachi');

    INSERT INTO AUDIT_LOGS (UserID, ActionType, TableAffected, NewValue)
    VALUES (5, 'INSERT', 'FINANCIAL_TRANSACTIONS', 'Amount=62500, Type=Expense, Report=1');

COMMIT TRANSACTION;
PRINT 'Demo 3 completed — Financial entry with audit logged.';
GO

-- -------------------------------------------------------
-- Demo 4: Error Handling with TRY-CATCH
-- -------------------------------------------------------
PRINT '========================================';
PRINT 'Demo 4: Error Handling (TRY-CATCH)';
PRINT '========================================';

BEGIN TRY
    BEGIN TRANSACTION;

        -- This will trigger trg_prevent_neg_stock and fail
        UPDATE RESOURCE_ALLOCATIONS
        SET QuantityDispatched = 99999.00, Status = 'Dispatched'
        WHERE AllocationID = 4;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    PRINT 'ERROR: ' + ERROR_MESSAGE();
    PRINT 'Transaction rolled back successfully.';
    ROLLBACK TRANSACTION;
END CATCH
GO

-- -------------------------------------------------------
-- Demo 5: Team Assignment Completion
-- -------------------------------------------------------
PRINT '========================================';
PRINT 'Demo 5: Team Mission Completion';
PRINT '========================================';

BEGIN TRANSACTION;

    UPDATE TEAM_ASSIGNMENTS
    SET AssignmentStatus = 'Completed', CompletedAt = GETDATE()
    WHERE AssignmentID = 1;

    PRINT 'Assignment marked complete. Trigger will auto-set team to Available.';

COMMIT TRANSACTION;
PRINT 'Demo 5 completed.';
GO

-- ============================================================
--  SECTION 7: ANALYTICAL QUERIES (MIS Reports)
-- ============================================================

-- -------------------------------------------------------
-- 7.1 Open Incidents by Severity (Priority Queue)
-- -------------------------------------------------------
PRINT '========================================';
PRINT '7.1: Open Incidents by Severity';
PRINT '========================================';

SELECT ReportID, Location, DisasterType, SeverityLevel, ReportTime, Status
FROM EMERGENCY_REPORTS
WHERE Status IN ('Open', 'In-Progress')
ORDER BY
    CASE SeverityLevel
        WHEN 'Critical' THEN 1
        WHEN 'High'     THEN 2
        WHEN 'Medium'   THEN 3
        WHEN 'Low'      THEN 4
    END,
    ReportTime ASC;
GO

-- -------------------------------------------------------
-- 7.2 Resources Below Threshold (Low Stock Alert)
-- -------------------------------------------------------
PRINT '========================================';
PRINT '7.2: Resources Below Threshold';
PRINT '========================================';

SELECT ResourceID, ResourceName, ResourceType, QuantityAvailable, 
       ThresholdLevel, Unit, WarehouseName
FROM vw_ResourceStatus
WHERE LowStockFlag = 1
ORDER BY (QuantityAvailable / NULLIF(ThresholdLevel, 0)) ASC;
GO

-- -------------------------------------------------------
-- 7.3 Financial Summary per Incident
-- -------------------------------------------------------
PRINT '========================================';
PRINT '7.3: Financial Summary per Incident';
PRINT '========================================';

SELECT
    er.ReportID, er.Location, er.DisasterType, er.SeverityLevel,
    COALESCE(SUM(CASE WHEN ft.TransactionType = 'Donation'    THEN ft.Amount END), 0) AS TotalDonations,
    COALESCE(SUM(CASE WHEN ft.TransactionType = 'Expense'     THEN ft.Amount END), 0) AS TotalExpenses,
    COALESCE(SUM(CASE WHEN ft.TransactionType = 'Procurement' THEN ft.Amount END), 0) AS TotalProcurement,
    COALESCE(SUM(ft.Amount), 0) AS NetFinancialFlow
FROM EMERGENCY_REPORTS er
LEFT JOIN FINANCIAL_TRANSACTIONS ft ON er.ReportID = ft.ReportID
GROUP BY er.ReportID, er.Location, er.DisasterType, er.SeverityLevel
ORDER BY NetFinancialFlow DESC;
GO

-- -------------------------------------------------------
-- 7.4 Pending Approvals
-- -------------------------------------------------------
PRINT '========================================';
PRINT '7.4: Pending Approvals';
PRINT '========================================';

SELECT
    ar.ApprovalID, ar.RequestType, ar.ReferenceID,
    u.FullName AS RequestedBy, ar.RequestedAt,
    DATEDIFF(HOUR, ar.RequestedAt, GETDATE()) AS HoursPending
FROM APPROVAL_REQUESTS ar
JOIN USERS u ON ar.RequestedByUserID = u.UserID
WHERE ar.Status = 'Pending'
ORDER BY ar.RequestedAt ASC;
GO

-- -------------------------------------------------------
-- 7.5 Hospital Capacity Overview
-- -------------------------------------------------------
PRINT '========================================';
PRINT '7.5: Hospital Capacity';
PRINT '========================================';

SELECT
    HospitalID, HospitalName, Location, TotalBeds, AvailableBeds,
    (TotalBeds - AvailableBeds) AS OccupiedBeds,
    ROUND(CAST(AvailableBeds AS FLOAT) * 100.0 / NULLIF(TotalBeds, 0), 1) AS AvailabilityPct
FROM HOSPITALS
ORDER BY AvailabilityPct ASC;
GO

-- -------------------------------------------------------
-- 7.6 Response Time Analysis
-- -------------------------------------------------------
PRINT '========================================';
PRINT '7.6: Response Time Analysis';
PRINT '========================================';

SELECT
    er.ReportID, er.Location, er.DisasterType, er.SeverityLevel,
    er.ReportTime,
    MIN(ta.AssignedAt) AS FirstAssignmentTime,
    DATEDIFF(MINUTE, er.ReportTime, MIN(ta.AssignedAt)) AS ResponseTimeMinutes
FROM EMERGENCY_REPORTS er
LEFT JOIN TEAM_ASSIGNMENTS ta ON er.ReportID = ta.ReportID
GROUP BY er.ReportID, er.Location, er.DisasterType, er.SeverityLevel, er.ReportTime
ORDER BY ResponseTimeMinutes DESC;
GO

-- -------------------------------------------------------
-- 7.7 Resource Utilization Report
-- -------------------------------------------------------
PRINT '========================================';
PRINT '7.7: Resource Utilization';
PRINT '========================================';

SELECT
    r.ResourceName, r.ResourceType,
    SUM(ra.QuantityRequested) AS TotalRequested,
    SUM(ra.QuantityDispatched) AS TotalDispatched,
    CASE 
        WHEN SUM(ra.QuantityRequested) > 0 
        THEN ROUND(SUM(ra.QuantityDispatched) * 100.0 / SUM(ra.QuantityRequested), 1)
        ELSE 0 
    END AS FulfillmentPct
FROM RESOURCES r
JOIN RESOURCE_ALLOCATIONS ra ON r.ResourceID = ra.ResourceID
GROUP BY r.ResourceName, r.ResourceType
ORDER BY FulfillmentPct ASC;
GO

-- -------------------------------------------------------
-- 7.8 Complete Audit Trail
-- -------------------------------------------------------
PRINT '========================================';
PRINT '7.8: Full Audit Trail';
PRINT '========================================';

SELECT
    al.LogID, u.FullName AS UserName, al.ActionType,
    al.TableAffected, al.RecordID, al.OldValue, al.NewValue, al.Timestamp
FROM AUDIT_LOGS al
LEFT JOIN USERS u ON al.UserID = u.UserID
ORDER BY al.Timestamp DESC;
GO

-- ============================================================
--  FINAL MESSAGE
-- ============================================================
PRINT '========================================';
PRINT ' DATABASE SETUP COMPLETE!';
PRINT ' Database: disaster_mis';
PRINT ' 15 Tables created';
PRINT ' 6 Triggers active';
PRINT ' 4 Views ready';
PRINT ' 13 Indexes optimized';
PRINT ' Sample data loaded';
PRINT ' 5 Transaction demos completed';
PRINT ' 8 Analytical queries ready';
PRINT '========================================';
PRINT ' Ready for ASP.NET Web Forms connection!';
PRINT '========================================';
GO