import os
import tarfile
import shutil
import urllib.request

RGBDS_VERSION = "0.9.1"
FILENAME = f"rgbds-{RGBDS_VERSION}-linux-x86_64.tar.xz"
URL = f"https://github.com/gbdev/rgbds/releases/download/v{RGBDS_VERSION}/{FILENAME}"

EXTRACTED_DIR_ORIG = f"rgbds-{RGBDS_VERSION}"
TARGET_DIR = "rgbds"

def download(url, filename):
    print(f"Downloading from {url}...")
    with urllib.request.urlopen(url) as response, open(filename, 'wb') as out_file:
        shutil.copyfileobj(response, out_file)
    print(f"Downloaded to {filename}")

def extract_tar_xz(filepath):
    print(f"Extracting {filepath}...")
    with tarfile.open(filepath, "r:xz") as tar:
        tar.extractall()
    print("Extraction complete.")

def rename_extracted_dir():
    if os.path.isdir(TARGET_DIR):
        print(f"Removing existing '{TARGET_DIR}' directory...")
        shutil.rmtree(TARGET_DIR)

    print(f"Renaming '{EXTRACTED_DIR_ORIG}' to '{TARGET_DIR}'...")
    os.rename(EXTRACTED_DIR_ORIG, TARGET_DIR)
    print(f"Extraction directory is now './{TARGET_DIR}'")

def main():
    if not os.path.exists(FILENAME):
        download(URL, FILENAME)
    else:
        print(f"{FILENAME} already exists. Skipping download.")

    if not os.path.isdir(TARGET_DIR):
        extract_tar_xz(FILENAME)
        rename_extracted_dir()
    else:
        print(f"'{TARGET_DIR}' directory already exists. Skipping extraction.")

    print(f"\n✅ Done. RGBDS {RGBDS_VERSION} is ready in './{TARGET_DIR}'.")

if __name__ == "__main__":
    main()
