-- TRIGGER TO AUTO RECORD HISTORY ============================================
DROP TRIGGER IF EXISTS trg_ticket_status_change;
DELIMITER $$

CREATE TRIGGER trg_ticket_status_change
AFTER UPDATE ON Tickets
FOR EACH ROW
BEGIN
    IF NEW.status <> OLD.status THEN
        INSERT INTO Ticket_History(
            ticket_id,
            old_status,
            new_status,
            timestamp,
            changed_by
        )
        VALUES (
            OLD.ticket_id,
            OLD.status,
            NEW.status,
            NOW(),
            -- Ensure changed_by is never NULL
            COALESCE(
                NEW.assigned_to,   -- If ticket was assigned
                NEW.user_id,       -- Else fallback to ticket creator
                0                  -- Else fallback to system user "0"
            )
        );
    END IF;
END$$

DELIMITER ;
