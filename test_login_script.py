import requests
import json

BASE_URL = "http://localhost:8000/api/v1"

def test_login():
    print("Testing login...")
    url = f"{BASE_URL}/auth/login"
    payload = {
        "email": "test@wassali.com",
        "password": "password123",
        "role": "client"
    }
    
    try:
        response = requests.post(url, json=payload)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            print("Login Successful!")
            print(json.dumps(response.json(), indent=2))
        else:
            print("Login Failed!")
            print(response.text)
    except Exception as e:
        print(f"Connection Error: {e}")

if __name__ == "__main__":
    test_login()
