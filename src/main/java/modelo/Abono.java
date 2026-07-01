package modelo;

import java.math.BigDecimal;
import java.sql.Date;

public class Abono {
    private int        idAbono;
    private int        idPedido;
    private BigDecimal monto;
    private BigDecimal porcentaje;
    private Date       fechaPago;
    private String     metodoPago;
    private String     referencia;
    private boolean    confirmado;
    private Date       fechaConfirmacion;

    public Abono() {}

    public int        getIdAbono()           { return idAbono; }
    public int        getIdPedido()          { return idPedido; }
    public BigDecimal getMonto()             { return monto; }
    public BigDecimal getPorcentaje()        { return porcentaje; }
    public Date       getFechaPago()         { return fechaPago; }
    public String     getMetodoPago()        { return metodoPago; }
    public String     getReferencia()        { return referencia; }
    public boolean    isConfirmado()         { return confirmado; }
    public Date       getFechaConfirmacion() { return fechaConfirmacion; }

    public void setIdAbono(int idAbono)                       { this.idAbono = idAbono; }
    public void setIdPedido(int idPedido)                     { this.idPedido = idPedido; }
    public void setMonto(BigDecimal monto)                    { this.monto = monto; }
    public void setPorcentaje(BigDecimal porcentaje)          { this.porcentaje = porcentaje; }
    public void setFechaPago(Date fechaPago)                  { this.fechaPago = fechaPago; }
    public void setMetodoPago(String metodoPago)              { this.metodoPago = metodoPago; }
    public void setReferencia(String referencia)              { this.referencia = referencia; }
    public void setConfirmado(boolean confirmado)             { this.confirmado = confirmado; }
    public void setFechaConfirmacion(Date fechaConfirmacion)  { this.fechaConfirmacion = fechaConfirmacion; }
}
