#!/usr/bin/env python3
import os
import zipfile
import requests

# URL to download
url = "https://github.com/gbdev/rgbds/releases/download/v0.9.1/rgbds-0.9.1-win64.zip"
zip_filename = "rgbds-0.9.1-win64.zip"
extract_folder = "rgbds"

# Step 1: Download the ZIP file
print("Downloading RGBDS 0.9.1...")
response = requests.get(url, stream=True)
response.raise_for_status()

with open(zip_filename, 'wb') as f:
    for chunk in response.iter_content(chunk_size=8192):
        f.write(chunk)
print(f"Downloaded: {zip_filename}")

# Step 2: Extract only .exe files
print("Extracting .exe files...")
os.makedirs(extract_folder, exist_ok=True)

with zipfile.ZipFile(zip_filename, 'r') as zip_ref:
    for file_info in zip_ref.infolist():
        if file_info.filename.endswith('.exe'):
            extracted_path = zip_ref.extract(file_info, extract_folder)
            print(f"Extracted: {file_info.filename} -> {extracted_path}")

# Step 3: Delete the ZIP file
try:
    os.remove(zip_filename)
    print(f"Deleted ZIP file: {zip_filename}")
except OSError as e:
    print(f"Error deleting ZIP file: {e}")

print(f"Done. .exe files extracted to ./{extract_folder}")
