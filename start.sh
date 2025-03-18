#!/bin/bash

# Chrome-Pfad setzen (vorher!)
export PATH="/opt/render/project/chrome/opt/google/chrome:$PATH"

# Jetzt Streamlit starten
streamlit run momentum.py --server.port=${PORT:-10000} --server.address=0.0.0.0
