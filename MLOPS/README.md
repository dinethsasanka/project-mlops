# mlops-project

Customer Churn Prediction MLOps Platform built on AWS.

## Project Structure
- `data/`      — Raw and processed datasets
- `models/`    — Trained model artifacts
- `notebooks/` — EDA and exploration notebooks
- `src/`       — Source code package
- `tests/`     — Unit and integration tests
- `configs/`   — Configuration files
- `docs/`      — Project documentation

## Setup
bash setup.sh

## Start JupyterLab
source ml-env/bin/activate
jupyter lab --config=jupyter_lab_config.py --no-browser &
