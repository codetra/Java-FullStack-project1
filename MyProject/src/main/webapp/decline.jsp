<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.database.DbConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Decline Page</title>
    <%@ include file="cdn.jsp" %>
</head>
<body>
    <div class="container">
        <h2>Decline Page</h2>
        <% 
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                con = DbConnection.takeConnection();
                int sno = Integer.parseInt(request.getParameter("sno"));
                String department = request.getParameter("department");
                
                String username = (String) session.getAttribute("username");

               
                String query = "UPDATE requests SET approval_date = ?, approved_by = ?, status = ? WHERE sno = ?";
                ps = con.prepareStatement(query);
                ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
                ps.setString(2, "Pavitra"); 
                ps.setString(3, "Declined");
                ps.setInt(4, sno);
                ps.executeUpdate();

              
                response.sendRedirect(department + ".jsp");
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
    </div>
</body>
</html>
