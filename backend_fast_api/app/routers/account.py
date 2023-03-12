from fastapi import FastAPI, status, HTTPException, APIRouter, Depends
from fastapi.params import Body
from typing import List

from ..models import CreateUser, TransferAmount, UserDetail, Transaction
from ..oauth2 import get_current_user, check_user_exists_in_vaulter
from ..utils import *

router = APIRouter(prefix="/account")

@router.get("/userdetails", response_model=UserDetail)
def get_user_details(current_user: str = Depends(get_current_user)):
    json_request = {
        "action" : "details",
        "nick_name": current_user
    }
    response = vaulter_api_request(json_request)
    response = convert_response_to_dict(response.text, remove_id=True)
    
    return response


@router.get("/balance")
def get_balance(current_user: str = Depends(get_current_user)):
    json_request = {
        "action": "balance",
        "nick_name": current_user
    }

    response = vaulter_api_request(json_request)
    response = convert_response_to_dict(response.text)

    if "status" in response and response["status"]=="failed":
        HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=response["reason"])
    else:
        return response

@router.get("/transactions", response_model=List[Transaction])
def get_transactions(current_user: str = Depends(get_current_user)):
    json_request = {
        "action": "history",
        "nick_name": current_user
    }

    response = vaulter_api_request(json_request)
    response = convert_response_to_dict(response.text, remove_id=True)
    transactions = []
    for trans in response:
        trans["to"] = trans["to-from"]
        trans.pop("to-from")
        transactions.append(trans)
    return transactions

@router.post("/transfer")
def transfer(transfer_amount: TransferAmount, current_user: str = Depends(get_current_user)):
    check_user_exists_in_vaulter(transfer_amount.to_user)

    json_request = {
        "action": "transfer",
        "amount": transfer_amount.amount,
        "from_user": transfer_amount.from_user,
        "to_user": transfer_amount.to_user
    }
    response = vaulter_api_request(json_request)
    response = convert_response_to_dict(response.text)
    
    if response["status"]=="failed":
        HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=response["reason"])
    else:
        return response