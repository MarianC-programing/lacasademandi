package modelo;

public class Administrador {
    private int    idAdmin;
    private String nombre;
    private String correo;
    private String password;

    public Administrador() {}

    public int    getIdAdmin()  { return idAdmin; }
    public String getNombre()   { return nombre; }
    public String getCorreo()   { return correo; }
    public String getPassword() { return password; }

    public void setIdAdmin(int idAdmin)      { this.idAdmin = idAdmin; }
    public void setNombre(String nombre)     { this.nombre = nombre; }
    public void setCorreo(String correo)     { this.correo = correo; }
    public void setPassword(String password) { this.password = password; }
}
