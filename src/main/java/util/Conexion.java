package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase utilitaria para obtener conexiones a la base de datos.
 * Uso: try (Connection conn = Conexion.get()) { ... }
 */
public class Conexion {

    private static final String URL    = "jdbc:mysql://localhost:3306/la_casa_de_mandi"
                                       + "?useSSL=false&serverTimezone=America/Panama&useUnicode=true&characterEncoding=UTF-8";
    private static final String USUARIO = "root";
    private static final String CLAVE   = "";   // Cambiar en producción

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL no encontrado", e);
        }
    }

    public static Connection get() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }
}
