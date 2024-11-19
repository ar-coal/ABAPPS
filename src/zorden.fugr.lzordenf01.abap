*----------------------------------------------------------------------*
***INCLUDE LZORDENF01.
*----------------------------------------------------------------------*

FORM set_creator.
*cada que se cree una orden vamos a:
*1.-Obtener los datos del cliente que hizo la compra
*2.-Obtener los datos del inventario del producto
*3.-Calcular el precio de venta final en base a las unidades y la divisa solicitadas
*5.-Calcular si el producto está listo o tardará
*6.-En caso de que esté listo no mostraremos nada
*7.-Si no está listo vamos a consultar a la fabrica cuanto tardará en producirse las piezas solicitadas y mostrarlo en pantalla

  "datos que traeremos de otras tablas
DATA: nombre TYPE string,                         "nombre del cliente
      precio_produccion TYPE p LENGTH 16 DECIMALS 2,   "precio desde el inventario
      medida TYPE string,                           "unidad de medida
      cantidad TYPE i,                              "cantidad de productos en inventario
      divisa TYPE waers,                            "divisa del producto en inventario
      text TYPE string,
      tipo_cambio TYPE p LENGTH 16 DECIMALS 2,
      precio_total TYPE p LENGTH 16 DECIMALS 2,
      lt_tdiv TYPE TABLE OF zdivisas,
      wa_div TYPE zdivisas.

SELECT * FROM zdivisas INTO TABLE lt_tdiv.
SELECT SINGLE nombre FROM zcliente INTO @nombre WHERE clave = @zorden-cliente.
SELECT SINGLE precio_venta,unidad_de_medida,divisa,cantidad FROM zinventario INTO (@precio_produccion,@medida,@divisa,@cantidad) WHERE clave = @zorden-producto.
READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = divisa.
   IF sy-subrc = 0.
      tipo_cambio = wa_div-precio_usd.
      precio_total = precio_produccion * tipo_cambio.
   ENDIF.

CLEAR wa_div.

READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = zorden-divisa.
   IF sy-subrc = 0.
      tipo_cambio = wa_div-precio_usd.
      precio_total = precio_total / tipo_cambio.
      zorden-precio_final = precio_total * zorden-cantidad.
   ENDIF.

zorden-fecha_orden = sy-datum.
zorden-usuario = nombre.
zorden-unidad_de_medida = medida.

ENDFORM.


FORM set_UPDATE.
TYPES: BEGIN OF tp_itab.
  INCLUDE STRUCTURE zorden.
  INCLUDE STRUCTURE vimtbflags.
TYPES: END OF tp_itab.

FIELD-SYMBOLS <fs> TYPE tp_itab.

  "datos que traeremos de otras tablas
DATA: nombre TYPE string,                         "nombre del cliente
      precio_produccion TYPE p LENGTH 16 DECIMALS 2,   "precio desde el inventario
      medida TYPE string,                           "unidad de medida
      cantidad TYPE i,                              "cantidad de productos en inventario
      divisa TYPE waers,                            "divisa del producto en inventario
      text TYPE string,
      tipo_cambio TYPE p LENGTH 16 DECIMALS 2,
      precio_total TYPE p LENGTH 16 DECIMALS 2,
      precio_final TYPE p LENGTH 16 DECIMALS 2,
      lt_tdiv TYPE TABLE OF zdivisas,
      wa_div TYPE zdivisas.
SELECT * FROM zdivisas INTO TABLE lt_tdiv.
*cada que se actualice una orden vamos a:
*1.-Repetir el proceso pero sin cambiar la fecha sobre las filas seleccionadas
LOOP AT total ASSIGNING <fs> CASTING.

IF <fs>-vim_action = 'U'.
select SINGLE nombre FROM zcliente INTO @nombre WHERE clave = @<fs>-cliente.
SELECT SINGLE precio_venta,unidad_de_medida,divisa,cantidad FROM zinventario INTO (@precio_produccion,@medida,@divisa,@cantidad) WHERE clave = @<fs>-producto.
READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = divisa.
   IF sy-subrc = 0.
      tipo_cambio = wa_div-precio_usd.
      precio_total = precio_produccion * tipo_cambio.
   ENDIF.
CLEAR wa_div.

READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = <fs>-divisa.
   IF sy-subrc = 0.
      tipo_cambio = wa_div-precio_usd.
      precio_total = precio_total / tipo_cambio.
      precio_final = precio_total * <fs>-cantidad.
   ENDIF.
"eliminamos el proceso de rellenado de fecha
*zorden-fecha_orden = sy-datum.
<fs>-precio_final = precio_final.
<fs>-unidad_de_medida = medida.
<fs>-usuario = nombre.

modify total from <fs>.

BREAK-POINT.
ENDIF.
ENDLOOP.

ENDFORM.
