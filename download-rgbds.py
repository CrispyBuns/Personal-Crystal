import os
import tarfile
import urllib.request

# URL to download from
url = "https://github.com/gbdev/rgbds/releases/download/v0.9.1/rgbds-0.9.1-linux-x86_64.tar.xz"
filename = "rgbds-0.9.1-linux-x86_64.tar.xz"
extract_dir = "rgbds"

# Download the file
print(f"Downloading {filename}...")
urllib.request.urlretrieve(url, filename)
print("Download complete.")

# Extract it to 'rgbds' directory
print(f"Extracting to '{extract_dir}'...")
os.makedirs(extract_dir, exist_ok=True)

with tarfile.open(filename, "r:xz") as tar:
    tar.extractall(path=extract_dir)

print("Extraction complete.")
