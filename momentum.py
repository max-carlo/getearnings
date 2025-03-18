import streamlit as st
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service

@st.cache_data
def get_earnings_data(ticker):
    options = webdriver.ChromeOptions()
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.binary_location = "/usr/bin/google-chrome"

    service = Service(executable_path="/usr/local/bin/chromedriver")
    driver = webdriver.Chrome(service=service, options=options)

    url = f"https://finance.yahoo.com/quote/{ticker}/"
    driver.get(url)
    html = driver.page_source
    driver.quit()

    return html

st.title("Earnings Whispers Scraper")
ticker = st.text_input("Enter stock ticker:", "AAPL")

if st.button("Fetch Data"):
    data = get_earnings_data(ticker)
    st.text_area("Earnings Data", data[:1000], height=500)
