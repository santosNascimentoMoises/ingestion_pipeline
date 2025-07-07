import os
import time

def main():

    print("STREAM_NAME:", os.getenv("STREAM_NAME"))
    print("STREAM_PATH:", os.getenv("STREAM_PATH"))
    print("STREAM_PK:", os.getenv("STREAM_PK"))
    print("REPLICATION_KEY:", os.getenv("REPLICATION_KEY"))
    print("SCHEMA_FILEPATH:", os.getenv("SCHEMA_FILEPATH"))

    print('\n')
    print("API_URL:", os.getenv("API_URL"))
    print("API_USER:", os.getenv("API_USER"))
    print("API_PASSWORD:", os.getenv("API_PASSWORD"))

    time.sleep(5)

if __name__ == "__main__":
    main()

# testar se o alpine acessa o diretório montado
os.chdir("/app/output")
print(os.listdir())
