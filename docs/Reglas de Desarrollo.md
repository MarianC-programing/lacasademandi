# Reglas de Desarrollo

**ID:** 20261703
**Fecha:** Martes 16 de julio
**Área:** [[MOC — Proyectos]]
**Tags:** #programacion #pasteleria #reglas #metodologia

---

## La Idea

El desarrollo del proyecto se rige por siete reglas que garantizan originalidad, trazabilidad de decisiones, calidad de la base de datos (normalizada a 3FN con las entidades reales del negocio) y usabilidad de la interfaz. Todo el contenido —código, wireframes, textos— debe ser original y justificado funcionalmente.

---

## Por Qué Importa

Establecer reglas antes de comenzar evita decisiones arbitrarias y asegura que cada elemento del sistema tenga un propósito claro. También protege la integridad académica del proyecto y orienta el trabajo en equipo.

---

## Conexiones

- Se relaciona con [[Wireframes]]
- Se relaciona con [[Modelo de Datos]]
- Se relaciona con [[Requisitos Funcionales]]
- Se relaciona con [[Mapa del Sitio]]
- Deriva de [[Proyecto Semestral La Casa de Mandi]]

---

## Fuente

- **Origen:** Definición interna del proyecto semestral
- **Autor:** 
- **Fecha de la fuente:** 

---

## Notas Adicionales

### Regla 1 — Originalidad
Todo el contenido generado debe ser ORIGINAL. Prohibido:
- Copiar código de internet
- Copiar wireframes existentes
- Copiar bases de datos de terceros
- Copiar textos completos de otros proyectos

### Regla 2 — Uso de referencias
Se permite utilizar los documentos anteriores únicamente como referencia funcional. Nunca copiar literalmente.

### Regla 3 — Justificación de propuestas
Toda propuesta debe justificar:
- Qué problema resuelve
- Qué entidad utiliza
- Qué pantalla afecta
- A qué categoría (Dulces o Postres) aplica, si la lógica difiere entre ellas

### Regla 4 — Orden antes de wireframes
Antes de crear wireframes:
1. Revisar mapa del sitio (zonas: pública, cliente, admin)
2. Revisar requisitos funcionales
3. Revisar modelo de datos (entidades: Cliente, Administrador, Categoria, Producto, Producto_Variante, Pedido, Pedido_Variante, Abono, Pago_Final, Capacidad_Entrega)

### Regla 5 — Normalización
La base de datos debe estar normalizada mínimo a 3FN. Los tamaños de producto deben ser variantes relacionadas, no columnas repetidas dentro de la misma entidad.

### Regla 6 — Calidad de interfaz
La interfaz debe cumplir:
- Responsive
- Accesible
- Navegación intuitiva
- Compatible con móviles

### Regla 7 — Entregables del semestral
El proyecto debe incluir:
- Mapa del sitio
- Wireframes
- Modelo de base de datos
- Código fuente
- Documentación
- Presentación

---

*← [[­HOME]] | [[MOC — Proyectos]]*
