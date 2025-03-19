# Nutze ein schlankes Python-Image
FROM python:3.11-slim

# Installiere Systempakete
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

# Installiere Google Chrome
RUN wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome-keyring.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install -y google-chrome-stable

# Verwende eine explizite ChromeDriver-Version (angepasst!)
ENV CHROMEDRIVER_VERSION=122.0.6261.111

# Lade den passenden ChromeDriver herunter
RUN wget -O /tmp/chromedriver.zip "https://storage.googleapis.com/chrome-for-testing-public/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Setze Umgebungsvariablen für Chrome und ChromeDriver
ENV CHROME_BIN=/usr/bin/google-chrome
ENV CHROMEDRIVER_PATH=/usr/local/bin/chromedriver
ENV PATH="/usr/local/bin:$PATH"

# Setze das Arbeitsverzeichnis
WORKDIR /app
COPY . /app

# Installiere Python-Abhängigkeiten
RUN pip install --no-cache-dir -r requirements.txt

# Exponiere den richtigen Port
EXPOSE 10000

# Starte die Streamlit-App
CMD ["streamlit", "run", "momentum.py", "--server.port=10000", "--server.address=0.0.0.0"]
