#!/bin/bash

streamlit run momentum.py --server.port=${PORT:-10000} --server.address=0.0.0.0
export PATH="${PATH}:/opt/render/project/.render/chrome/opt/google/chrome/"
