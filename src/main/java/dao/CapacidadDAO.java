package dao;

import util.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CapacidadDAO {

    /** Obtiene la capacidad de una fecha. Si no existe la crea con el límite por defecto (5). */
    public int[] getCapacidad(String fecha) throws SQLException {
        // Retorna [pedidos_confirmados, limite_diario]
        String sqlSelect = "SELECT pedidos_confirmados, limite_diario FROM Capacidad_Entrega WHERE fecha = ?";
        String sqlInsert = "INSERT INTO Capacidad_Entrega (fecha, pedidos_confirmados, limite_diario) VALUES (?, 0, 5)";

        try (Connection conn = Conexion.get()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
                ps.setDate(1, Date.valueOf(fecha));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return new int[]{ rs.getInt(1), rs.getInt(2) };
                }
            }
            // No existe, la creamos
            try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                ps.setDate(1, Date.valueOf(fecha));
                ps.executeUpdate();
            }
            return new int[]{0, 5};
        }
    }

    /** Lista los próximos N días con su capacidad. */
    public List<int[]> listarProximosDias(int dias) throws SQLException {
        List<int[]> lista = new ArrayList<>();
        String sql = "SELECT fecha, pedidos_confirmados, limite_diario " +
                     "FROM Capacidad_Entrega " +
                     "WHERE fecha >= CURDATE() " +
                     "ORDER BY fecha LIMIT ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dias);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new int[]{
                        rs.getDate("fecha").toLocalDate().getDayOfMonth(),
                        rs.getInt("pedidos_confirmados"),
                        rs.getInt("limite_diario"),
                        (int) rs.getDate("fecha").toLocalDate().toEpochDay()
                    });
                }
            }
        }
        return lista;
    }

    /**
     * Lista los próximos N días con nombre de fecha para la vista.
     * Retorna String[]: {fechaISO, pedidos_confirmados, limite_diario}
     */
    public List<String[]> listarCalendario(int dias) throws SQLException {
        // Genera filas para los próximos N días, creándolas si no existen
        List<String[]> lista = new ArrayList<>();
        String sqlUpsert = "INSERT INTO Capacidad_Entrega (fecha, pedidos_confirmados, limite_diario) " +
                           "VALUES (?, 0, 5) ON DUPLICATE KEY UPDATE fecha=fecha";
        String sqlSelect = "SELECT fecha, pedidos_confirmados, limite_diario " +
                           "FROM Capacidad_Entrega WHERE fecha >= CURDATE() ORDER BY fecha LIMIT ?";

        try (Connection conn = Conexion.get()) {
            // Asegurar que existan los próximos N días
            java.time.LocalDate hoy = java.time.LocalDate.now();
            for (int i = 0; i < dias; i++) {
                try (PreparedStatement ps = conn.prepareStatement(sqlUpsert)) {
                    ps.setDate(1, Date.valueOf(hoy.plusDays(i)));
                    ps.executeUpdate();
                }
            }
            // Leer
            try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
                ps.setInt(1, dias);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        lista.add(new String[]{
                            rs.getDate("fecha").toString(),
                            String.valueOf(rs.getInt("pedidos_confirmados")),
                            String.valueOf(rs.getInt("limite_diario"))
                        });
                    }
                }
            }
        }
        return lista;
    }

    /** Actualiza el límite diario de una fecha. */
    public void actualizarLimite(String fecha, int limite) throws SQLException {
        String sql = "UPDATE Capacidad_Entrega SET limite_diario = ? WHERE fecha = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limite);
            ps.setDate(2, Date.valueOf(fecha));
            ps.executeUpdate();
        }
    }

    /** Incrementa el contador de pedidos confirmados para una fecha. */
    public void incrementar(String fecha) throws SQLException {
        String sql = "UPDATE Capacidad_Entrega SET pedidos_confirmados = pedidos_confirmados + 1 WHERE fecha = ?";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(fecha));
            ps.executeUpdate();
        }
    }

    /** Verifica si una fecha tiene disponibilidad. */
    public boolean hayDisponibilidad(String fecha) throws SQLException {
        int[] cap = getCapacidad(fecha);
        return cap[0] < cap[1];
    }

    /** Lista todas las fechas bloqueadas (pedidos >= límite) en los próximos 60 días. */
    public List<String> fechasBloqueadas() throws SQLException {
        List<String> lista = new ArrayList<>();
        String sql = "SELECT fecha FROM Capacidad_Entrega " +
                     "WHERE fecha >= CURDATE() AND pedidos_confirmados >= limite_diario " +
                     "ORDER BY fecha";
        try (Connection conn = Conexion.get();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(rs.getDate("fecha").toString());
        }
        return lista;
    }
}
