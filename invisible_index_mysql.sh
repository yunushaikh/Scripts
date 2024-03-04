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
SELECT
    TABLE_NAME,
    INDEX_NAME,
    SEQ_IN_INDEX,
    COLUMN_NAME
FROM
    INFORMATION_SCHEMA.STATISTICS
WHERE
    TABLE_SCHEMA = '$DATABASE'
    AND SEQ_IN_INDEX = 1
    AND INDEX_NAME NOT IN (
        SELECT
            INDEX_NAME
        FROM
            INFORMATION_SCHEMA.STATISTICS
        WHERE
            TABLE_SCHEMA = '$DATABASE'
            AND SEQ_IN_INDEX = 1
    );
"

# Execute the query and save results to CSV
mysql -h "$HOST" -u "$USER" -p"$PASSWORD" -D "$DATABASE" -e "$QUERY" | sed 's/\t/,/g' > "$CSV_FILENAME"

echo "Unused indexes saved to $CSV_FILENAME"
