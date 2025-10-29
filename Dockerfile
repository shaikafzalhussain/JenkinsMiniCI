# Use an official Python image as base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements first (for efficient Docker layer caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# Expose port (change if your app uses another)
EXPOSE 5000

# Command to run the app
CMD ["python", "app.py"]
