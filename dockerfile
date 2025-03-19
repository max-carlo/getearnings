# Start with a lightweight Python image
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    libnss3 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    fonts-liberation \
    xdg-utils \
    libgbm-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome (from Render's recommended method)
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome-keyring.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install -y google-chrome-stable

# Set environment variables for Chrome in Render
ENV CHROME_BIN=/usr/bin/google-chrome
ENV PATH="/usr/local/bin:$PATH"

# Install ChromeDriver
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}') && \
    CHROME_MAJOR_VERSION=$(echo $CHROME_VERSION | cut -d '.' -f1) && \
    CHROMEDRIVER_VERSION=$(curl -sS "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_$CHROME_MAJOR_VERSION") && \
    wget -O /tmp/chromedriver.zip "https://storage.googleapis.com/chrome-for-testing-public/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Set ChromeDriver path
ENV CHROMEDRIVER_PATH=/usr/local/bin/chromedriver

# Create a working directory
WORKDIR /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the correct port (10000)
EXPOSE 10000

# Run Streamlit app
CMD ["streamlit", "run", "momentum.py", "--server.port=10000", "--server.address=0.0.0.0"]
