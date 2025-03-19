import streamlit as st
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import os

def get_earnings_data(ticker):
   chrome_options = Options()
chrome_options.add_argument("--headless=new")  # Nutzt den neuesten Headless-Modus
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--remote-debugging-port=9222")  # Setzt DevTools Port
chrome_options.add_argument("--disable-blink-features=AutomationControlled")  # Verhindert Bot-Erkennung
chrome_options.add_argument("--window-size=1920,1080")  # Falls ein Fenster benötigt wird
chrome_options.binary_location = os.getenv("CHROME_BIN", "/usr/bin/google-chrome")

    # Explicitly set the path to ChromeDriver
    service = Service(os.getenv("CHROMEDRIVER_PATH", "/usr/local/bin/chromedriver"))
    driver = webdriver.Chrome(service=service, options=chrome_options)

    url = f"https://finance.yahoo.com/quote/{ticker}/earnings"
    driver.get(url)
    data = driver.page_source
    driver.quit()
    return data

st.title("Earnings Whispers Scraper")
ticker = st.text_input("Enter stock ticker:", "AAPL")
if st.button("Fetch Data"):
    data = get_earnings_data(ticker)
    st.text_area("Earnings Data", data[:1000])
