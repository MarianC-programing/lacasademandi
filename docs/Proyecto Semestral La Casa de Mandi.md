---
share_link: https://share.note.sx/9nrk41ob#Un1FUDZmwf3xMGpPXmTS8tGcPaNTSslw61M9ldF7CfE
share_updated: 2026-06-17T16:45:09-05:00
---
# Proyecto Semestral La Casa de Mandi

**Estado:** #activo
**Fecha inicio:** Martes 16 de junio
**Fecha límite:** Martes 8 de julio
**Área:** [[MOC — Proyectos]]
**Tags:** #programacion #pasteleria #semestral

---

## ¿Qué es?

Plataforma web con login para la pastelería artesanal "La Casa de Mandi". Digitaliza el ciclo completo del pedido personalizado: catálogo (Dulces y Postres) → pedido con diseño a medida → abono verificado por admin → producción → pago final verificado → entrega. Incluye panel de administración con gestión de estados, pagos, productos, clientes, capacidad de entregas y reportes.

---

## Objetivo Principal

Reemplazar el flujo manual por WhatsApp, Excel y Yappy con un sistema donde el cliente hace y rastrea su pedido en línea, y el admin gestiona todo el ciclo desde un panel dedicado con control real de lo que puede producir por día.

---

## Por Qué Lo Hago

Es el proyecto semestral de Programación 2. Representa un caso real de negocio local que necesita digitalización, lo que lo hace relevante más allá de la nota: es una solución que podría usarse en producción.

---

## Tareas

### En Progreso
- [ ] Diseño de wireframes detallados

### Pendiente
- [ ] Implementación del modelo de datos y migraciones
- [x] Script SQL con catálogo real y seeds de pedidos
- [ ] Sistema de login con doble identificador (correo o WhatsApp)
- [ ] Módulo de catálogo con categorías y variantes
- [ ] Formulario de pedido (lógica de precio automático vs ajustable)
- [ ] Flujo de estados del pedido (manual con excepciones automáticas)
- [ ] Módulo de pagos (abono + pago final, ambos con confirmación del admin)
- [ ] Control de capacidad de entrega por fecha (límite 5/día)
- [ ] Panel de administración completo
- [ ] Módulo de reportes
- [ ] Pruebas
- [ ] Documentación final
- [ ] Presentación

### Completado
- [x] Visión del proyecto
- [x] Requisitos funcionales
- [x] Modelo de datos (entidades, variantes, flujo de estados, capacidad)
- [x] Mapa del sitio (zonas pública, cliente, admin)
- [x] Reglas de desarrollo
- [x] Wireframes (estructura de todas las pantallas principales)

---

## Decisiones Tomadas

| Decisión                                            | Razón                                                                | Fecha |
| --------------------------------------------------- | -------------------------------------------------------------------- | ----- |
| Login por correo o WhatsApp                         | Los clientes interactúan con el negocio principalmente por WhatsApp  |       |
| Sin carrito tradicional                             | Los pedidos son personalizados, no compras de stock                  |       |
| Dos categorías fijas: Dulces y Postres              | El catálogo del negocio es simple y no requiere categorías dinámicas |       |
| Precio automático para postres                      | Son productos estándar con precio fijo por variante                  |       |
| Precio ajustable por admin para dulces              | Las tortas tienen personalizaciones que cambian el precio            |       |
| Pago en dos partes con confirmación del admin       | El admin debe verificar el pago antes de producir                    |       |
| Estado Entregado automático al confirmar pago final | Es el único paso donde no hay acción adicional del admin             |       |
| Límite de 5 entregas por día (configurable)         | La pastelería no puede producir volúmenes ilimitados                 |       |
| Estado Cancelado solo en Pendiente                  | Una vez aceptado el pedido ya hay compromiso de producción           |       |
| Tabla Producto_Variante separada                    | Evita duplicar productos por cada tamaño distinto                    |       |
| Campo confirmado en Abono y Pago_Final              | Previene que pagos no verificados activen cambios de estado          |       |
| Disponibilidad por producto y por variante          | Permite ocultar pasteles o tamaños fuera de temporada sin borrarlos  |       |

---

## Recursos y Referencias

- [[Vision del Proyecto]]
- [[Requisitos Funcionales]]
- [[Modelo de Datos]]
- [[Mapa del Sitio]]
- [[Wireframes]]
- [[Reglas de Desarrollo]]
- [[Script Base de Datos]]

---

## Reflexiones del Proyecto

*(Aprendizajes, obstáculos, problemas)*

---

*← [[­HOME]] | [[MOC — Proyectos]]*


---
# Explicación rápida

## Flujo del pedido

```
Pendiente → Aceptado → En producción → Listo → Entregado
     ↘           ↘
  Cancelado    Rechazado
```

**Pendiente** — El cliente envió el pedido. Tú lo revisas y decides.
→ *Automático: el sistema lo pone aquí solo cuando el cliente confirma el pedido.*

**Aceptado** — Tú aprobaste el pedido y fijaste el precio final. El cliente debe pagar el abono.
→ *Manual: tú lo mueves.*

**Rechazado** — No puedes atender ese pedido (sin capacidad, fecha no viable, etc.).
→ *Manual: tú lo mueves.*

**Cancelado** — El cliente decidió cancelar antes de que tú lo aceptaras.
→ *Automático: el cliente lo hace desde su panel, solo disponible en estado Pendiente.*

**En producción** — El abono llegó y fue verificado. Ya puedes empezar a elaborar.
→ *Manual: tú confirmas que recibiste el abono y el sistema lo mueve.*

**Listo** — El producto está terminado. El cliente debe hacer el pago final.
→ *Manual: tú lo mueves.*

**Entregado** — El pago final llegó y fue verificado. Ciclo completo.
→ *Automático: cuando tú confirmas el pago final, el sistema lo cierra solo.*

---

## Diferencia entre Dulces y Postres

**Dulces** *(tortas, pasteles personalizados)*
- El cliente elige el producto y describe el diseño que quiere
- El precio base es referencial — **tú lo ajustas** cuando revisas el pedido, porque el diseño puede cambiar el costo
- El pedido no se acepta hasta que tú hayas fijado el precio final
- Siempre requieren una descripción del diseño

**Postres** *(cheesecakes, cupcakes, etc.)*
- El cliente elige el producto, la variante y la cantidad
- El precio **se calcula solo** (cantidad × precio de la variante), sin que tú tengas que intervenir
- La descripción del diseño es opcional
- El flujo es más directo porque no hay personalización de precio

---

La diferencia clave: en dulces tú defines el precio, en postres el sistema lo hace solo.
