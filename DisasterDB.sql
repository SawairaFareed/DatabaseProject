use master;
go
drop database disasterDB;
go
create database disasterDB;
go
use disasterDB;
go

create table ROLES (
RoleID int not null identity(1,1),
RoleName varchar(50) not null,
Description varchar(255) null,
constraint pk_roles primary key (RoleID),
constraint uq_roles_name unique (RoleName)
);
go

create table USERS (
UserID int not null identity(1,1),
Username varchar(50) not null,
PasswordHash varchar(255) not null,
FullName varchar(100) not null,
Email varchar(100) null,
Phone varchar(20) null,
IsActive bit not null default 1,
CreatedAt datetime2 not null default getdate(),
constraint pk_users primary key (UserID),
constraint uq_users_username unique (Username),
constraint uq_users_email unique (Email)
);
go

create table USER_ROLES (
UserID int not null,
RoleID int not null,
AssignedAt datetime2 not null default getdate(),
constraint pk_user_roles primary key (UserID, RoleID),
constraint fk_ur_user foreign key (UserID) references USERS(UserID)
on delete cascade on update cascade,
constraint fk_ur_role foreign key (RoleID) references ROLES(RoleID)
on delete cascade on update cascade
);
go

create table EMERGENCY_REPORTS (
ReportID int not null identity(1,1),
ReportedByUserID int null,
Location varchar(255) not null,
DisasterType varchar(20) not null,
SeverityLevel varchar(20) not null,
ReportTime datetime2 not null default getdate(),
Status varchar(20) not null default 'Open',
constraint pk_emergency_reports primary key (ReportID),
constraint chk_disaster_type check (DisasterType in ('Flood','Earthquake','Fire','Other')),
constraint chk_severity_level check (SeverityLevel in ('Low','Medium','High','Critical')),
constraint chk_report_status check (Status in ('Open','In-Progress','Resolved','Closed')),
constraint fk_er_user foreign key (ReportedByUserID)
references USERS(UserID) on delete set null on update cascade
);
go

create table RESCUE_TEAMS (
TeamID int not null identity(1,1),
TeamName varchar(100) not null,
TeamType varchar(20) not null,
CurrentLocation varchar(200) null,
AvailabilityStatus varchar(20) not null default 'Available',
constraint pk_rescue_teams primary key (TeamID),
constraint chk_team_type check (TeamType in ('Medical','Fire','Rescue')),
constraint chk_team_status check (AvailabilityStatus in ('Available','Assigned','Busy','Completed'))
);
go

create table TEAM_ASSIGNMENTS (
AssignmentID int not null identity(1,1),
TeamID int not null,
ReportID int not null,
AssignedAt datetime2 not null default getdate(),
CompletedAt datetime2 null,
AssignmentStatus varchar(20) not null default 'Active',
constraint pk_team_assignments primary key (AssignmentID),
constraint chk_assignment_status check (AssignmentStatus in ('Active','Completed','Cancelled')),
constraint fk_ta_team foreign key (TeamID)
references RESCUE_TEAMS(TeamID) on delete no action on update no action,
constraint fk_ta_report foreign key (ReportID)
references EMERGENCY_REPORTS(ReportID) on delete no action on update no action
);
go

create table WAREHOUSES (
WarehouseID int not null identity(1,1),
WarehouseName varchar(100) not null,
Location varchar(200) null,
ManagerUserID int null,
constraint pk_warehouses primary key (WarehouseID),
constraint fk_wh_manager foreign key (ManagerUserID)
references USERS(UserID) on delete set null on update no action
);
go

create table RESOURCES (
ResourceID int not null identity(1,1),
WarehouseID int not null,
ResourceName varchar(100) not null,
ResourceType varchar(20) not null,
QuantityAvailable decimal(10,2) not null default 0.00,
ThresholdLevel decimal(10,2) not null default 10.00,
Unit varchar(30) null,
constraint pk_resources primary key (ResourceID),
constraint chk_resource_type check (ResourceType in ('Food','Water','Medicine','Shelter')),
constraint chk_qty_nonneg check (QuantityAvailable >= 0),
constraint fk_res_warehouse foreign key (WarehouseID)
references WAREHOUSES(WarehouseID) on delete no action on update no action
);
go

