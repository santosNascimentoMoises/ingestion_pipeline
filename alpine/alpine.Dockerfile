FROM python:3.11-alpine

WORKDIR /app

COPY print.py .

CMD ["python", "print.py"]
