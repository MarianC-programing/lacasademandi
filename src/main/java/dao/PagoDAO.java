package dao;

import modelo.Abono;
import modelo.PagoFinal;
import util.Conexion;

import java.math.BigDecimal;
import java.sql.*;

public class PagoDAO {

    // ================================================================
    // ABONO
    // ================================================================

    /** Busca el abono de un pedido (1:1). Devuelve null si no existe. */
    public Abono buscarAbonoPorPedido(int idPedido) throws SQLException {
        String sql = "SELECT * FROM Abono WHERE id_pedido = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapearAbono(rs);
            }
        }
        return null;
    }

    /** Registra un abono nuevo. Solo se puede registrar uno por pedido. */
    public void registrarAbono(Abono a) throws SQLException {
        String sql = "INSERT INTO Abono (id_pedido, monto, porcentaje, fecha_pago, metodo_pago, referencia, confirmado) " +
                     "VALUES (?, ?, ?, ?, ?, ?, FALSE)";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, a.getIdPedido());
            ps.setBigDecimal(2, a.getMonto());
            ps.setBigDecimal(3, a.getPorcentaje());
            ps.setDate(4, a.getFechaPago());
            ps.setString(5, a.getMetodoPago());
            ps.setString(6, a.getReferencia());
            ps.executeUpdate();
        }
    }

    /** Admin confirma el abono de un pedido. */
    public void confirmarAbono(int idPedido) throws SQLException {
        String sql = "UPDATE Abono SET confirmado = TRUE, fecha_confirmacion = CURDATE() WHERE id_pedido = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            ps.executeUpdate();
        }
    }

    /** Admin rechaza/elimina el abono para que el cliente lo vuelva a registrar. */
    public void rechazarAbono(int idPedido) throws SQLException {
        String sql = "DELETE FROM Abono WHERE id_pedido = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            ps.executeUpdate();
        }
    }

    // ================================================================
    // PAGO FINAL
    // ================================================================

    /** Busca el pago final de un pedido (1:1). Devuelve null si no existe. */
    public PagoFinal buscarPagoFinalPorPedido(int idPedido) throws SQLException {
        String sql = "SELECT * FROM Pago_Final WHERE id_pedido = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapearPagoFinal(rs);
            }
        }
        return null;
    }

    /** Registra el pago final de un pedido. */
    public void registrarPagoFinal(PagoFinal p) throws SQLException {
        String sql = "INSERT INTO Pago_Final (id_pedido, monto, fecha_pago, metodo_pago, referencia, confirmado) " +
                     "VALUES (?, ?, ?, ?, ?, FALSE)";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getIdPedido());
            ps.setBigDecimal(2, p.getMonto());
            ps.setDate(3, p.getFechaPago());
            ps.setString(4, p.getMetodoPago());
            ps.setString(5, p.getReferencia());
            ps.executeUpdate();
        }
    }

    /** Admin confirma el pago final y cambia el pedido a Listo. */
    public void confirmarPagoFinal(int idPedido) throws SQLException {
        String sqlPago   = "UPDATE Pago_Final SET confirmado = TRUE, fecha_confirmacion = CURDATE() WHERE id_pedido = ?";
        String sqlPedido = "UPDATE Pedido SET estado = 'Listo' WHERE id_pedido = ?";
        try (Connection conn = Conexion.get()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(sqlPago)) {
                    ps.setInt(1, idPedido); ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(sqlPedido)) {
                    ps.setInt(1, idPedido); ps.executeUpdate();
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback(); throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    /** Admin rechaza el pago final para que el cliente lo vuelva a registrar. */
    public void rechazarPagoFinal(int idPedido) throws SQLException {
        String sql = "DELETE FROM Pago_Final WHERE id_pedido = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            ps.executeUpdate();
        }
    }

    /** Contadores para el resumen mensual del dashboard. */
    public BigDecimal totalAbonosConfirmados() throws SQLException {
        return sumar("SELECT COALESCE(SUM(monto),0) FROM Abono WHERE confirmado = TRUE");
    }
    public BigDecimal totalPagosFinalesConfirmados() throws SQLException {
        return sumar("SELECT COALESCE(SUM(monto),0) FROM Pago_Final WHERE confirmado = TRUE");
    }
    public BigDecimal totalPendienteCobro() throws SQLException {
        return sumar("SELECT COALESCE(SUM(pe.precio_total),0) FROM Pedido pe " +
                     "WHERE pe.estado NOT IN ('Entregado','Cancelado') " +
                     "AND NOT EXISTS (SELECT 1 FROM Pago_Final pf WHERE pf.id_pedido = pe.id_pedido AND pf.confirmado = TRUE)");
    }

    // ================================================================
    // PRIVADOS
    // ================================================================

    private BigDecimal sumar(String sql) throws SQLException {
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }

    private Abono mapearAbono(ResultSet rs) throws SQLException {
        Abono a = new Abono();
        a.setIdAbono(rs.getInt("id_abono"));
        a.setIdPedido(rs.getInt("id_pedido"));
        a.setMonto(rs.getBigDecimal("monto"));
        a.setPorcentaje(rs.getBigDecimal("porcentaje"));
        a.setFechaPago(rs.getDate("fecha_pago"));
        a.setMetodoPago(rs.getString("metodo_pago"));
        a.setReferencia(rs.getString("referencia"));
        a.setConfirmado(rs.getBoolean("confirmado"));
        a.setFechaConfirmacion(rs.getDate("fecha_confirmacion"));
        return a;
    }

    private PagoFinal mapearPagoFinal(ResultSet rs) throws SQLException {
        PagoFinal p = new PagoFinal();
        p.setIdPagoFinal(rs.getInt("id_pago_final"));
        p.setIdPedido(rs.getInt("id_pedido"));
        p.setMonto(rs.getBigDecimal("monto"));
        p.setFechaPago(rs.getDate("fecha_pago"));
        p.setMetodoPago(rs.getString("metodo_pago"));
        p.setReferencia(rs.getString("referencia"));
        p.setConfirmado(rs.getBoolean("confirmado"));
        p.setFechaConfirmacion(rs.getDate("fecha_confirmacion"));
        return p;
    }
}
