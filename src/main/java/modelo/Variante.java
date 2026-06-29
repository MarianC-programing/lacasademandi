package modelo;

import java.math.BigDecimal;

public class Variante {
    private int        idVariante;
    private int        idProducto;
    private String     tamano;
    private BigDecimal precioBase;
    private boolean    disponible;

    public Variante() {}

    public int        getIdVariante()  { return idVariante; }
    public int        getIdProducto()  { return idProducto; }
    public String     getTamano()      { return tamano; }
    public BigDecimal getPrecioBase()  { return precioBase; }
    public boolean    isDisponible()   { return disponible; }

    public void setIdVariante(int idVariante)        { this.idVariante = idVariante; }
    public void setIdProducto(int idProducto)        { this.idProducto = idProducto; }
    public void setTamano(String tamano)             { this.tamano = tamano; }
    public void setPrecioBase(BigDecimal precioBase) { this.precioBase = precioBase; }
    public void setDisponible(boolean disponible)    { this.disponible = disponible; }
}
