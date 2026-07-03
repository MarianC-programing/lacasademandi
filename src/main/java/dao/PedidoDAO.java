package dao;

import modelo.Pedido;
import util.Conexion;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {

    /** Pedidos de un cliente, más recientes primero. */
    public List<Pedido> listarPorCliente(int idCliente) throws SQLException {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT pe.id_pedido, pe.id_cliente, pe.fecha_pedido, pe.fecha_entrega, " +
                     "pe.descripcion_diseno, pe.estado, pe.precio_total, pe.precio_confirmado, " +
                     "pr.nombre AS nombre_producto, pv.tamano AS tamano_variante " +
                     "FROM Pedido pe " +
                     "JOIN Pedido_Variante ppv ON pe.id_pedido = ppv.id_pedido " +
                     "JOIN Producto_Variante pv  ON ppv.id_variante = pv.id_variante " +
                     "JOIN Producto pr            ON pv.id_producto = pr.id_producto " +
                     "WHERE pe.id_cliente = ? " +
                     "ORDER BY pe.fecha_pedido DESC";

        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        return lista;
    }

    /** Todos los pedidos (para el admin), con nombre del cliente. */
    public List<Pedido> listarTodos(String filtroEstado) throws SQLException {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT pe.id_pedido, pe.id_cliente, cl.nombre AS nombre_cliente, " +
                     "pe.fecha_pedido, pe.fecha_entrega, pe.descripcion_diseno, " +
                     "pe.estado, pe.precio_total, pe.precio_confirmado, " +
                     "pr.nombre AS nombre_producto, pv.tamano AS tamano_variante " +
                     "FROM Pedido pe " +
                     "JOIN Cliente cl             ON pe.id_cliente = cl.id_cliente " +
                     "JOIN Pedido_Variante ppv    ON pe.id_pedido = ppv.id_pedido " +
                     "JOIN Producto_Variante pv   ON ppv.id_variante = pv.id_variante " +
                     "JOIN Producto pr            ON pv.id_producto = pr.id_producto " +
                     (filtroEstado != null && !filtroEstado.isEmpty() ? "WHERE pe.estado = ? " : "") +
                     "ORDER BY pe.fecha_pedido DESC";

        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (filtroEstado != null && !filtroEstado.isEmpty()) ps.setString(1, filtroEstado);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido p = mapear(rs);
                    try { p.setNombreCliente(rs.getString("nombre_cliente")); } catch (SQLException ignored) {}
                    lista.add(p);
                }
            }
        }
        return lista;
    }

    /** Un pedido por ID (incluye nombre de cliente y producto). */
    public Pedido buscarPorId(int idPedido) throws SQLException {
        String sql = "SELECT pe.id_pedido, pe.id_cliente, cl.nombre AS nombre_cliente, " +
                     "pe.fecha_pedido, pe.fecha_entrega, pe.descripcion_diseno, " +
                     "pe.estado, pe.precio_total, pe.precio_confirmado, " +
                     "pr.nombre AS nombre_producto, pv.tamano AS tamano_variante " +
                     "FROM Pedido pe " +
                     "JOIN Cliente cl             ON pe.id_cliente = cl.id_cliente " +
                     "JOIN Pedido_Variante ppv    ON pe.id_pedido = ppv.id_pedido " +
                     "JOIN Producto_Variante pv   ON ppv.id_variante = pv.id_variante " +
                     "JOIN Producto pr            ON pv.id_producto = pr.id_producto " +
                     "WHERE pe.id_pedido = ?";

        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Pedido p = mapear(rs);
                    try { p.setNombreCliente(rs.getString("nombre_cliente")); } catch (SQLException ignored) {}
                    return p;
                }
            }
        }
        return null;
    }

    /**
     * Crea un pedido nuevo. Devuelve el ID generado.
     * idVariante y cantidad son los datos de Pedido_Variante.
     */
    public int crear(Pedido pedido, int idVariante, int cantidad, BigDecimal precioUnitario)
            throws SQLException {

        String sqlPedido = "INSERT INTO Pedido " +
                "(id_cliente, fecha_entrega, descripcion_diseno, estado, precio_total, precio_confirmado) " +
                "VALUES (?, ?, ?, 'Pendiente', ?, FALSE)";

        try (Connection conn = Conexion.get()) {
            conn.setAutoCommit(false);
            try {
                int idPedido;
                try (PreparedStatement ps = conn.prepareStatement(sqlPedido, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, pedido.getIdCliente());
                    ps.setDate(2, pedido.getFechaEntrega());
                    ps.setString(3, pedido.getDescripcionDiseno());
                    ps.setBigDecimal(4, pedido.getPrecioTotal());
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) throw new SQLException("No se generó ID de pedido");
                        idPedido = keys.getInt(1);
                    }
                }

                String sqlVariante = "INSERT INTO Pedido_Variante (id_pedido, id_variante, cantidad, precio_unitario) " +
                                     "VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps2 = conn.prepareStatement(sqlVariante)) {
                    ps2.setInt(1, idPedido);
                    ps2.setInt(2, idVariante);
                    ps2.setInt(3, cantidad);
                    ps2.setBigDecimal(4, precioUnitario);
                    ps2.executeUpdate();
                }

                conn.commit();
                return idPedido;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    /** Cambia el estado de un pedido y deja constancia en el historial de cambios. */
    public void actualizarEstado(int idPedido, String nuevoEstado) throws SQLException {
        String sqlActual = "SELECT estado FROM Pedido WHERE id_pedido = ?";
        String sqlUpdate = "UPDATE Pedido SET estado = ? WHERE id_pedido = ?";
        String sqlHist   = "INSERT INTO Historial_Estado (id_pedido, estado_anterior, estado_nuevo) VALUES (?, ?, ?)";

        try (Connection conn = Conexion.get()) {
            String estadoAnterior = null;
            try (PreparedStatement ps = conn.prepareStatement(sqlActual)) {
                ps.setInt(1, idPedido);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) estadoAnterior = rs.getString(1);
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setString(1, nuevoEstado);
                ps.setInt(2, idPedido);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlHist)) {
                ps.setInt(1, idPedido);
                ps.setString(2, estadoAnterior);
                ps.setString(3, nuevoEstado);
                ps.executeUpdate();
            }
        }
    }

    /**
     * Historial de cambios de estado de un pedido, mas reciente primero.
     * Retorna String[]: {estado_anterior, estado_nuevo, fecha_cambio}
     */
    public List<String[]> listarHistorial(int idPedido) throws SQLException {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT estado_anterior, estado_nuevo, fecha_cambio " +
                     "FROM Historial_Estado WHERE id_pedido = ? ORDER BY fecha_cambio DESC";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new String[]{
                        rs.getString("estado_anterior"),
                        rs.getString("estado_nuevo"),
                        rs.getTimestamp("fecha_cambio").toString()
                    });
                }
            }
        }
        return lista;
    }

    /** Fija el precio total del admin y lo marca como confirmado. */
    public void confirmarPrecio(int idPedido, BigDecimal precio) throws SQLException {
        String sql = "UPDATE Pedido SET precio_total = ?, precio_confirmado = TRUE WHERE id_pedido = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, precio);
            ps.setInt(2, idPedido);
            ps.executeUpdate();
        }
    }

    /** Contadores para el dashboard del admin. */
    public int contarPorEstado(String estado) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Pedido WHERE estado = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ----------------------------------------------------------------
    private Pedido mapear(ResultSet rs) throws SQLException {
        Pedido p = new Pedido();
        p.setIdPedido(rs.getInt("id_pedido"));
        p.setIdCliente(rs.getInt("id_cliente"));
        p.setFechaPedido(rs.getTimestamp("fecha_pedido"));
        p.setFechaEntrega(rs.getDate("fecha_entrega"));
        p.setDescripcionDiseno(rs.getString("descripcion_diseno"));
        p.setEstado(rs.getString("estado"));
        p.setPrecioTotal(rs.getBigDecimal("precio_total"));
        p.setPrecioConfirmado(rs.getBoolean("precio_confirmado"));
        p.setNombreProducto(rs.getString("nombre_producto"));
        p.setTamanoVariante(rs.getString("tamano_variante"));
        return p;
    }
}
