package modelo;

import java.math.BigDecimal;
import java.sql.Date;

public class PagoFinal {
    private int        idPagoFinal;
    private int        idPedido;
    private BigDecimal monto;
    private Date       fechaPago;
    private String     metodoPago;
    private String     referencia;
    private boolean    confirmado;
    private Date       fechaConfirmacion;

    public PagoFinal() {}

    public int        getIdPagoFinal()       { return idPagoFinal; }
    public int        getIdPedido()          { return idPedido; }
    public BigDecimal getMonto()             { return monto; }
    public Date       getFechaPago()         { return fechaPago; }
    public String     getMetodoPago()        { return metodoPago; }
    public String     getReferencia()        { return referencia; }
    public boolean    isConfirmado()         { return confirmado; }
    public Date       getFechaConfirmacion() { return fechaConfirmacion; }

    public void setIdPagoFinal(int idPagoFinal)               { this.idPagoFinal = idPagoFinal; }
    public void setIdPedido(int idPedido)                     { this.idPedido = idPedido; }
    public void setMonto(BigDecimal monto)                    { this.monto = monto; }
    public void setFechaPago(Date fechaPago)                  { this.fechaPago = fechaPago; }
    public void setMetodoPago(String metodoPago)              { this.metodoPago = metodoPago; }
    public void setReferencia(String referencia)              { this.referencia = referencia; }
    public void setConfirmado(boolean confirmado)             { this.confirmado = confirmado; }
    public void setFechaConfirmacion(Date fechaConfirmacion)  { this.fechaConfirmacion = fechaConfirmacion; }
}
