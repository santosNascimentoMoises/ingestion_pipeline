from airflow.utils.db import create_session
from airflow.www.security import User
from werkzeug.security import generate_password_hash

with create_session() as session:
    if not session.query(User).filter(User.username == 'admin').first():
        user = User(
            first_name='FirstName',
            last_name='LastName',
            username='admin',
            email='admin@example.com',
            password=generate_password_hash('admin'),
            roles=['Admin']
        )
        session.add(user)
        session.commit()
        print("User created successfully")
    else:
        print("User already exists")