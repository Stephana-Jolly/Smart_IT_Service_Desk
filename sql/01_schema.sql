-- 1. CREATE DATABASE ===============================
CREATE DATABASE IF NOT EXISTS service_desk;
USE service_desk;

-- 2. TEAMS TABLE ===============================
CREATE TABLE Teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100)
);

-- 3. USERS TABLE ===============================
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('agent', 'admin', 'customer') NOT NULL,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- 4. SLA POLICIES TABLE ===============================
CREATE TABLE SLA_Policies (
    sla_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    allowed_resolution_time INT NOT NULL
);

-- 5. TICKETS TABLE ===============================
CREATE TABLE Tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    priority ENUM('Low', 'Medium', 'High', 'Critical') NOT NULL,
    status ENUM('New', 'In Progress', 'Pending', 'Resolved', 'Closed') DEFAULT 'New',
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id INT NOT NULL,
    assigned_to INT,
    resolved_by INT,
    team_id INT,
    sla_due_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (assigned_to) REFERENCES Users(user_id),
    FOREIGN KEY (resolved_by) REFERENCES Users(user_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- 6. TICKET COMMENTS ===============================
CREATE TABLE Ticket_Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    timestamp DATETIME DEFAULT NOW(),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 7. TICKET HISTORY ===============================
CREATE TABLE Ticket_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    old_status VARCHAR(30),
    new_status VARCHAR(30),
    timestamp DATETIME DEFAULT NOW(),
    changed_by INT NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id),
    FOREIGN KEY (changed_by) REFERENCES Users(user_id)
);