create table RESOURCE_ALLOCATIONS (
AllocationID int not null identity(1,1),
ResourceID int not null,
ReportID int not null,
RequestedByUserID int null,
QuantityRequested decimal(10,2) not null,
QuantityDispatched decimal(10,2) not null default 0.00,
RequestedAt datetime2 not null default getdate(),
Status varchar(20) not null default 'Pending',
constraint pk_resource_allocations primary key (AllocationID),
constraint chk_alloc_status check (Status in ('Pending','Approved','Dispatched','Cancelled')),
constraint fk_ra_resource foreign key (ResourceID)
references RESOURCES(ResourceID) on delete no action on update no action,
constraint fk_ra_report foreign key (ReportID)
references EMERGENCY_REPORTS(ReportID) on delete no action on update no action,
constraint fk_ra_user foreign key (RequestedByUserID)
references USERS(UserID) on delete set null on update no action
);
go

create table HOSPITALS (
HospitalID int not null identity(1,1),
HospitalName varchar(150) not null,
Location varchar(200) null,
TotalBeds int not null default 0,
AvailableBeds int not null default 0,
ContactPhone varchar(20) null,
constraint pk_hospitals primary key (HospitalID),
constraint chk_beds_nonneg check (AvailableBeds >= 0),
constraint chk_avail_lte_total check (AvailableBeds <= TotalBeds)
);
go

create table PATIENTS (
PatientID int not null identity(1,1),
HospitalID int not null,
ReportID int null,
PatientName varchar(100) not null,
Age int null,
CaseType varchar(20) not null default 'Normal',
AdmittedAt datetime2 not null default getdate(),
DischargedAt datetime2 null,
constraint pk_patients primary key (PatientID),
constraint chk_case_type check (CaseType in ('Normal','Critical','Emergency')),
constraint fk_pat_hospital foreign key (HospitalID)
references HOSPITALS(HospitalID) on delete no action on update no action,
constraint fk_pat_report foreign key (ReportID)
references EMERGENCY_REPORTS(ReportID) on delete set null on update no action
);
go

create table FINANCIAL_TRANSACTIONS (
TransactionID int not null identity(1,1),
ReportID int null,
RecordedByUserID int null,
TransactionType varchar(20) not null,
Amount decimal(15,2) not null,
TransactionDate datetime2 not null default getdate(),
Description varchar(300) null,
constraint pk_financial_transactions primary key (TransactionID),
constraint chk_txn_type check (TransactionType in ('Donation','Expense','Procurement')),
constraint chk_amount_pos check (Amount > 0),
constraint fk_fin_report foreign key (ReportID)
references EMERGENCY_REPORTS(ReportID) on delete set null on update no action,
constraint fk_fin_user foreign key (RecordedByUserID)
references USERS(UserID) on delete no action on update no action
);
go

create table APPROVAL_REQUESTS (
ApprovalID int not null identity(1,1),
RequestType varchar(30) not null,
ReferenceID int not null,
RequestedByUserID int null,
ApprovedByUserID int null,
Status varchar(20) not null default 'Pending',
RequestedAt datetime2 not null default getdate(),
ReviewedAt datetime2 null,
Remarks varchar(300) null,
constraint pk_approval_requests primary key (ApprovalID),
constraint chk_request_type check (RequestType in ('ResourceDistribution','RescueDeployment','FinancialApproval')),
constraint chk_apr_status check (Status in ('Pending','Approved','Rejected')),
constraint fk_apr_requester foreign key (RequestedByUserID)
references USERS(UserID) on delete set null on update no action,
constraint fk_apr_approver foreign key (ApprovedByUserID)
references USERS(UserID) on delete no action on update no action
);
go

create table AUDIT_LOGS (
LogID int not null identity(1,1),
UserID int null,
ActionType varchar(10) not null,
TableAffected varchar(50) null,
RecordID int null,
OldValue varchar(max) null,
NewValue varchar(max) null,
Timestamp datetime2 not null default getdate(),
constraint pk_audit_logs primary key (LogID),
constraint chk_action_type check (ActionType in ('INSERT','UPDATE','DELETE','LOGIN','LOGOUT')),
constraint fk_aud_user foreign key (UserID)
references USERS(UserID) on delete set null on update no action
);
go

