-- UPDATE TICKETSTATUS STORED PROCEDURE ===========================================
DELIMITER $$

CREATE PROCEDURE UpdateTicketStatus(
    IN p_ticket_id INT,
    IN p_new_status VARCHAR(30),
    IN p_changed_by INT
)
BEGIN
    DECLARE oldStatus VARCHAR(30);

    -- Fetch current status
    SELECT status INTO oldStatus
    FROM Tickets
    WHERE ticket_id = p_ticket_id;

    -- Update ticket
    UPDATE Tickets
    SET status = p_new_status,
        updated_at = NOW(),
        resolved_by = CASE 
                        WHEN p_new_status = 'Resolved' OR p_new_status = 'Closed'
                        THEN p_changed_by
                        ELSE resolved_by
                      END
    WHERE ticket_id = p_ticket_id;

    -- Insert into history
    INSERT INTO Ticket_History(ticket_id, old_status, new_status, timestamp, changed_by)
    VALUES (p_ticket_id, oldStatus, p_new_status, NOW(), p_changed_by);

END$$

DELIMITER ;

-- ESCALATION RULE ============================================================
DELIMITER $$

CREATE PROCEDURE CheckSLA_Escalation()
BEGIN
    UPDATE Tickets
    SET status = 'Pending'
    WHERE sla_due_time < NOW() AND status NOT IN ('Resolved', 'Closed');
END$$

DELIMITER ;

-- 
