package modelo;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Pedido {
    private int        idPedido;
    private int        idCliente;
    private String     nombreCliente;
    private Timestamp  fechaPedido;
    private Date       fechaEntrega;
    private String     descripcionDiseno;
    private String     estado;
    private BigDecimal precioTotal;
    private boolean    precioConfirmado;

    // Datos de producto (para listados)
    private String     nombreProducto;
    private String     tamanoVariante;

    public Pedido() {}

    public int        getIdPedido()          { return idPedido; }
    public int        getIdCliente()         { return idCliente; }
    public String     getNombreCliente()     { return nombreCliente; }
    public Timestamp  getFechaPedido()       { return fechaPedido; }
    public Date       getFechaEntrega()      { return fechaEntrega; }
    public String     getDescripcionDiseno() { return descripcionDiseno; }
    public String     getEstado()            { return estado; }
    public BigDecimal getPrecioTotal()       { return precioTotal; }
    public boolean    isPrecioConfirmado()   { return precioConfirmado; }
    public String     getNombreProducto()    { return nombreProducto; }
    public String     getTamanoVariante()    { return tamanoVariante; }

    public void setIdPedido(int idPedido)                   { this.idPedido = idPedido; }
    public void setIdCliente(int idCliente)                 { this.idCliente = idCliente; }
    public void setNombreCliente(String nombreCliente)      { this.nombreCliente = nombreCliente; }
    public void setFechaPedido(Timestamp fechaPedido)       { this.fechaPedido = fechaPedido; }
    public void setFechaEntrega(Date fechaEntrega)          { this.fechaEntrega = fechaEntrega; }
    public void setDescripcionDiseno(String descripcion)    { this.descripcionDiseno = descripcion; }
    public void setEstado(String estado)                    { this.estado = estado; }
    public void setPrecioTotal(BigDecimal precioTotal)      { this.precioTotal = precioTotal; }
    public void setPrecioConfirmado(boolean conf)           { this.precioConfirmado = conf; }
    public void setNombreProducto(String nombreProducto)    { this.nombreProducto = nombreProducto; }
    public void setTamanoVariante(String tamanoVariante)    { this.tamanoVariante = tamanoVariante; }
}
