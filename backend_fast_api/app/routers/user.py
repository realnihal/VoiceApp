from fastapi import FastAPI, status, HTTPException, APIRouter, Depends
from fastapi.params import Body
import json

from ..models import CreateUser, UpdateUser
from ..utils import *
from ..oauth2 import get_current_user


router = APIRouter(prefix="/user")

@router.post("/createuser", status_code=status.HTTP_201_CREATED)
def create_user(user: CreateUser):
    #(TODO) Implement logic to decrypt the password
    json_dict = {
        "action": "register", **user.dict()
    }
    response = vaulter_api_request(json_dict)
    response = convert_response_to_dict(response.text)
    
    if response["status"]=="failed":
        raise HTTPException(status_code=status.HTTP_424_FAILED_DEPENDENCY, detail=response["reason"])
    
    return response
    
    

@router.delete('/deleteuser', status_code=status.HTTP_204_NO_CONTENT)
def delete_user(current_user: str = Depends(get_current_user)):
    
    json_request = {
        "action":"remove",
        "nick_name": current_user
    }

    response = vaulter_api_request(json_request)
    response = convert_response_to_dict(response.text)

    if response is None:
        return 
    
    if response["status"] == "failed":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=response["reason"])


@router.put("/updateuser")
def update_user(user_details: UpdateUser, current_user: str = Depends(get_current_user)):
    if user_details.nick_name!=current_user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)
    
    json_request = {
        "action": "update",
        "nick_name": user_details.nick_name,
        "key": user_details.key,
        "value": user_details.value
    }

    reponse = vaulter_api_request(json_request)
    reponse = convert_response_to_dict(reponse.text)

    return reponse



