from jose import JWTError, jwt
from datetime import datetime, timedelta
from fastapi import Depends, status, HTTPException
from fastapi.security import OAuth2PasswordBearer

from .models import Token, TokenData
from .utils import *
from .config import settings

oauth2_scheme = OAuth2PasswordBearer(tokenUrl='login')

SECRET_KEY = settings.secret_key
ALGORITHM = settings.algorithm
ACCESS_TOKEN_EXPIRE_MINUTES = settings.access_token_expire_minutes

def create_access_token(data:dict):
    to_encode = data.copy()

    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode["exp"] = expire

    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

    return encoded_jwt

def check_user_exists_in_vaulter(user_name):
    json_request = {
        "action": "details",
        "nick_name": user_name
    }
    response = vaulter_api_request(json_request)
    response = response.text

    if response == "None":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail=f"No such username: {user_name} exists")
    
    return True

def verify_access_token(token: str, credentials_exception):

    try:
        # jwt.decode automatically checks expiry date
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload["username"]
        if id is None:
            raise credentials_exception
        token_data = TokenData(username=username)

    except JWTError:
        raise credentials_exception
    
    return token_data

def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail = f"Could not validate credentials"
    )

    username = verify_access_token(token, credentials_exception).username

    check_user_exists_in_vaulter(username)

    return username