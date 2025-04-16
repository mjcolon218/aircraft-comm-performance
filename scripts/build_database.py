import pandas as pd
import sqlite3
import os

# Define file paths
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
DB_PATH = os.path.join(DATA_DIR, 'aircomm_insight.db')

# Load CSV files
aircraft_logs = pd.read_csv(os.path.join(DATA_DIR, 'aircraft_logs.csv'))
#aircraft_metadata = pd.read_csv(os.path.join(DATA_DIR, 'aircraft_metadata.csv'))
rf_coverage_zones = pd.read_csv(os.path.join(DATA_DIR, 'rf_coverage_zones.csv'))
error_codes = pd.read_csv(os.path.join(DATA_DIR, 'error_codes.csv'))

# Connect to SQLite database (create if not exists)
conn = sqlite3.connect(DB_PATH)

# Push each dataframe to SQLite
aircraft_logs.to_sql("aircraft_logs", conn, if_exists="replace", index=False)
#aircraft_metadata.to_sql("aircraft_metadata", conn, if_exists="replace", index=False)
rf_coverage_zones.to_sql("rf_coverage_zones", conn, if_exists="replace", index=False)
error_codes.to_sql("error_codes", conn, if_exists="replace", index=False)

# Close the connection
conn.close()

print(f"✅ Database built successfully at {DB_PATH}")