create table TRANSACTION_AUDIT (
AuditID int not null identity(1,1),
TransactionID int not null,
Operation varchar(10) not null,
OldAmount decimal(15,2) null,
NewAmount decimal(15,2) null,
ChangedAt datetime2 not null default getdate(),
constraint pk_transaction_audit primary key (AuditID),
constraint chk_audit_op check (Operation in ('INSERT','UPDATE','DELETE')),
constraint fk_ta_transaction foreign key (TransactionID)
references FINANCIAL_TRANSACTIONS(TransactionID) on delete cascade on update no action
);
go

create or alter trigger trg_update_stock
on RESOURCE_ALLOCATIONS
after update
as
begin
set nocount on;
if exists (
select 1 from inserted i
inner join deleted d on i.AllocationID = d.AllocationID
where i.Status = 'Dispatched' and d.Status != 'Dispatched'
)
begin
update r
set QuantityAvailable = r.QuantityAvailable - i.QuantityDispatched
from RESOURCES r
inner join inserted i on r.ResourceID = i.ResourceID
inner join deleted d on i.AllocationID = d.AllocationID
where i.Status = 'Dispatched' and d.Status != 'Dispatched';
end
end
go

create or alter trigger trg_prevent_neg_stock
on RESOURCES
after update
as
begin
set nocount on;
if exists (select 1 from inserted where QuantityAvailable < 0)
begin
throw 50000, 'ERROR: Insufficient stock — QuantityAvailable cannot be negative.', 1;
rollback transaction;
end
end
go

create or alter trigger trg_team_status_assign
on TEAM_ASSIGNMENTS
after insert
as
begin
set nocount on;
update rt
set AvailabilityStatus = 'Assigned'
from RESCUE_TEAMS rt
inner join inserted i on rt.TeamID = i.TeamID
where i.AssignmentStatus = 'Active';
end
go

create or alter trigger trg_team_status_complete
on TEAM_ASSIGNMENTS
after update
as
begin
set nocount on;
if exists (
select 1 from inserted i
inner join deleted d on i.AssignmentID = d.AssignmentID
where i.AssignmentStatus = 'Completed' and d.AssignmentStatus != 'Completed'
)
begin
update rt
set AvailabilityStatus = 'Available'
from RESCUE_TEAMS rt
inner join inserted i on rt.TeamID = i.TeamID;
end
end
go

create or alter trigger trg_financial_audit_insert
on FINANCIAL_TRANSACTIONS
after insert
as
begin
set nocount on;
insert into TRANSACTION_AUDIT (TransactionID, Operation, OldAmount, NewAmount)
select TransactionID, 'INSERT', null, Amount from inserted;
end
go

create or alter trigger trg_financial_audit_update
on FINANCIAL_TRANSACTIONS
after update
as
begin
set nocount on;
if update(Amount)
begin
insert into TRANSACTION_AUDIT (TransactionID, Operation, OldAmount, NewAmount)
select i.TransactionID, 'UPDATE', d.Amount, i.Amount
from inserted i
inner join deleted d on i.TransactionID = d.TransactionID
where i.Amount != d.Amount;
end
end
go

create or alter view vw_IncidentDashboard as
select
er.ReportID,
er.Location,
er.DisasterType,
er.SeverityLevel,
er.ReportTime,
er.Status as IncidentStatus,
u.FullName as ReportedBy,
count(distinct ta.AssignmentID) as TeamsAssigned,
coalesce(sum(ra.QuantityDispatched), 0) as TotalResourcesDispatched
from EMERGENCY_REPORTS er
left join USERS u on er.ReportedByUserID = u.UserID
left join TEAM_ASSIGNMENTS ta on er.ReportID = ta.ReportID
left join RESOURCE_ALLOCATIONS ra on er.ReportID = ra.ReportID
group by er.ReportID, er.Location, er.DisasterType, er.SeverityLevel, er.ReportTime, er.Status, u.FullName;
go

create or alter view vw_FinanceOfficerView as
select
ft.TransactionID,
ft.ReportID,
er.Location as IncidentLocation,
er.DisasterType,
ft.TransactionType,
ft.Amount,
ft.TransactionDate,
ft.Description,
u.FullName as RecordedBy
from FINANCIAL_TRANSACTIONS ft
left join EMERGENCY_REPORTS er on ft.ReportID = er.ReportID
left join USERS u on ft.RecordedByUserID = u.UserID;
go

