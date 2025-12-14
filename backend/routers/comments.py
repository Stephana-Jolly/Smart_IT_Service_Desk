from fastapi import APIRouter

router = APIRouter(prefix="/comments", tags=["Comments"])

@router.get("/")
def get_comments():
    return {"message": "Comments API ready"}
