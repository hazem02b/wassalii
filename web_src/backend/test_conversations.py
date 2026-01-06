import requests
import json

# Connexion avec hazem (client)
print("=== Test avec hazem bellili (client) ===")
login_data = {
    "email": "hazembellili800@gmail.com",
    "password": "Hazem@2024",  # Essayons ce mot de passe
    "role": "client"
}

try:
    response = requests.post("http://127.0.0.1:8888/api/v1/auth/login", json=login_data)
    if response.status_code == 200:
        token = response.json()['access_token']
        print(f"✓ Login réussi, token obtenu")
        
        # Récupérer les conversations
        headers = {"Authorization": f"Bearer {token}"}
        conv_response = requests.get("http://127.0.0.1:8888/api/v1/messages/conversations", headers=headers)
        
        if conv_response.status_code == 200:
            conversations = conv_response.json()
            print(f"\n✓ {len(conversations)} conversation(s) trouvée(s)")
            
            for conv in conversations:
                print(f"\n--- Conversation {conv['conversation_id']} ---")
                print(f"  other_user_id: {conv['other_user_id']}")
                print(f"  other_user_name: {conv['other_user_name']}")
                print(f"  other_user_email: {conv['other_user_email']}")
                print(f"  last_message: {conv['last_message']}")
        else:
            print(f"✗ Erreur lors de la récupération des conversations: {conv_response.status_code}")
            print(f"  {conv_response.text}")
    else:
        print(f"✗ Login échoué: {response.status_code}")
        print(f"  {response.text}")
except Exception as e:
    print(f"✗ Erreur: {e}")

print("\n" + "="*50)
print("=== Test avec oussema bellili (transporter) ===")
login_data2 = {
    "email": "hazembellili80@gmail.com",
    "password": "Hazem@2024",
    "role": "transporter"
}

try:
    response = requests.post("http://127.0.0.1:8888/api/v1/auth/login", json=login_data2)
    if response.status_code == 200:
        token = response.json()['access_token']
        print(f"✓ Login réussi, token obtenu")
        
        # Récupérer les conversations
        headers = {"Authorization": f"Bearer {token}"}
        conv_response = requests.get("http://127.0.0.1:8888/api/v1/messages/conversations", headers=headers)
        
        if conv_response.status_code == 200:
            conversations = conv_response.json()
            print(f"\n✓ {len(conversations)} conversation(s) trouvée(s)")
            
            for conv in conversations:
                print(f"\n--- Conversation {conv['conversation_id']} ---")
                print(f"  other_user_id: {conv['other_user_id']}")
                print(f"  other_user_name: {conv['other_user_name']}")
                print(f"  other_user_email: {conv['other_user_email']}")
                print(f"  last_message: {conv['last_message']}")
        else:
            print(f"✗ Erreur lors de la récupération des conversations: {conv_response.status_code}")
            print(f"  {conv_response.text}")
    else:
        print(f"✗ Login échoué: {response.status_code}")
        print(f"  {response.text}")
except Exception as e:
    print(f"✗ Erreur: {e}")
