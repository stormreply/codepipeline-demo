FROM python:3.11-slim
WORKDIR /usr/src/app

ARG COMMIT_SHA=unknown
ENV COMMIT_SHA=${COMMIT_SHA}

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 3000
CMD ["python", "app.py"]
