<%@ page import="com.database.DbConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String username = request.getParameter("username");
    String department = request.getParameter("department");

    DbConnection.insertRequest(title, description, username, department);

    response.sendRedirect("management.jsp");
%>
