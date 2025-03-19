FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    libnss3 \
    libxss1 \
    libasound2 \
    fonts-liberation \
    libgbm-dev \
    xdg-utils \
 && rm -rf /var/lib/apt/lists/*

# Chrome installieren
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome.gpg \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
 && apt-get update \
 && apt-get install -y google-chrome-stable \
 && rm -rf /var/lib/apt/lists/*

# ChromeDriver manuell installieren
RUN CHROME_VERSION=$(google-chrome --version | grep -oP '[0-9.]+' | cut -d'.' -f1) \
 && CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) \
 && wget -q "https://chromedriver.storage.googleapis.com/$CHROME_VERSION/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
 && unzip /tmp/chromedriver.zip -d /usr/local/bin/ \
 && chmod +x /usr/local/bin/chromedriver \
 && rm /tmp/chromedriver.zip

WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt

EXPOSE 10000

CMD ["./start.sh"]
