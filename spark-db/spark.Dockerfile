FROM openjdk:17-slim

RUN apt-get update && \
    apt-get install -y procps python3 python3-pip python3-venv curl && \
    ln -s /usr/bin/python3 /usr/local/bin/python && \
    ln -s /usr/bin/pip3 /usr/local/bin/pip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install -r requirements.txt

COPY . .

# CMD ["python", "spark_script.py"]