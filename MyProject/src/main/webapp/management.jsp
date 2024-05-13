<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Management Page</title>
    <%@ include file="cdn.jsp"%>
    <%@ page import="java.sql.*, java.util.*, com.database.DbConnection"%>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2, h3 {
            text-align: center;
            color: #007bff;
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
        }
        button[type="submit"] {
            width: 100%;
            margin-top: 20px;
        }
        .navbar {
            background-color: #007bff;
            padding: 10px 0;
        }
        .navbar-brand {
            color: #fff;
            font-size: 24px;
            font-weight: bold;
             margin-left: 25px;
        }
        .login-btn {
            color: #fff;
            background-color: #28a745;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 1150px;
        }
        .login-btn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <span class="navbar-brand">MyProject</span>
        <button class="login-btn" onclick="window.location.href='login.jsp'">Logout</button>
    </nav>
    <div class="container">
        <h2>Management Page</h2>
        <hr>

        <!-- Form to submit request -->
        <h3>Submit Request</h3>
        <form method="post" action="submitRequest.jsp">
            <div class="mb-3">
                <label for="title" class="form-label">Request:</label>
                <input type="text" class="form-control" id="title" name="title" required>
            </div>
            <div class="mb-3">
                <label for="description" class="form-label">Description:</label>
                <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
            </div>
            <div class="mb-3">
                <label for="username" class="form-label">UserName:</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="department" class="form-label">Department:</label>
                <select class="form-select" id="department" name="department" required>
                    <option value="management">Management</option>
                    <option value="legal">Legal</option>
                    <option value="financial">Financial</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>

        <hr>

        <!-- Table to display requests -->
        <h3>Requests</h3>
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>SNO</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Requested By</th>
                    <th>Request Date</th>
                    <th>Department</th>
                    <th>Approval Date</th>
                    <th>Approved By</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    con = DbConnection.takeConnection();

                    // Insert new request into the database
                    String title = request.getParameter("title");
                    String description = request.getParameter("description");
                    String requestBy = request.getParameter("username");
                    String department = request.getParameter("department");

                    if (title != null && !title.isEmpty() && description != null && !description.isEmpty() && requestBy != null && !requestBy.isEmpty() && department != null && !department.isEmpty()) {
                        String insertQuery = "INSERT INTO requests (title, description, request_by, department, request_date, approval_date, approved_by, status) VALUES (?, ?, ?, ?, NOW(), NULL, NULL, 'Pending')";
                        ps = con.prepareStatement(insertQuery);
                        ps.setString(1, title);
                        ps.setString(2, description);
                        ps.setString(3, requestBy);
                        ps.setString(4, department);
                        ps.executeUpdate();
                    }

                    // Display existing requests
                    String selectQuery = "SELECT * FROM requests";
                    ps = con.prepareStatement(selectQuery);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        int sno = rs.getInt("sno");
                        title = rs.getString("title");
                        description = rs.getString("description");
                        requestBy = rs.getString("request_by");
                        Timestamp requestDate = rs.getTimestamp("request_date");
                        department = rs.getString("department");
                        Timestamp approvalDate = rs.getTimestamp("approval_date");
                        String approvedBy = rs.getString("approved_by");
                        String status = rs.getString("status");

                        out.println("<tr>");
                        out.println("<td>" + sno + "</td>");
                        out.println("<td>" + title + "</td>");
                        out.println("<td>" + description + "</td>");
                        out.println("<td>" + requestBy + "</td>");
                        out.println("<td>" + requestDate + "</td>");
                        out.println("<td>" + department + "</td>");
                        out.println("<td>" + approvalDate + "</td>");
                        out.println("<td>" + approvedBy + "</td>");
                        out.println("<td>" + status + "</td>");
                        out.println("</tr>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (rs != null)
                            rs.close();
                        if (ps != null)
                            ps.close();
                        if (con != null)
                            con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
