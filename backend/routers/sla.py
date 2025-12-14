from fastapi import APIRouter

router = APIRouter(prefix="/sla", tags=["SLA"])

@router.get("/")
def check_sla():
    return {"message": "SLA API ready"}