create or alter view vw_ResourceStatus as
select
r.ResourceID,
r.ResourceName,
r.ResourceType,
r.QuantityAvailable,
r.ThresholdLevel,
r.Unit,
w.WarehouseName,
w.Location as WarehouseLocation,
case when r.QuantityAvailable < r.ThresholdLevel then 1 else 0 end as LowStockFlag
from RESOURCES r
join WAREHOUSES w on r.WarehouseID = w.WarehouseID;
go

create or alter view vw_FieldOfficerAssignments as
select
ta.AssignmentID,
rt.TeamName,
rt.TeamType,
rt.CurrentLocation as TeamLocation,
ta.ReportID,
er.Location as IncidentLocation,
er.DisasterType,
er.SeverityLevel,
ta.AssignedAt,
ta.AssignmentStatus
from TEAM_ASSIGNMENTS ta
join RESCUE_TEAMS rt on ta.TeamID = rt.TeamID
join EMERGENCY_REPORTS er on ta.ReportID = er.ReportID
where ta.AssignmentStatus = 'Active';
go

create index idx_report_location on EMERGENCY_REPORTS (Location);
create index idx_report_type on EMERGENCY_REPORTS (DisasterType);
create index idx_report_status on EMERGENCY_REPORTS (Status);
create index idx_resource_type on RESOURCES (ResourceType);
create index idx_fin_date on FINANCIAL_TRANSACTIONS (TransactionDate);
create index idx_fin_type on FINANCIAL_TRANSACTIONS (TransactionType);
create index idx_audit_user on AUDIT_LOGS (UserID);
create index idx_audit_timestamp on AUDIT_LOGS (Timestamp);
create index idx_alloc_status on RESOURCE_ALLOCATIONS (Status);
create index idx_team_status on RESCUE_TEAMS (AvailabilityStatus);
create index idx_report_type_sev on EMERGENCY_REPORTS (DisasterType, SeverityLevel);
create index idx_report_status_loc on EMERGENCY_REPORTS (Status, Location);
create index idx_fin_report_type on FINANCIAL_TRANSACTIONS (ReportID, TransactionType);
go

insert into ROLES (RoleName, Description) values
('Administrator', 'Full system access, user management'),
('Emergency Operator', 'Manages emergency reports and team dispatch'),
('Field Officer', 'Updates team status from the field'),
('Warehouse Manager', 'Manages resource inventory and allocations'),
('Finance Officer', 'Records donations, expenses, and procurement');

insert into USERS (Username, PasswordHash, FullName, Email, Phone) values
('admin', 'admin123', 'Ali Ahmed', 'ali@disaster.gov.pk', '0300-1111111'),
('sara', 'sara123', 'Sara Khan', 'sara@disaster.gov.pk', '0301-2222222'),
('umar', 'umar123', 'Umar Farooq', 'umar@disaster.gov.pk', '0302-3333333'),
('zainab', 'zainab123', 'Zainab Malik', 'zainab@disaster.gov.pk', '0303-4444444'),
('hassan', 'hassan123', 'Hassan Raza', 'hassan@disaster.gov.pk', '0304-5555555');

insert into USER_ROLES (UserID, RoleID) values
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

insert into EMERGENCY_REPORTS (ReportedByUserID, Location, DisasterType, SeverityLevel, Status) values
(2, 'Karachi, Sindh — Lyari River Basin', 'Flood', 'Critical', 'In-Progress'),
(2, 'Peshawar, KPK — City Centre', 'Earthquake', 'High', 'Open'),
(2, 'Lahore, Punjab — Gulberg Industrial Area','Fire', 'Medium', 'Resolved'),
(2, 'Quetta, Balochistan — Satellite Town', 'Earthquake', 'High', 'Open'),
(2, 'Rawalpindi, Punjab — Saddar', 'Flood', 'Low', 'Open');

insert into RESCUE_TEAMS (TeamName, TeamType, CurrentLocation, AvailabilityStatus) values
('Alpha Medical Unit', 'Medical', 'Karachi', 'Available'),
('Bravo Fire Brigade', 'Fire', 'Lahore', 'Available'),
('Charlie Rescue Corps', 'Rescue', 'Islamabad', 'Available'),
('Delta Medical Unit', 'Medical', 'Peshawar', 'Available'),
('Echo Fire Response', 'Fire', 'Quetta', 'Available');

insert into TEAM_ASSIGNMENTS (TeamID, ReportID, AssignmentStatus) values
(1, 1, 'Active'),
(2, 3, 'Completed'),
(5, 4, 'Active');

