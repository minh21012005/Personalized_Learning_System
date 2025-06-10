<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Invite Student</title>
        <style>
            .error {
                color: red;
            }
        </style>
    </head>

    <body>
        <h1>Invite a Student</h1>
        <% if (request.getAttribute("error") !=null) { %>
            <p class="error">
                <%= request.getAttribute("error") %>
            </p>
            <% } %>
                <form action="/invite/create" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                    <label for="studentEmail">Student Email:</label>
                    <input type="email" id="studentEmail" name="studentEmail" required />
                    <button type="submit">Send Invite</button>
                </form>
                <a href="/home">Back to Home</a>
    </body>

    </html>