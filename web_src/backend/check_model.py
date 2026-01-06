from app.models.models import User

print('User model columns:')
for col in User.__table__.columns:
    print(f'  - {col.name}: {col.type}')
