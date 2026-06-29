package modelo;

public class Cliente {
    private int    idCliente;
    private String nombre;
    private String telefono;
    private String whatsapp;
    private String correo;
    private String password;

    public Cliente() {}

    public int    getIdCliente()  { return idCliente; }
    public String getNombre()     { return nombre; }
    public String getTelefono()   { return telefono; }
    public String getWhatsapp()   { return whatsapp; }
    public String getCorreo()     { return correo; }
    public String getPassword()   { return password; }

    public void setIdCliente(int idCliente)    { this.idCliente = idCliente; }
    public void setNombre(String nombre)       { this.nombre = nombre; }
    public void setTelefono(String telefono)   { this.telefono = telefono; }
    public void setWhatsapp(String whatsapp)   { this.whatsapp = whatsapp; }
    public void setCorreo(String correo)       { this.correo = correo; }
    public void setPassword(String password)   { this.password = password; }
}
