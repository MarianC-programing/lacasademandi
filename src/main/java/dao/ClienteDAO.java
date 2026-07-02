package dao;

import modelo.Cliente;
import util.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    /** Lista todos los clientes registrados con su conteo de pedidos. */
    public List<Cliente> listarTodos() throws SQLException {
        List<Cliente> lista = new java.util.ArrayList<>();
        String sql = "SELECT id_cliente, nombre, telefono, whatsapp, correo, fecha_registro " +
                     "FROM Cliente ORDER BY fecha_registro DESC";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Cliente c = new Cliente();
                c.setIdCliente(rs.getInt("id_cliente"));
                c.setNombre(rs.getString("nombre"));
                c.setTelefono(rs.getString("telefono"));
                c.setWhatsapp(rs.getString("whatsapp"));
                c.setCorreo(rs.getString("correo"));
                lista.add(c);
            }
        }
        return lista;
    }

    /** Cuenta los pedidos de un cliente. */
    public int contarPedidos(int idCliente) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Pedido WHERE id_cliente = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Busca un cliente por correo o por WhatsApp. */
    public Cliente buscarPorCorreo(String correo) throws SQLException {
        return buscarPor("correo", correo);
    }

    public Cliente buscarPorWhatsapp(String whatsapp) throws SQLException {
        return buscarPor("whatsapp", whatsapp);
    }

    public Cliente buscarPorId(int idCliente) throws SQLException {
        String sql = "SELECT id_cliente, nombre, telefono, whatsapp, correo, password " +
                     "FROM Cliente WHERE id_cliente = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        }
        return null;
    }

    /** Registra un cliente nuevo. Devuelve el ID generado. */
    public int registrar(Cliente c) throws SQLException {
        String sql = "INSERT INTO Cliente (nombre, telefono, whatsapp, correo, password) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getTelefono());
            ps.setString(3, c.getWhatsapp());
            ps.setString(4, c.getCorreo());
            ps.setString(5, c.getPassword());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return -1;
    }

    /** Verifica si ya existe un correo o WhatsApp registrado. */
    public boolean existeCorreo(String correo) throws SQLException {
        return existe("correo", correo);
    }

    public boolean existeWhatsapp(String whatsapp) throws SQLException {
        return existe("whatsapp", whatsapp);
    }

    /** Actualiza nombre, teléfono, WhatsApp y correo de un cliente. */
    public void actualizar(Cliente c) throws SQLException {
        String sql = "UPDATE Cliente SET nombre=?, telefono=?, whatsapp=?, correo=? " +
                     "WHERE id_cliente=?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getTelefono());
            ps.setString(3, c.getWhatsapp());
            ps.setString(4, c.getCorreo());
            ps.setInt(5, c.getIdCliente());
            ps.executeUpdate();
        }
    }

    // ----------------------------------------------------------------
    private Cliente buscarPor(String columna, String valor) throws SQLException {
        String sql = "SELECT id_cliente, nombre, telefono, whatsapp, correo, password " +
                     "FROM Cliente WHERE " + columna + " = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, valor);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        }
        return null;
    }

    private boolean existe(String columna, String valor) throws SQLException {
        String sql = "SELECT 1 FROM Cliente WHERE " + columna + " = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, valor);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private Cliente mapear(ResultSet rs) throws SQLException {
        Cliente c = new Cliente();
        c.setIdCliente(rs.getInt("id_cliente"));
        c.setNombre(rs.getString("nombre"));
        c.setTelefono(rs.getString("telefono"));
        c.setWhatsapp(rs.getString("whatsapp"));
        c.setCorreo(rs.getString("correo"));
        c.setPassword(rs.getString("password"));
        return c;
    }
}
