FROM python:3.9-slim
WORKDIR /app
COPY ../app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY ../app/app.py ./
EXPOSE 80
CMD ["python", "app.py"] 