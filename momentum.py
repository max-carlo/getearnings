import streamlit as st
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager

@st.cache_data
def get_earnings_data(ticker):
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--no-sandbox")
    driver = webdriver.Chrome(service=webdriver.chrome.service.Service(ChromeDriverManager().install()), options=chrome_options)

    try:
        url = f'https://finance.yahoo.com/quote/{ticker}/analysis'
        driver.get(url)

        # warte kurz bis Daten geladen sind
        driver_wait = WebDriverWait(driver, 10)
        earnings_data = driver.page_source

        return earnings_data
    except Exception as e:
        return f"Fehler beim Abruf: {str(e)}"
    finally:
        driver.quit()

st.title("Earnings Whispers Scraper")
ticker = st.text_input("Enter stock ticker:", "AAPL")
if st.button("Fetch Data"):
    data = get_earnings_data(ticker)
    st.text_area("Earnings Data", data[:5000], height=400)