insert into WAREHOUSES (WarehouseName, Location, ManagerUserID) values
('Karachi Central Warehouse', 'Karachi, Sindh', 4),
('Lahore Relief Depot', 'Lahore, Punjab', 4),
('Islamabad Federal Store', 'Islamabad Capital', 4);

insert into RESOURCES (WarehouseID, ResourceName, ResourceType, QuantityAvailable, ThresholdLevel, Unit) values
(1, 'Rice (50kg Bags)', 'Food', 480.00, 50.00, 'bags'),
(1, 'Mineral Water (1L)', 'Water', 9500.00, 500.00, 'liters'),
(1, 'Paracetamol Strips', 'Medicine', 185.00, 20.00, 'strips'),
(1, 'Family Tent Sets', 'Shelter', 72.00, 10.00, 'units'),
(2, 'Blankets (Fleece)', 'Shelter', 310.00, 30.00, 'units'),
(2, 'Oral Rehydration Salts', 'Medicine', 400.00, 50.00, 'packets'),
(3, 'Cooking Oil (5L)', 'Food', 120.00, 20.00, 'cans'),
(3, 'First Aid Kits', 'Medicine', 8.00, 10.00, 'kits');

insert into RESOURCE_ALLOCATIONS (ResourceID, ReportID, RequestedByUserID, QuantityRequested, QuantityDispatched, Status) values
(1, 1, 4, 50.00, 20.00, 'Dispatched'),
(2, 1, 4, 500.00, 500.00,'Dispatched'),
(4, 1, 4, 10.00, 10.00, 'Dispatched'),
(5, 2, 4, 80.00, 0.00, 'Pending'),
(7, 4, 4, 30.00, 0.00, 'Approved');

insert into HOSPITALS (HospitalName, Location, TotalBeds, AvailableBeds, ContactPhone) values
('Jinnah Postgraduate Medical Centre', 'Karachi, Sindh', 600, 95, '021-99201300'),
('Shaukat Khanum Memorial Hospital', 'Lahore, Punjab', 400, 112, '042-35945100'),
('Pakistan Institute of Med Sciences', 'Islamabad Capital', 700, 230, '051-9261170'),
('Lady Reading Hospital', 'Peshawar, KPK', 500, 78, '091-9211291');

insert into PATIENTS (HospitalID, ReportID, PatientName, Age, CaseType, AdmittedAt) values
(1, 1, 'Mohammad Bilal', 34, 'Critical', '2026-04-20 11:00:00'),
(1, 1, 'Fatima Noor', 22, 'Emergency', '2026-04-20 11:45:00'),
(1, 1, 'Ahmed Kareem', 58, 'Normal', '2026-04-20 13:00:00'),
(4, 2, 'Amina Rehman', 45, 'Critical', '2026-04-21 09:30:00'),
(4, 2, 'Tariq Mehmood', 67, 'Emergency', '2026-04-21 10:15:00');

insert into FINANCIAL_TRANSACTIONS (ReportID, RecordedByUserID, TransactionType, Amount, Description) values
(1, 5, 'Donation', 750000.00, 'Donation from Edhi Foundation for Karachi flood relief'),
(1, 5, 'Donation', 200000.00, 'Corporate donation from Atlas Honda Limited'),
(1, 5, 'Expense', 85000.00, 'Fuel and transport cost for resource convoy to Karachi'),
(1, 5, 'Procurement', 320000.00, 'Emergency medicine procurement for Karachi flood'),
(2, 5, 'Expense', 120000.00, 'Search and rescue equipment for Peshawar earthquake'),
(2, 5, 'Procurement', 180000.00, 'Blankets and shelter materials for Peshawar earthquake'),
(4, 5, 'Expense', 45000.00, 'Field team deployment logistics for Quetta earthquake');

insert into APPROVAL_REQUESTS (RequestType, ReferenceID, RequestedByUserID, ApprovedByUserID, Status, ReviewedAt, Remarks) values
('ResourceDistribution', 1, 4, 1, 'Approved', '2026-04-20 10:00:00', 'Approved — critical flood response'),
('ResourceDistribution', 2, 4, 1, 'Approved', '2026-04-20 10:05:00', 'Approved — water supply confirmed'),
('ResourceDistribution', 4, 4, null, 'Pending', null, null),
('RescueDeployment', 1, 2, 1, 'Approved', '2026-04-20 09:00:00', 'Alpha Medical deployed to Karachi'),
('FinancialApproval', 1, 5, 1, 'Approved', '2026-04-20 12:00:00', 'Donation recorded and verified');

