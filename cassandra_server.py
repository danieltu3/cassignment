from cassandra.cluster import Cluster
from datetime import datetime
import http.server


class cassandraHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        cluster = Cluster()
        session = cluster.connect('timestamp_keyspace')
        now = datetime.now()
        current_time = now.strftime("%Y-%m-%d %H:%M:%S-0800")
        session.execute(f"INSERT INTO timestamp_table (ping_time, message) VALUES ('{current_time}', '{current_time}')")
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(f"Timestamp: {current_time} inserted into keyspace".encode())

        rows = session.execute("SELECT * FROM timestamp_table")
        for row in rows:
            print(row)

        return


def main():
    IP_ADDRESS = "0.0.0.0"
    PORT = 8888

    http_server = http.server.HTTPServer((IP_ADDRESS, PORT), cassandraHandler)
    http_server.serve_forever()


if __name__ == "__main__":
    main()