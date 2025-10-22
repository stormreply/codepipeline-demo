# FROM python:3.11-slim
FROM public.ecr.aws/docker/library/python:3.11-slim
WORKDIR /usr/src/app

ARG COMMIT_SHA=unknown
ARG APP_NAME=unknown
ENV COMMIT_SHA=${COMMIT_SHA}
ENV APP_NAME=${APP_NAME}

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 3000
CMD ["python", "app.py"]
