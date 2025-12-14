USE service_desk;

-- TEAMS ==================================
INSERT INTO Teams (team_name, specialization)
VALUES
('Network Support', 'Network'),
('Hardware Support', 'Hardware'),
('Application Support', 'Software'),
('Access Management', 'Access'),
('DevOps Support', 'DevOps');

-- USERS ==================================
INSERT INTO Users (name, email, role, team_id)
VALUES
('Amit Sharma', 'amit@company.com', 'agent', 1),
('Priya Nair', 'priya@company.com', 'agent', 2),
('Rahul Menon', 'rahul@company.com', 'agent', 3),
('Sneha Rao', 'sneha@company.com', 'agent', 4),
('Admin User', 'admin@company.com', 'admin', NULL),

-- customers (employees who create tickets)
('John Mathew', 'john@company.com', 'customer', NULL),
('Riya Joseph', 'riya@company.com', 'customer', NULL);

-- SLA_POLICIES ==================================
INSERT INTO SLA_Policies (category, priority, allowed_resolution_time)
VALUES
('Network', 'Low', 24),
('Network', 'Medium', 12),
('Network', 'High', 4),
('Network', 'Critical', 2),

('Hardware', 'Low', 48),
('Hardware', 'Medium', 24),
('Hardware', 'High', 6),

('Software', 'Low', 48),
('Software', 'Medium', 24),
('Software', 'High', 8),
('Software', 'Critical', 4),

('Access', 'Low', 72),
('Access', 'Medium', 48),
('Access', 'High', 24),
('Access', 'Critical', 8);


-- TICKETS ========================================
INSERT INTO Tickets (title, description, category, priority, user_id, status)
VALUES
('VPN not connecting', 'Unable to connect to VPN from home network', 'Network', 'High', 6, 'New'),
('Laptop not booting', 'Laptop stuck on boot screen', 'Hardware', 'High', 7, 'New'),
('Email not syncing', 'Outlook not receiving emails', 'Software', 'Medium', 6, 'New'),
('Access to HR portal', 'Requesting access to HR payroll portal', 'Access', 'Low', 7, 'New'),
('DevOps pipeline error', 'Jenkins job failing on deployment stage', 'DevOps', 'Critical', 6, 'New');

-- TICKET_COMMENTS ===========================================================
INSERT INTO Ticket_Comments (ticket_id, user_id, comment_text)
VALUES
(1, 1, 'Checked VPN logs. Investigating.'),
(2, 2, 'Requesting hardware diagnostic.'),
(3, 3, 'Possible mailbox corruption. Will repair.');

-- TICKET_HISTORY ======================================================================================
INSERT INTO Ticket_History (ticket_id, old_status, new_status, changed_by)
VALUES
(1, 'New', 'In Progress', 1),
(2, 'New', 'In Progress', 2),
(3, 'New', 'Pending', 3);