insert into AUDIT_LOGS (UserID, ActionType, TableAffected, RecordID, OldValue, NewValue) values
(2, 'INSERT', 'EMERGENCY_REPORTS', 1, null, 'Karachi Flood Critical'),
(4, 'INSERT', 'RESOURCE_ALLOCATIONS', 1, null, 'Rice 50 bags requested'),
(1, 'UPDATE', 'APPROVAL_REQUESTS', 1, 'Pending', 'Approved'),
(5, 'INSERT', 'FINANCIAL_TRANSACTIONS',1, null, 'Donation 750000');

print '========================================';
print 'Demo 1: Resource Dispatch Workflow';
print '========================================';

begin transaction;
declare @avail decimal(10,2);
declare @requested decimal(10,2);

select @avail = QuantityAvailable from RESOURCES where ResourceID = 5;
select @requested = QuantityRequested from RESOURCE_ALLOCATIONS where AllocationID = 4;

print 'Available: ' + cast(@avail as varchar);
print 'Requested: ' + cast(@requested as varchar);

if @avail < @requested
begin
print 'ERROR: Insufficient stock. Rolling back.';
rollback transaction;
end
else
begin
update RESOURCE_ALLOCATIONS
set QuantityDispatched = @requested, Status = 'Dispatched'
where AllocationID = 4;

update APPROVAL_REQUESTS
set Status = 'Approved', ReviewedAt = getdate(),
Remarks = 'Approved and dispatched via transaction'
where RequestType = 'ResourceDistribution' and ReferenceID = 4 and Status = 'Pending';

commit transaction;
print 'Demo 1 completed — Resource dispatched successfully.';
end
go

print '========================================';
print 'Demo 2: Rescue Team Assignment';
print '========================================';

begin transaction;
declare @teamStatus varchar(20);

select @teamStatus = AvailabilityStatus
from RESCUE_TEAMS with (updlock, holdlock)
where TeamID = 3;

print 'Team 3 Current Status: ' + @teamStatus;

if @teamStatus != 'Available'
begin
print 'ERROR: Team not available. Rolling back.';
rollback transaction;
end
else
begin
insert into TEAM_ASSIGNMENTS (TeamID, ReportID) values (3, 2);
commit transaction;
print 'Demo 2 completed — Team 3 assigned to Report 2.';
end
go

print '========================================';
print 'Demo 3: Financial Entry with Audit';
print '========================================';

begin transaction;

insert into FINANCIAL_TRANSACTIONS
(ReportID, RecordedByUserID, TransactionType, Amount, Description)
values (1, 5, 'Expense', 62500.00, 'Medical supplies delivery — field team Karachi');

insert into AUDIT_LOGS (UserID, ActionType, TableAffected, NewValue)
values (5, 'INSERT', 'FINANCIAL_TRANSACTIONS', 'Amount=62500, Type=Expense, Report=1');

commit transaction;
print 'Demo 3 completed — Financial entry with audit logged.';
go

print '========================================';
print 'Demo 4: Error Handling (TRY-CATCH)';
print '========================================';

begin try
begin transaction;

update RESOURCE_ALLOCATIONS
set QuantityDispatched = 99999.00, Status = 'Dispatched'
where AllocationID = 4;

commit transaction;
end try
begin catch
print 'ERROR: ' + error_message();
print 'Transaction rolled back successfully.';
rollback transaction;
end catch
go

print '========================================';
print 'Demo 5: Team Mission Completion';
print '========================================';

begin transaction;

update TEAM_ASSIGNMENTS
set AssignmentStatus = 'Completed', CompletedAt = getdate()
where AssignmentID = 1;

print 'Assignment marked complete. Trigger will auto-set team to Available.';

commit transaction;
print 'Demo 5 completed.';
go

print '========================================';
print '7.1: Open Incidents by Severity';
print '========================================';

select ReportID, Location, DisasterType, SeverityLevel, ReportTime, Status
from EMERGENCY_REPORTS
where Status in ('Open', 'In-Progress')
order by
case SeverityLevel
when 'Critical' then 1
when 'High' then 2
when 'Medium' then 3
when 'Low' then 4
end,
ReportTime asc;
go

