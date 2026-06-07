# Customer Churn - Data Processing Script
# Placeholder - Will be implemented in later tasks

import pandas as pd
import os

def process_data():
    raw_path = 'data/raw/Telco-Customer-Churn.csv'
    processed_path = 'data/processed/churn_processed.csv'

    if not os.path.exists(raw_path):
        print(f"WARNING: Raw data not found at {raw_path}")
        print("Skipping data processing for now...")
        return

    print("Loading raw data...")
    df = pd.read_csv(raw_path)

    print(f"Raw data shape: {df.shape}")

    # Fix TotalCharges column
    df['TotalCharges'] = pd.to_numeric(df['TotalCharges'], errors='coerce')

    # Save processed data
    os.makedirs('data/processed', exist_ok=True)
    df.to_csv(processed_path, index=False)
    print(f"Processed data saved to {processed_path}")

if __name__ == "__main__":
    process_data()
