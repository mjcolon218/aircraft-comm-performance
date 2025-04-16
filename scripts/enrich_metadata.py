import pandas as pd
import json
import sqlite3
import os

# Paths
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
DB_PATH = os.path.join(DATA_DIR, 'aircomm_insight.db')

# Load aircraft metadata
metadata_file = os.path.join(DATA_DIR, 'aircraft_metadata.csv')
aircraft_metadata = pd.read_csv(metadata_file)

# Load airline profiles JSON
json_file = os.path.join(DATA_DIR, 'airline_profiles.json')
with open(json_file, 'r') as f:
    airline_data = json.load(f)

# Flatten JSON into DataFrame
airline_df = pd.DataFrame.from_dict(airline_data, orient='index').reset_index()
airline_df.columns = ['airline', 'airline_name', 'hub', 'fleet_size']

# Merge on 'airline' field
enriched_metadata = pd.merge(aircraft_metadata, airline_df, on='airline', how='left')

# Save enriched metadata to CSV
enriched_csv_path = os.path.join(DATA_DIR, 'aircraft_metadata_enriched.csv')
enriched_metadata.to_csv(enriched_csv_path, index=False)

# Push to SQLite database
conn = sqlite3.connect(DB_PATH)
enriched_metadata.to_sql('aircraft_metadata_enriched', conn, if_exists='replace', index=False)
conn.close()

print(f"✅ Enriched metadata saved to: {enriched_csv_path}")
print(f"✅ Pushed to database at: {DB_PATH} as 'aircraft_metadata_enriched'")
