from fastapi import FastAPI
from routers import tickets, comments, sla, users, analytics

app = FastAPI(title="Smart IT Service Desk API")

# Register Routers
app.include_router(tickets.router)
app.include_router(comments.router)
app.include_router(sla.router)
app.include_router(users.router)
app.include_router(analytics.router)    

@app.get("/")
def home():
    return {"message": "Smart Service Desk API is running!"}
