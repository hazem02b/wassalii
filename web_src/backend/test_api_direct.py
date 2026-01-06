import requests
import json

url = "http://localhost:8000/api/v1/auth/register"
data = {
    "email": "testdirect@wassali.com",
    "password": "Test123!",
    "first_name": "Test",
    "last_name": "User",
    "phone": "+33611223344",
    "role": "client"
}

headers = {"Content-Type": "application/json"}

try:
    print(f"POST {url}")
    print(f"Data: {json.dumps(data, indent=2)}")
    
    response = requests.post(url, json=data, headers=headers)
    
    print(f"\nStatus Code: {response.status_code}")
    print(f"Response: {response.text}")
    
    if response.status_code == 201:
        print("\n✅ SUCCESS!")
        result = response.json()
        print(f"User ID: {result['user']['id']}")
        print(f"Email: {result['user']['email']}")
        print(f"Token: {result['access_token'][:50]}...")
    else:
        print(f"\n❌ ERROR {response.status_code}")
        
except requests.exceptions.RequestException as e:
    print(f"\n❌ Connection Error: {e}")
except Exception as e:
    print(f"\n❌ Error: {e}")
