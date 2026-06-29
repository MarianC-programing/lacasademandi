package modelo;

import java.util.List;

public class Producto {
    private int    idProducto;
    private int    idCategoria;
    private String nombreCategoria;
    private String nombre;
    private String descripcion;
    private String imagen;
    private boolean disponible;
    private List<Variante> variantes;

    public Producto() {}

    public int     getIdProducto()      { return idProducto; }
    public int     getIdCategoria()     { return idCategoria; }
    public String  getNombreCategoria() { return nombreCategoria; }
    public String  getNombre()          { return nombre; }
    public String  getDescripcion()     { return descripcion; }
    public String  getImagen()          { return imagen; }
    public boolean isDisponible()       { return disponible; }
    public List<Variante> getVariantes(){ return variantes; }

    public void setIdProducto(int idProducto)             { this.idProducto = idProducto; }
    public void setIdCategoria(int idCategoria)           { this.idCategoria = idCategoria; }
    public void setNombreCategoria(String nombreCategoria){ this.nombreCategoria = nombreCategoria; }
    public void setNombre(String nombre)                  { this.nombre = nombre; }
    public void setDescripcion(String descripcion)        { this.descripcion = descripcion; }
    public void setImagen(String imagen)                  { this.imagen = imagen; }
    public void setDisponible(boolean disponible)         { this.disponible = disponible; }
    public void setVariantes(List<Variante> variantes)    { this.variantes = variantes; }
}
