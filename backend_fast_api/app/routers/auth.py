from fastapi import HTTPException, APIRouter, Depends, status
from fastapi.security.oauth2 import OAuth2PasswordRequestForm

from .. import models, oauth2
from ..utils import *
from ..oauth2 import get_current_user

router = APIRouter(tags=["Authentication"])

@router.post("/login", response_model=models.Token)
def login(user_credentials: OAuth2PasswordRequestForm = Depends()):

    ## Verify that the user exists
    json_request = {
        "action": "details",
        "nick_name": user_credentials.username
    }
    response = vaulter_api_request(json_request)
    response = response.text

    if response == "None":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No such username exists")
    
    response = convert_response_to_dict(response, remove_id=True)

    if response["pin_number"] != user_credentials.password:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Invalid credentials")    
    
    access_token = oauth2.create_access_token(data={"username": user_credentials.username})

    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/verifypin")
def verify_pin(pin: models.VerifyPin, user_name: str = Depends(get_current_user)):
    json_request = {
        "action": "details",
        "nick_name": user_name
    }
    response = vaulter_api_request(json_request)
    response = convert_response_to_dict(response.text, remove_id=True)

    if pin.pin==response["pin_number"]:
        return {
            "status": "success"
        }
    else:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid Pin")
