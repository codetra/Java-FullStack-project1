<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Legal Page</title>
    <%@ include file="cdn.jsp" %>
    <%@ page import="java.sql.*, java.util.*, com.database.DbConnection" %>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
            color: #343a40; 
        }
        .container {
            max-width: 1000px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #007bff;
            margin-bottom: 20px;
        }
        .navbar {
            background-color: #007bff;
            padding: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar-brand {
            color: #fff;
            font-size: 24px;
            font-weight: bold;
        }
        .logout-btn {
            color: #fff;
            background-color: #dc3545;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }
        .logout-btn:hover {
            background-color: #c82333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #dee2e6;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: #fff;
        }
        .btn-container {
            display: flex;
            justify-content: space-between;
        }
        .btn-container form {
            margin: 0;
        }
        .btn-container button {
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <span class="navbar-brand">Legal Page</span>
        <form action="login.jsp" method="post">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </nav>
    <div class="container">
        <h2>Legal Page</h2>
        <table>
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
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    con = DbConnection.takeConnection();
                    String query = "SELECT * FROM requests WHERE department = 'legal'";
                    ps = con.prepareStatement(query);
                    rs = ps.executeQuery();

                    while(rs.next()) {
                        int sno = rs.getInt("sno");
                        String title = rs.getString("title");
                        String description = rs.getString("description");
                        String requestBy = rs.getString("request_by");
                        Timestamp requestDate = rs.getTimestamp("request_date");
                        String department = rs.getString("department"); // Fetch department
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
                        out.println("<td class=\"btn-container\">");
                        if (status.equals("Pending")) {
                            
                            out.println("<form action=\"\" method=\"post\">");
                            out.println("<input type=\"hidden\" name=\"sno\" value=\"" + sno + "\">");
                            out.println("<input type=\"hidden\" name=\"action\" value=\"approve\">");
                            out.println("<button type=\"submit\" class=\"btn btn-success\">Approve</button>");
                            out.println("</form>");
                           
                            out.println("<form action=\"\" method=\"post\">");
                            out.println("<input type=\"hidden\" name=\"sno\" value=\"" + sno + "\">");
                            out.println("<input type=\"hidden\" name=\"action\" value=\"decline\">");
                            out.println("<button type=\"submit\" class=\"btn btn-danger\">Decline</button>");
                            out.println("</form>");
                        }
                        out.println("</td>");
                        out.println("</tr>");
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                %>
            </tbody>
        </table>
    </div>

   
    <% 
        if (request.getMethod().equals("POST")) {
            String action = request.getParameter("action");
            if (action != null && (action.equals("approve") || action.equals("decline"))) {
                int sno = Integer.parseInt(request.getParameter("sno"));
                try {
                    con = DbConnection.takeConnection();
                    String updateQuery = "";
                    if (action.equals("approve")) {
                        updateQuery = "UPDATE requests SET approval_date = ?, approved_by = ?, status = 'Approved' WHERE sno = ?";
                    } else if (action.equals("decline")) {
                    	updateQuery = "UPDATE requests SET approval_date = ?, approved_by = ?, status = 'Decline' WHERE sno = ?";
                    }
                    ps = con.prepareStatement(updateQuery);
                    java.util.Date d = new java.util.Date();
                    ps.setTimestamp(1, new Timestamp(d.getTime()));
                    ps.setString(2, "Pavitra"); 
                    ps.setInt(3, sno);
                    ps.executeUpdate();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                
                response.sendRedirect("legal.jsp");
            }
        }
    %>
</body>
</html>
