import streamlit as st
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import os

def get_earnings_data(ticker):
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.binary_location = "/usr/bin/google-chrome"

    # Explicitly provide ChromeDriver path
    service = Service("/usr/local/bin/chromedriver")
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
