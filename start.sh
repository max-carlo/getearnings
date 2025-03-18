#!/bin/bash

echo "Starte Streamlit auf Port ${PORT} ..."
streamlit run momentum.py --server.port=${PORT} --server.address=0.0.0.0