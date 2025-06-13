FROM python:3.11-slim

WORKDIR /app

COPY . .

# instala as bibliotecas
RUN pip install -r requirements.txt || true

# bom pra limpar a tela
RUN apt-get update && apt-get install -y ncurses-bin  # Garante que 'clear' esteja disponível

CMD ["sh", "-c", "clear && /bin/bash"]

# roda a main
CMD ["python", "main.py"]