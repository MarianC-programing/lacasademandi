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

    /** Lista TODOS los productos (incluyendo no disponibles) para el admin. */
    public List<Producto> listarTodosAdmin() throws SQLException {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.id_producto, p.id_categoria, c.nombre AS categoria, " +
                     "p.nombre, p.descripcion, p.imagen, p.disponible " +
                     "FROM Producto p " +
                     "JOIN Categoria c ON p.id_categoria = c.id_categoria " +
                     "ORDER BY p.id_categoria, p.id_producto";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Producto p = mapearProducto(rs);
                p.setDisponible(rs.getBoolean("disponible"));
                p.setVariantes(listarVariantesTodas(conn, p.getIdProducto()));
                lista.add(p);
            }
        }
        return lista;
    }

    /** Crea un producto nuevo. Devuelve el ID generado. */
    public int crear(Producto p) throws SQLException {
        String sql = "INSERT INTO Producto (id_categoria, nombre, descripcion, imagen, disponible) " +
                     "VALUES (?, ?, ?, ?, TRUE)";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getIdCategoria());
            ps.setString(2, p.getNombre());
            ps.setString(3, p.getDescripcion());
            ps.setString(4, p.getImagen());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return -1;
    }

    /** Actualiza nombre, descripción e imagen de un producto. */
    public void actualizar(Producto p) throws SQLException {
        String sql = "UPDATE Producto SET nombre=?, descripcion=?, imagen=?, id_categoria=? WHERE id_producto=?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setString(3, p.getImagen());
            ps.setInt(4, p.getIdCategoria());
            ps.setInt(5, p.getIdProducto());
            ps.executeUpdate();
        }
    }

    /** Activa o desactiva un producto (soft delete). */
    public void toggleDisponible(int idProducto, boolean disponible) throws SQLException {
        String sql = "UPDATE Producto SET disponible=? WHERE id_producto=?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, disponible);
            ps.setInt(2, idProducto);
            ps.executeUpdate();
        }
    }

    /** Crea una variante nueva para un producto. */
    public void crearVariante(Variante v) throws SQLException {
        String sql = "INSERT INTO Producto_Variante (id_producto, tamano, precio_base, disponible) VALUES (?,?,?,TRUE)";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, v.getIdProducto());
            ps.setString(2, v.getTamano());
            ps.setBigDecimal(3, v.getPrecioBase());
            ps.executeUpdate();
        }
    }

    /** Actualiza precio de una variante. */
    public void actualizarVariante(Variante v) throws SQLException {
        String sql = "UPDATE Producto_Variante SET tamano=?, precio_base=?, disponible=? WHERE id_variante=?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getTamano());
            ps.setBigDecimal(2, v.getPrecioBase());
            ps.setBoolean(3, v.isDisponible());
            ps.setInt(4, v.getIdVariante());
            ps.executeUpdate();
        }
    }

    /** Lista categorías disponibles. */
    public List<String[]> listarCategorias() throws SQLException {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT id_categoria, nombre FROM Categoria ORDER BY nombre";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(new String[]{rs.getString(1), rs.getString(2)});
        }
        return lista;
    }

    /** Todas las variantes (incluyendo no disponibles) — para admin. */
    private List<Variante> listarVariantesTodas(Connection conn, int idProducto) throws SQLException {
        List<Variante> variantes = new ArrayList<>();
        String sql = "SELECT id_variante, id_producto, tamano, precio_base, disponible " +
                     "FROM Producto_Variante WHERE id_producto = ? ORDER BY precio_base";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idProducto);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Variante v = new Variante();
                    v.setIdVariante(rs.getInt("id_variante"));
                    v.setIdProducto(rs.getInt("id_producto"));
                    v.setTamano(rs.getString("tamano"));
                    v.setPrecioBase(rs.getBigDecimal("precio_base"));
                    v.setDisponible(rs.getBoolean("disponible"));
                    variantes.add(v);
                }
            }
        }
        return variantes;
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
