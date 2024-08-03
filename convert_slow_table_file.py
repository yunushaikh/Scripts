import pymysql

def export_slow_logs_to_file(host, user, password, database, output_file):
    # Connect to the MySQL database
    conn = pymysql.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )

    cursor = conn.cursor(pymysql.cursors.DictCursor)

    # Query to select slow log data
    query = """
    SELECT
        start_time,
        user_host,
        query_time,
        lock_time,
        rows_sent,
        rows_examined,
        db,
        sql_text
    FROM slow_log_hist WHERE start_time >= NOW() - INTERVAL 10 DAY
    """

    cursor.execute(query)

    logs = cursor.fetchall()

    with open(output_file, 'w') as file:
        for log in logs:
            # Extract fields
            start_time = log['start_time'].strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
            user_host = log['user_host']
            query_time = str(log['query_time'])
            lock_time = str(log['lock_time'])
            rows_sent = log['rows_sent']
            rows_examined = log['rows_examined']
            db = log['db']
            sql_text = log['sql_text'].decode('utf-8', errors='replace').replace('\n', ' ').replace('\r', '')

            # Format and write the log entry
            entry = (
                f"# Time: {start_time}\n"
                f"# User@Host: {user_host}\n"
                f"# Query_time: {query_time}  Lock_time: {lock_time}  Rows_sent: {rows_sent}  Rows_examined: {rows_examined}\n"
                f"use {db}\n"
                f"{sql_text}\n\n"
            )
            file.write(entry)

    cursor.close()
    conn.close()

    print(f"Slow logs have been exported to {output_file}")

# Usage
host = 'localhost'
user = 'root'
password = 'verysecretpassword1^'
database = 'slow'
output_file = 'slow_logs_formatted.txt'

export_slow_logs_to_file(host, user, password, database, output_file)