print '========================================';
print '7.2: Resources Below Threshold';
print '========================================';

select ResourceID, ResourceName, ResourceType, QuantityAvailable,
ThresholdLevel, Unit, WarehouseName
from vw_ResourceStatus
where LowStockFlag = 1
order by (QuantityAvailable / nullif(ThresholdLevel, 0)) asc;
go

print '========================================';
print '7.3: Financial Summary per Incident';
print '========================================';

select
er.ReportID, er.Location, er.DisasterType, er.SeverityLevel,
coalesce(sum(case when ft.TransactionType = 'Donation' then ft.Amount end), 0) as TotalDonations,
coalesce(sum(case when ft.TransactionType = 'Expense' then ft.Amount end), 0) as TotalExpenses,
coalesce(sum(case when ft.TransactionType = 'Procurement' then ft.Amount end), 0) as TotalProcurement,
coalesce(sum(ft.Amount), 0) as NetFinancialFlow
from EMERGENCY_REPORTS er
left join FINANCIAL_TRANSACTIONS ft on er.ReportID = ft.ReportID
group by er.ReportID, er.Location, er.DisasterType, er.SeverityLevel
order by NetFinancialFlow desc;
go

print '========================================';
print '7.4: Pending Approvals';
print '========================================';

select
ar.ApprovalID, ar.RequestType, ar.ReferenceID,
u.FullName as RequestedBy, ar.RequestedAt,
datediff(hour, ar.RequestedAt, getdate()) as HoursPending
from APPROVAL_REQUESTS ar
join USERS u on ar.RequestedByUserID = u.UserID
where ar.Status = 'Pending'
order by ar.RequestedAt asc;
go

print '========================================';
print '7.5: Hospital Capacity';
print '========================================';

select
HospitalID, HospitalName, Location, TotalBeds, AvailableBeds,
(TotalBeds - AvailableBeds) as OccupiedBeds,
round(cast(AvailableBeds as float) * 100.0 / nullif(TotalBeds, 0), 1) as AvailabilityPct
from HOSPITALS
order by AvailabilityPct asc;
go

print '========================================';
print '7.6: Response Time Analysis';
print '========================================';

select
er.ReportID, er.Location, er.DisasterType, er.SeverityLevel,
er.ReportTime,
min(ta.AssignedAt) as FirstAssignmentTime,
datediff(minute, er.ReportTime, min(ta.AssignedAt)) as ResponseTimeMinutes
from EMERGENCY_REPORTS er
left join TEAM_ASSIGNMENTS ta on er.ReportID = ta.ReportID
group by er.ReportID, er.Location, er.DisasterType, er.SeverityLevel, er.ReportTime
order by ResponseTimeMinutes desc;
go

print '========================================';
print '7.7: Resource Utilization';
print '========================================';

select
r.ResourceName, r.ResourceType,
sum(ra.QuantityRequested) as TotalRequested,
sum(ra.QuantityDispatched) as TotalDispatched,
case
when sum(ra.QuantityRequested) > 0
then round(sum(ra.QuantityDispatched) * 100.0 / sum(ra.QuantityRequested), 1)
else 0
end as FulfillmentPct
from RESOURCES r
join RESOURCE_ALLOCATIONS ra on r.ResourceID = ra.ResourceID
group by r.ResourceName, r.ResourceType
order by FulfillmentPct asc;
go

print '========================================';
print '7.8: Full Audit Trail';
print '========================================';

select
al.LogID, u.FullName as UserName, al.ActionType,
al.TableAffected, al.RecordID, al.OldValue, al.NewValue, al.Timestamp
from AUDIT_LOGS al
left join USERS u on al.UserID = u.UserID
order by al.Timestamp desc;
go

print '========================================';
print ' DATABASE SETUP COMPLETE!';
print ' Database: disaster_mis';
print ' 15 Tables created';
print ' 6 Triggers active';
print ' 4 Views ready';
print ' 13 Indexes optimized';
print ' Sample data loaded';
print ' 5 Transaction demos completed';
print ' 8 Analytical queries ready';
print '========================================';
print ' Ready for ASP.NET Web Forms connection!';
print '========================================';


goinsert into APPROVAL_REQUESTS (RequestType, ReferenceID, RequestedByUserID, Status)
values ('ResourceDistribution', 1, 4, 'Pending');

select * from APPROVAL_REQUESTS where Status = 'Pending';