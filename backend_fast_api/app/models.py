from pydantic import BaseModel
import datetime

class CreateUser(BaseModel):
    nick_name: str
    full_name: str
    user_name: str
    pin_number: str
    mob_number: str
    upi_id: str

class UpdateUser(BaseModel):
    nick_name: str
    key: str
    value: str

class UserDetail(BaseModel):
    nick_name: str
    full_name: str
    user_name: str
    mob_number: str
    upi_id: str

class VerifyPin(BaseModel):
    pin: str

class TransferAmount(BaseModel):
    amount: float
    from_user: str
    to_user: str

class Transaction(BaseModel):
    date: str
    time: str
    to: str
    amount: float
    balance: float

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: str