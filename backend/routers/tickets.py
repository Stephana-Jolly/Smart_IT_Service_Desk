from fastapi import APIRouter, HTTPException
from  database import get_db_connection

router = APIRouter(prefix="/tickets", tags=["Tickets"])

@router.get("/")
def get_all_tickets():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        query = "SELECT * FROM tickets ORDER BY created_at DESC;"
        cursor.execute(query)

        tickets = cursor.fetchall()

        cursor.close()
        conn.close()

        return {
            "count": len(tickets),
            "tickets": tickets
        
        }
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 
    