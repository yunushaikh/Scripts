#!/bin/bash

# MySQL connection details
HOST="your_host"
USER="your_user"
PASSWORD="your_password"
DATABASE="your_database"

# Filename to save the CSV
CSV_FILENAME="unused_indexes.csv"

# MySQL query to get unused indexes
QUERY="
SELECT * from sys.schema_unused_indexes;
"

# Execute the query and save results to CSV
mysql -h "$HOST" -u "$USER" -p"$PASSWORD" -D "$DATABASE" -e "$QUERY" | sed 's/\t/,/g' > "$CSV_FILENAME"

echo "Unused indexes saved to $CSV_FILENAME"
