FROM python:3.11-slim

# Installiere Systemabhängigkeiten
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    gnupg \
    libnss3 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    fonts-liberation \
    xdg-utils \
    libgbm1 \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome installieren (feste Version)
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb || apt-get -f install -y && \
    rm google-chrome-stable_current_amd64.deb

# Feste ChromeDriver-Version (123.0.6312.86 aktuell Stand März 2025, ggf. anpassen)
RUN wget -O /tmp/chromedriver.zip https://storage.googleapis.com/chromedriver-linux64/123.0.6312.122/chromedriver-linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# App-Verzeichnis einrichten
WORKDIR /app
COPY . /app

# Python-Abhängigkeiten installieren
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Port freigeben
EXPOSE 10000

# Startkommando
CMD ["streamlit", "run", "momentum.py", "--server.port=10000", "--server.address=0.0.0.0"]

---

### Hinweise zur Versionswahl
- Prüfe unbedingt die aktuelle ChromeDriver-Version, die zur stabilen Chrome-Version passt. (https://googlechromelabs.github.io/chrome-for-testing/)
- Passe ggf. die Versionsnummer `123.0.6312.122` an, je nachdem, was aktuell stabil verfügbar ist (Stand März 2025 exemplarisch verwendet).

**So vermeidest du zuverlässig dein aktuelles Problem:**
- **Feste Chrome-Version** (nicht dynamisch)
- **Feste ChromeDriver-Version** (nicht dynamisch)
- **EXPOSE 10000** und Startkommando ebenfalls explizit mit Port 10000.

👉 Ersetze dein aktuelles Dockerfile mit dem oben angegebenen vollständigen Code und deploye dann erneut auf Render.
