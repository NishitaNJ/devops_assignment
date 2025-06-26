# Use official Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirement file first (leverages Docker caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port 5000
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
