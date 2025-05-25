<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>404 - Not Found</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                display: flex;
                height: 100vh;
                align-items: center;
                justify-content: center;
                font-family: Arial, sans-serif;
            }

            .error-container {
                text-align: center;
                padding: 40px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            }

            .error-code {
                font-size: 96px;
                font-weight: bold;
                color: #dc3545;
            }

            .error-message {
                font-size: 24px;
                color: #333;
            }

            .back-link {
                margin-top: 20px;
            }
        </style>
    </head>

    <body>
        <div class="error-container">
            <div class="error-code">404</div>
            <div class="error-message">Oops! Page not found.</div>
            <div class="back-link">
                <a href="/" class="btn btn-outline-primary">Go to Homepage</a>
            </div>
        </div>
    </body>

    </html>