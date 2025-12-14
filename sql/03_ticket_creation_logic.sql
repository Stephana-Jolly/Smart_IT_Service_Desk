-- AUTOASSIGNTICKET ==================================================
DELIMITER $$

CREATE PROCEDURE AutoAssignTicket(IN p_ticket_id INT)
BEGIN
    DECLARE targetTeam INT;
    DECLARE assignedUser INT;

    -- Find the team whose specialization matches the ticket category
    SELECT team_id INTO targetTeam
    FROM Teams
    WHERE specialization = (SELECT category FROM Tickets WHERE ticket_id = p_ticket_id)
    LIMIT 1;

    -- Assign the ticket to the first agent in that team
    IF targetTeam IS NOT NULL THEN
        SELECT user_id INTO assignedUser 
        FROM Users 
        WHERE team_id = targetTeam AND role = 'agent'
        LIMIT 1;

        UPDATE Tickets
        SET assigned_to = assignedUser,
            team_id = targetTeam
        WHERE ticket_id = p_ticket_id;
    END IF;

END $$

DELIMITER ;

-- CALCULATESLA =========================================================
DELIMITER $$

CREATE PROCEDURE CalculateSLA(IN p_ticket_id INT)
BEGIN
    UPDATE Tickets t
    JOIN SLA_Policies s 
      ON t.category = s.category AND t.priority = s.priority
    SET t.sla_due_time = DATE_ADD(t.created_at, INTERVAL s.allowed_resolution_time HOUR)
    WHERE t.ticket_id = p_ticket_id;
END $$

DELIMITER ;

-- CREATE TICKET PROCEDURE ======================================================================
DELIMITER $$

CREATE PROCEDURE CreateTicket (
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_category VARCHAR(50),
    IN p_priority VARCHAR(20),
    IN p_user_id INT
)
BEGIN
    DECLARE new_ticket_id INT;

    -- Insert initial ticket
    INSERT INTO Tickets (title, description, category, priority, status, created_at, user_id)
    VALUES (p_title, p_description, p_category, p_priority, 'New', NOW(), p_user_id);

    SET new_ticket_id = LAST_INSERT_ID();

    -- Calculate SLA due time
    CALL CalculateSLA(new_ticket_id);

    -- Auto assign team & agent
    CALL AutoAssignTicket(new_ticket_id);

    -- Return newly created ticket ID
    SELECT new_ticket_id AS ticket_created;
END $$

DELIMITER ;
