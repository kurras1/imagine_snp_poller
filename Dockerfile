FROM python:3.12-slim

ENV REDIS_IP=0.0.0.0
ENV REDIS_PORT=6379
ENV REDIS_LIST_KEY=list_name
ENV REDIS_KEY_PREFIX=prefix_name

# Install cron and busybox
RUN apt-get update \
  && apt-get install -y \
    cron \
    busybox \
	locales

# Set working directory
WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY SNP_Uptime_Poller.py /app/SNP_Uptime_Poller.py
COPY crontab /etc/cron.d/SNP_Uptime_Poller
COPY entrypoint.sh /app/entrypoint.sh

# Give execute permission to the cron file
RUN chmod 0644 /etc/cron.d/SNP_Uptime_Poller
RUN chmod +x /app/SNP_Uptime_Poller.py
RUN chmod +x /app/entrypoint.sh

# Load crontab
RUN /usr/bin/crontab /etc/cron.d/SNP_Uptime_Poller

# Creating entry point for cron 
ENTRYPOINT /app/entrypoint.sh
