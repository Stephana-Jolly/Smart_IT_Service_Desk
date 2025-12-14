#-- ANALYTICS ROUTER =============================
from fastapi import APIRouter
from database import get_db_connection

router = APIRouter(prefix="/analytics", tags=["Analytics"])

# -- GET TICKETS BY STATUS=============================
@router.get("/tickets-by-status")
def tickets_by_status():
    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT status, COUNT(*) AS total
            FROM Tickets
            GROUP BY status
        """)
        data = cursor.fetchall()
    conn.close()
    return data

# -- GET TICKETS BY PRIORITY=============================
@router.get("/tickets-by-priority")
def tickets_by_priority():
    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT priority, COUNT(*) AS total
            FROM Tickets
            GROUP BY priority
        """)
        data = cursor.fetchall()
    conn.close()
    return data

# -- GET SLA BREACHES=============================
@router.get("/sla-breaches")
def sla_breaches():
    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT COUNT(*) AS breach_count
            FROM tickets
            WHERE
                sla_due_time IS NOT NULL
                AND status NOT IN ('Resolved', 'Closed')
                AND sla_due_time < NOW();
        """)
        result = cursor.fetchone()
    conn.close()

    return {
        "sla_breaches": result["breach_count"]
    }


# -- GET AVERAGE RESOLUTION TIME=============================
@router.get("/average-resolution-time")
def average_resolution_time():
    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT 
                ROUND(AVG(TIMESTAMPDIFF(HOUR, created_at, resolved_at)),2)
                AS avg_resolution_hours
            FROM Tickets
            WHERE status IN ('Resolved', 'Closed')
        """)
        data = cursor.fetchone()
    conn.close()
    return data