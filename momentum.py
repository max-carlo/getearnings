import streamlit as st
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time

@st.cache_data
def get_earnings_data(ticker):
    chrome_options = Options()
    chrome_options.binary_location = "/opt/render/project/.render/chrome/opt/google/chrome/chrome"
    chrome_options.add_argument("--headless=new")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")

    service = webdriver.ChromeService(executable_path="/opt/render/project/.render/chrome/usr/local/bin/chromedriver")
    driver = webdriver.Chrome(service=service, options=chrome_options)
    url = f"https://finance.yahoo.com/quote/{ticker}/earnings"
    driver.get(url)
    time.sleep(5)
    data = driver.page_source
    driver.quit()
    return data

st.title("Earnings Whispers Scraper")
ticker = st.text_input("Enter stock ticker:", "AAPL")
if st.button("Fetch Data"):
    data = get_earnings_data(ticker)
    st.text_area("Earnings Data", data[:1000])
