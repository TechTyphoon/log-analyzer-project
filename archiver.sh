#!/bin/bash

# --- CONFIGURATION ---
# IMPORTANT: Make sure this path is correct for your system!
# To find your home path, type 'echo $HOME' in a terminal.
ARCHIVE_DIR="/home/reddy/log_archives"
ELASTICSEARCH_HOST="http://localhost:9200"

# --- SCRIPT LOGIC ---

# Get yesterday's date in the format YYYY.MM.DD (e.g., 2025.06.19)
YESTERDAY=$(date -d "yesterday" +"%Y.%m.%d")
INDEX_NAME="filebeat-$YESTERDAY"
BACKUP_FILE="$ARCHIVE_DIR/$INDEX_NAME.json.gz"

echo "--- Starting Archive for Index: $INDEX_NAME ---"

# Step 1: Dump the index data and compress it in one go
echo "Backing up index to $BACKUP_FILE..."
elasticdump \
  --input="${ELASTICSEARCH_HOST}/${INDEX_NAME}" \
  --output=- | gzip > "$BACKUP_FILE"

# Step 2: Check if the backup was successful before deleting
# The 'if' statement checks if the previous command succeeded ($? -eq 0)
# and if the created backup file actually has data in it (-s).
if [ $? -eq 0 ] && [ -s "$BACKUP_FILE" ]; then
  echo "Backup successful. Size: $(du -h $BACKUP_FILE | cut -f1)"
  echo "Deleting index ${INDEX_NAME} from Elasticsearch..."
  curl -X DELETE "${ELASTICSEARCH_HOST}/${INDEX_NAME}"
  echo -e "\n--- Deletion Complete ---"
else
  echo "Backup FAILED for index ${INDEX_NAME}. Deletion will be skipped."
  # Remove the failed/empty backup file
  rm "$BACKUP_FILE"
fi

echo "--- Archive Process Finished ---"
