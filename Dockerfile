# Use the official Python image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Where the virtualenv will live
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Set the working directory
WORKDIR /app

# Create virtual environment
RUN python -m venv $VIRTUAL_ENV

# Upgrade pip inside venv
RUN pip install --upgrade pip

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Collect static files using venv python
RUN python manage.py collectstatic --noinput

# Expose the port
EXPOSE 8000

# Run gunicorn from venv
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]