<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    ============================================
    La Casa de Mandi — Conexion a MySQL
    ============================================
    Include este archivo en cada JSP que necesite BD:
    <%@ include file="WEB-INF/conexion.jsp" %>
    Variables disponibles: conexion
--%>

<%@ page import="java.sql.*, javax.sql.*" %>

<%
    // Configuracion de conexion a la base de datos
    final String DB_HOST = "localhost";
    final String DB_PORT = "3306";
    final String DB_NAME = "la_casa_de_mandi";
    final String DB_USER = "root";
    final String DB_PASS = "";

    Connection conexion = null;

    try {
        // Cargar driver JDBC de MySQL
        Class.forName("com.mysql.cj.jdbc.Driver");

        // URL de conexion
        String url = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
                   + "?useSSL=false&serverTimezone=America/Panama&characterEncoding=UTF-8";

        // Establecer conexion
        conexion = DriverManager.getConnection(url, DB_USER, DB_PASS);

    } catch (ClassNotFoundException e) {
        out.println("<p style='color:red;'>Error: Driver MySQL no encontrado</p>");
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error de conexion: " + e.getMessage() + "</p>");
    }
%>
