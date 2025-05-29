<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 Forbidden</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f5f7fa;
            text-align: center;
            overflow: hidden;
            position: relative;
        }

        .container {
            position: relative;
            z-index: 2;
        }

        .error-code {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            font-size: 400px;
            color: rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1;
            pointer-events: none;
        }

        .illustration {
            position: relative;
            margin-bottom: 20px;
        }

        .character-sitting {
            position: absolute;
            left: 20%;
            bottom: 10%;
            width: 100px;
        }

        .character-standing {
            position: absolute;
            right: 20%;
            bottom: 10%;
            width: 80px;
        }

        .door {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            bottom: 10%;
            width: 60px;
            height: 100px;
            background-color: #fff;
            border: 2px solid #ccc;
            border-radius: 50px 50px 0 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .door::before {
            content: "CLOSE";
            position: absolute;
            top: 20px;
            font-size: 10px;
            color: #333;
            background-color: #fff;
            padding: 2px 5px;
            border: 1px solid #ccc;
        }

        .door::after {
            content: "";
            position: absolute;
            width: 20px;
            height: 20px;
            background-color: #f5f7fa;
            border: 2px solid #ccc;
            border-radius: 50%;
            top: 50%;
            transform: translateY(-50%);
        }

        .paper-airplane {
            position: absolute;
            top: 20%;
            left: 10%;
            width: 30px;
            transform: rotate(45deg);
        }

        .path {
            position: absolute;
            top: 25%;
            left: 15%;
            width: 70%;
            height: 50px;
            border: 2px dashed #ccc;
            border-radius: 50%;
            z-index: 0;
        }

        .bricks {
            position: absolute;
            top: 15%;
            left: 5%;
            width: 20px;
            height: 10px;
            background-color: #ccc;
        }

        .bricks::before {
            content: "";
            position: absolute;
            top: -15px;
            left: 30px;
            width: 20px;
            height: 10px;
            background-color: #ccc;
        }

        .leaves {
            position: absolute;
            bottom: 10%;
            right: 5%;
            width: 40px;
        }

        .message {
            color: #333;
            margin-bottom: 20px;
        }

        .message h1 {
            font-size: 36px;
            margin: 0;
        }

        .message p {
            font-size: 16px;
            color: #666;
        }

        .go-back-btn {
            background-color: #00c4ff;
            color: #fff;
            padding: 10px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            transition: background-color 0.3s;
        }

        .go-back-btn:hover {
            background-color: #00aaff;
        }

        .ground {
            position: absolute;
            bottom: 0;
            width: 100%;
            height: 20px;
            background-color: #d9e2ec;
            z-index: 1;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="">
        <img style="width: 70vw;" src="/img/403.jpg" alt="">
    </div>
    <div class="message">
        <h1>We are Sorry...</h1>
        <p>The page you're trying to access has restricted access.<br>Please refer to your system administrator</p>
    </div>
    <form action="/">
    <button class="go-back-btn" type="submit">Go Back</button>
    </form>
</div>

</body>
</html>