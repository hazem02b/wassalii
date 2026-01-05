import requests
import json

BASE_URL = "http://localhost:8000/api/v1"

def create_accounts():
    """Create test accounts via API"""
    
    # CLIENT ACCOUNT
    client_data = {
        "email": "client@wassali.com",
        "password": "ClientTest123!",
        "name": "Client Test",
        "phone": "0600000001",
        "role": "client"
    }
    
    print("→ Creating client account...")
    try:
        response = requests.post(f"{BASE_URL}/auth/register", json=client_data)
        if response.status_code == 200:
            print("✓ Client account created")
        elif response.status_code == 400 and "already exists" in response.text:
            print("✓ Client account already exists")
        else:
            print(f"⚠ Client creation response: {response.status_code}")
            print(f"  {response.text}")
    except Exception as e:
        print(f"❌ Client creation error: {e}")
    
    # TRANSPORTER ACCOUNT
    transporter_data = {
        "email": "transporteur@wassali.com",
        "password": "TransportTest123!",
        "name": "Transporteur Test",
        "phone": "0600000002",
        "role": "transporter"
    }
    
    print("\n→ Creating transporter account...")
    try:
        response = requests.post(f"{BASE_URL}/auth/register", json=transporter_data)
        if response.status_code == 200:
            print("✓ Transporter account created")
        elif response.status_code == 400 and "already exists" in response.text:
            print("✓ Transporter account already exists")
        else:
            print(f"⚠ Transporter creation response: {response.status_code}")
            print(f"  {response.text}")
    except Exception as e:
        print(f"❌ Transporter creation error: {e}")
    
    print("\n" + "="*60)
    print("🎉 COMPTES DE TEST")
    print("="*60)
    print("\n📱 COMPTE CLIENT:")
    print(f"   Email: client@wassali.com")
    print(f"   Password: ClientTest123!")
    print(f"   Type: Client")
    
    print("\n🚛 COMPTE TRANSPORTEUR:")
    print(f"   Email: transporteur@wassali.com")
    print(f"   Password: TransportTest123!")
    print(f"   Type: Transporteur")
    print("\n" + "="*60)
    print("\n✅ Vous pouvez maintenant vous connecter sur l'app!")
    print("   URL: http://localhost:xxxxx")
    print("\n")

if __name__ == "__main__":
    try:
        create_accounts()
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
