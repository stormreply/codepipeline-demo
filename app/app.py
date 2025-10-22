from flask import Flask
import socket
import os

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    commit_sha = os.getenv('COMMIT_SHA', 'unknown')
    app_name = os.getenv('APP_NAME', 'Demo Application')

    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>{app_name}</title>
        <style>
            body {{
                font-family: Arial, sans-serif;
                max-width: 800px;
                margin: 50px auto;
                padding: 20px;
                background-color: #f5f5f5;
            }}
            .container {{
                background-color: green;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }}
            h1 {{
                color: #333;
                margin-top: 0;
            }}
            .info {{
                background-color: #f0f7ff;
                padding: 15px;
                border-left: 4px solid #0066cc;
                margin: 15px 0;
            }}
            .label {{
                font-weight: bold;
                color: #555;
            }}
            .value {{
                color: #0066cc;
                font-family: monospace;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>{app_name}</h1>
            <div class="info">
                <p><span class="label">Container IP:</span> <span class="value">{ip_address}</span></p>
                <p><span class="label">Commit SHA:</span> <span class="value">{commit_sha}</span></p>
            </div>
        </div>
    </body>
    </html>
    """
    return html

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
