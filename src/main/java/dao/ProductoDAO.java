package dao;

import modelo.Producto;
import modelo.Variante;
import util.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    /** Todos los productos disponibles de una categoría (con sus variantes). */
    public List<Producto> listarPorCategoria(String nombreCategoria) throws SQLException {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.id_producto, p.id_categoria, c.nombre AS categoria, " +
                     "p.nombre, p.descripcion, p.imagen " +
                     "FROM Producto p " +
                     "JOIN Categoria c ON p.id_categoria = c.id_categoria " +
                     "WHERE c.nombre = ? AND p.disponible = TRUE " +
                     "ORDER BY p.id_producto";

        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombreCategoria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Producto p = mapearProducto(rs);
                    p.setVariantes(listarVariantes(conn, p.getIdProducto()));
                    lista.add(p);
                }
            }
        }
        return lista;
    }

    /** Todos los productos disponibles (sin filtro de categoría). */
    public List<Producto> listarTodos() throws SQLException {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.id_producto, p.id_categoria, c.nombre AS categoria, " +
                     "p.nombre, p.descripcion, p.imagen " +
                     "FROM Producto p " +
                     "JOIN Categoria c ON p.id_categoria = c.id_categoria " +
                     "WHERE p.disponible = TRUE ORDER BY p.id_categoria, p.id_producto";

        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Producto p = mapearProducto(rs);
                p.setVariantes(listarVariantes(conn, p.getIdProducto()));
                lista.add(p);
            }
        }
        return lista;
    }

    /** Un producto por ID. */
    public Producto buscarPorId(int idProducto) throws SQLException {
        String sql = "SELECT p.id_producto, p.id_categoria, c.nombre AS categoria, " +
                     "p.nombre, p.descripcion, p.imagen " +
                     "FROM Producto p " +
                     "JOIN Categoria c ON p.id_categoria = c.id_categoria " +
                     "WHERE p.id_producto = ?";

        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idProducto);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Producto p = mapearProducto(rs);
                    p.setVariantes(listarVariantes(conn, p.getIdProducto()));
                    return p;
                }
            }
        }
        return null;
    }

    /** Variantes disponibles de un producto (reutiliza la conexión abierta). */
    private List<Variante> listarVariantes(Connection conn, int idProducto) throws SQLException {
        List<Variante> variantes = new ArrayList<>();
        String sql = "SELECT id_variante, id_producto, tamano, precio_base " +
                     "FROM Producto_Variante WHERE id_producto = ? AND disponible = TRUE " +
                     "ORDER BY precio_base";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idProducto);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Variante v = new Variante();
                    v.setIdVariante(rs.getInt("id_variante"));
                    v.setIdProducto(rs.getInt("id_producto"));
                    v.setTamano(rs.getString("tamano"));
                    v.setPrecioBase(rs.getBigDecimal("precio_base"));
                    v.setDisponible(true);
                    variantes.add(v);
                }
            }
        }
        return variantes;
    }

    /** Una variante por ID. */
    public Variante buscarVariantePorId(int idVariante) throws SQLException {
        String sql = "SELECT id_variante, id_producto, tamano, precio_base, disponible " +
                     "FROM Producto_Variante WHERE id_variante = ?";

        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idVariante);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Variante v = new Variante();
                    v.setIdVariante(rs.getInt("id_variante"));
                    v.setIdProducto(rs.getInt("id_producto"));
                    v.setTamano(rs.getString("tamano"));
                    v.setPrecioBase(rs.getBigDecimal("precio_base"));
                    v.setDisponible(rs.getBoolean("disponible"));
                    return v;
                }
            }
        }
        return null;
    }

    // ----------------------------------------------------------------
    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setIdProducto(rs.getInt("id_producto"));
        p.setIdCategoria(rs.getInt("id_categoria"));
        p.setNombreCategoria(rs.getString("categoria"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setImagen(rs.getString("imagen"));
        p.setDisponible(true);
        return p;
    }
}
