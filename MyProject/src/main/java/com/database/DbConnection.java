package com.database;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DbConnection {
    public static Connection takeConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/batch1", "root", "2511");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }

    public static void insertRequest(String title, String description, String username, String department) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = takeConnection();
            String insertQuery = "INSERT INTO requests (title, description, request_by, department, request_date, approval_date, approved_by, status) VALUES (?, ?, ?, ?, NOW(), NULL, NULL, 'Pending')";
            ps = con.prepareStatement(insertQuery);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, username);
            ps.setString(4, department);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
