import requests
import json
from bson import json_util

VAULTER_API_URL = "http://events.respark.iitm.ac.in:5000/rp_bank_api"

def vaulter_api_request(payload) -> dict:
    headers = {
        'Content-Type': 'application/json'
    }
    payload = json.dumps(payload)
    response = requests.request("POST", VAULTER_API_URL, headers=headers, data=payload)

    return response

def remove_id_from_response(response):
    final_response = ""
    i = 0
    flag=False
    id_indices = []

    while i<len(response):
        if response[i]=="{" and response[i+1: i+6]=="\"_id\"":
            flag = True
            start_i = i
            end_i = i
            while response[end_i]!=",":
                end_i+=1
            id_indices.append([start_i, end_i])
            i = end_i
        i+=1
    
    if not flag:
        final_response = response
    else:
        start = 0
        for r in id_indices:
            final_response += response[start:r[0]+1]
            start = r[1]+1
        final_response += response[start:]

    return final_response

def convert_response_to_dict(response, remove_id=False):
    if response=="None":
        return None
    response = response.replace("'", "\"")

    if remove_id:
        response = remove_id_from_response(response)
    response = json.loads(response)
    
    return response