package dao;

import util.Conexion;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReporteDAO {

    /** Ingresos totales confirmados (abonos + pagos finales). */
    public BigDecimal totalIngresos() throws SQLException {
        String sql = "SELECT COALESCE(SUM(a.monto),0) + COALESCE((SELECT SUM(monto) FROM Pago_Final WHERE confirmado=TRUE),0) " +
                     "FROM Abono a WHERE a.confirmado = TRUE";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }

    /** Ingresos del mes actual. */
    public BigDecimal ingresosMesActual() throws SQLException {
        String sql = "SELECT COALESCE(SUM(monto),0) FROM (" +
                     "  SELECT monto FROM Abono WHERE confirmado=TRUE AND MONTH(fecha_confirmacion)=MONTH(CURDATE()) AND YEAR(fecha_confirmacion)=YEAR(CURDATE()) " +
                     "  UNION ALL " +
                     "  SELECT monto FROM Pago_Final WHERE confirmado=TRUE AND MONTH(fecha_confirmacion)=MONTH(CURDATE()) AND YEAR(fecha_confirmacion)=YEAR(CURDATE())" +
                     ") t";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }

    /** Contadores de pedidos por estado. */
    public List<String[]> pedidosPorEstado() throws SQLException {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT estado, COUNT(*) AS total FROM Pedido GROUP BY estado ORDER BY total DESC";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(new String[]{ rs.getString(1), String.valueOf(rs.getInt(2)) });
        }
        return lista;
    }

    /** Top 5 productos más solicitados. */
    public List<String[]> topProductos() throws SQLException {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT pr.nombre, SUM(pv.cantidad) AS total_pedidos, " +
                     "SUM(pv.cantidad * pv.precio_unitario) AS ingresos " +
                     "FROM Pedido_Variante pv " +
                     "JOIN Producto_Variante pvt ON pv.id_variante = pvt.id_variante " +
                     "JOIN Producto pr ON pvt.id_producto = pr.id_producto " +
                     "GROUP BY pr.id_producto, pr.nombre " +
                     "ORDER BY total_pedidos DESC LIMIT 5";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(new String[]{
                rs.getString("nombre"),
                String.valueOf(rs.getInt("total_pedidos")),
                String.format("%.2f", rs.getBigDecimal("ingresos"))
            });
        }
        return lista;
    }

    /** Ingresos por mes (últimos 6 meses). */
    public List<String[]> ingresosPorMes() throws SQLException {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(fecha_confirmacion,'%Y-%m') AS mes, " +
                     "SUM(monto) AS total " +
                     "FROM (" +
                     "  SELECT fecha_confirmacion, monto FROM Abono WHERE confirmado=TRUE " +
                     "  UNION ALL " +
                     "  SELECT fecha_confirmacion, monto FROM Pago_Final WHERE confirmado=TRUE" +
                     ") t " +
                     "WHERE fecha_confirmacion >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                     "GROUP BY mes ORDER BY mes";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(new String[]{
                rs.getString("mes"),
                String.format("%.2f", rs.getBigDecimal("total"))
            });
        }
        return lista;
    }

    /** Total de clientes registrados. */
    public int totalClientes() throws SQLException {
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM Cliente");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Total de pedidos. */
    public int totalPedidos() throws SQLException {
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM Pedido");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Métodos de pago más usados. */
    public List<String[]> metodosPago() throws SQLException {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT metodo_pago, COUNT(*) AS total FROM (" +
                     "  SELECT metodo_pago FROM Abono WHERE confirmado=TRUE " +
                     "  UNION ALL " +
                     "  SELECT metodo_pago FROM Pago_Final WHERE confirmado=TRUE" +
                     ") t GROUP BY metodo_pago ORDER BY total DESC";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(new String[]{ rs.getString(1), String.valueOf(rs.getInt(2)) });
        }
        return lista;
    }
}
