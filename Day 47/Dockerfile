FROM python:3.10-slim

WORKDIR /src

COPY ./src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY ./src  .

EXPOSE 5004

CMD ["python", "server.py"]
