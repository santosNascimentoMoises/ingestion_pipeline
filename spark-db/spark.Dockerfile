FROM eclipse-temurin:17-jdk-jammy

# Instala Python e dependências
RUN apt-get update && \
    apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    build-essential \
    curl && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 && \
    rm -rf /var/lib/apt/lists/*

# Garantir links simbólicos consistentes (blindado)
RUN ln -sf /usr/bin/python3.11 /usr/local/bin/python && \
    ln -sf /usr/local/bin/pip3 /usr/local/bin/pip

# Validação de ambiente
RUN python --version && pip --version

# Diretório de trabalho
WORKDIR /app

# Copia requirements
COPY requirements.txt .

# Instala pacotes
RUN pip install --no-cache-dir pyspark==3.5.0 && \
    ([ -f requirements.txt ] && pip install --no-cache-dir -r requirements.txt || true)

# Verificação da instalação
RUN python -c "from pyspark.sql import SparkSession; print('PySpark import test: OK')" && \
    python --version && pip --version

# Copia restante do código
COPY . .

CMD ["python", "main.py"]