<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Confirm Invite</title>
        <style>
            .error {
                color: red;
            }
        </style>
    </head>

    <body>
        <h1>Confirm Your Invitation</h1>
        <% if (request.getAttribute("error") !=null) { %>
            <p class="error">
                <%= request.getAttribute("error") %>
            </p>
            <% } %>
                <form action="/invite/confirm" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf.token}" />
                    <input type="hidden" name="inviteCode" value="${inviteCode}" />
                    <button type="submit">Confirm</button>
                </form>
                <a href="/home">Back to Home</a>
    </body>

    </html>