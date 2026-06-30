package dao;

import modelo.Administrador;
import util.Conexion;

import java.sql.*;

public class AdministradorDAO {

    /** Busca un administrador por correo (los admins solo entran por correo). */
    public Administrador buscarPorCorreo(String correo) throws SQLException {
        String sql = "SELECT id_admin, nombre, correo, password FROM Administrador WHERE correo = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Administrador a = new Administrador();
                    a.setIdAdmin(rs.getInt("id_admin"));
                    a.setNombre(rs.getString("nombre"));
                    a.setCorreo(rs.getString("correo"));
                    a.setPassword(rs.getString("password"));
                    return a;
                }
            }
        }
        return null;
    }
}
