# Visión del Proyecto

**ID:** 20270301
**Fecha:** Martes 16 de julio
**Área:** [[MOC — Proyectos]]
**Tags:** #programacion #pasteleria #vision

---

## La Idea

"La Casa de Mandi" es una pastelería artesanal que gestiona pedidos personalizados mediante WhatsApp, Excel y Yappy. El resultado son pedidos perdidos, cobros desorganizados y cero historial. La solución es una plataforma web con login (por correo o WhatsApp) que digitaliza el ciclo completo: catálogo por categoría → pedido con diseño a medida → abono verificado → producción → pago final verificado → entrega, con un panel de administración que centraliza todo el control.

---

## Por Qué Importa

Sin un sistema centralizado, el negocio no puede crecer: las conversaciones de WhatsApp se pierden, el Excel no se sincroniza con nadie y el admin no tiene visibilidad real de cuántos pedidos puede atender por día. Una plataforma propia le da al cliente trazabilidad en tiempo real y al admin control del flujo de producción, pagos y capacidad de entrega.

---

## Conexiones

- Se relaciona con [[Requisitos Funcionales]]
- Se relaciona con [[Modelo de Datos]]
- Apoya la idea de [[Proyecto Semestral La Casa de Mandi]]

---

## Fuente

- **Origen:** Proyecto semestral — análisis del negocio real
- **Autor:** 
- **Fecha de la fuente:** 

---

## Notas Adicionales

### Problema actual

- WhatsApp: comunicación y diseño del pedido — se pierden fácilmente
- Excel: registro manual de pedidos y pagos — no es compartido ni trazable
- Yappy: cobro de abonos y pagos — sin vinculación al registro del pedido

Consecuencias:
- Pedidos perdidos o sin seguimiento
- Errores en montos y fechas acordadas
- El cliente no sabe en qué estado está su pedido
- Sin historial ordenado de clientes ni ingresos
- Dificultad para gestionar múltiples pedidos simultáneos
- Sin control de cuántos pedidos puede atenderse por día

### Solución

Plataforma web que permite:

**Al cliente:**
- Registrarse e iniciar sesión con correo o número de WhatsApp
- Consultar el catálogo dividido en Dulces y Postres
- Hacer un pedido especificando variante (tamaño), diseño y fecha de entrega disponible
- Ver el precio calculado automáticamente (postres) o referencial (dulces)
- Pagar en dos partes: abono para activar producción + pago final al retirar
- Seguir el estado del pedido en tiempo real
- Cancelar si aún no fue aceptado

**Al administrador:**
- Revisar y aceptar o rechazar pedidos
- Ajustar precio de dulces según personalizaciones
- Confirmar abonos y pagos finales antes de avanzar el estado
- Gestionar el catálogo y sus variantes
- Ocultar productos o variantes específicas que no estén disponibles por temporada, sin tener que eliminarlas
- Ver y configurar la capacidad de entrega por día (límite: 5)
- Consultar reportes de pedidos e ingresos

### Objetivo del sistema

Digitalizar el ciclo completo del pedido artesanal en una sola plataforma, accesible desde cualquier dispositivo, con roles diferenciados para cliente y administrador.

---

*← [[­HOME]] | [[MOC — Proyectos]]*
