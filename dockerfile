FROM python:3.11-slim

# Installiere notwendige Systempakete
RUN apt-get update && apt-get install -y \
    wget gnupg unzip curl libnss3 libxss1 libappindicator3-1 libasound2 fonts-liberation \
    libgbm-dev \
    && rm -rf /var/lib/apt/lists/*

# Installiere Google Chrome
RUN wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Installiere ChromeDriver
RUN CHROME_VERSION=$(google-chrome --version | grep -oE "[0-9.]+" | cut -d '.' -f1) \
    && CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) \
    && wget https://chromedriver.storage.googleapis.com/$CHROME_VERSION/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm chromedriver_linux64.zip

# Python Setup
WORKDIR /app
COPY . /app
RUN pip install --upgrade pip && pip install -r requirements.txt

# Expose port (Streamlit default)
EXPOSE 10000

# Start-Befehl (ohne separates start.sh Skript)
CMD ["streamlit", "run", "momentum.py", "--server.port=10000", "--server.address=0.0.0.0"]
