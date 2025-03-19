FROM python:3.11-slim

# System Dependencies installieren
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg libnss3 libxss1 libasound2 fonts-liberation libgbm1 libgtk-3-0 \
    libx11-xcb1 libxcb1 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libgtk-3-0 libx11-xcb1 \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome installieren
RUN wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# ChromeDriver automatisch passend zur Chrome-Version herunterladen
RUN CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+') && \
    CHROMEDRIVER_VERSION=$(wget -qO- "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_${CHROME_VERSION}") && \
    wget -O /tmp/chromedriver.zip "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip" && \
    unzip /tmp/chromedriver-linux64.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Arbeitsverzeichnis festlegen und Dateien kopieren
WORKDIR /app
COPY . /app

# Python-Abhängigkeiten installieren
RUN pip install --no-cache-dir -r requirements.txt

# Port freigeben (wichtig: 10000 verwenden!)
EXPOSE 10000

# Streamlit ausführen
CMD ["streamlit", "run", "momentum.py", "--server.port=10000", "--server.address=0.0.0.0"]
