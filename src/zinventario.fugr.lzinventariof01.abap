*----------------------------------------------------------------------*
***INCLUDE LZINVENTARIOF01.
*----------------------------------------------------------------------*
FORM set_update.
  TYPES: BEGIN OF ty_result,
         clave TYPE zinventario-clave,
         precio_prod  TYPE p LENGTH 16 DECIMALS 2,
         END OF ty_result.

  DATA: lt_tpro TYPE TABLE OF zproducto,
        lv_tpro TYPE zproducto,
        lt_tinv TYPE TABLE OF zinventario,
        lv_tinv TYPE zinventario,
        lt_tfab TYPE TABLE OF zfabrica,
        lv_tfab TYPE zfabrica,
        lt_tdiv TYPE TABLE OF zdivisas,
        wa_div TYPE zdivisas,
        lt_resultado TYPE TABLE OF ty_result, " Tabla de los resultados de cálculos
        lv_precio_total TYPE p LENGTH 16 DECIMALS 2, " Precio total de producción
        lv_precio_convertido TYPE p LENGTH 16 DECIMALS 2, " Precio de fabricion a dolares
        lv_tipo_cambio TYPE p LENGTH 16 DECIMALS 7, " Tipo de cambio para conversión
        lv_divisa_destino TYPE waers, " Divisa del producto (moneda destino)
        lv_precio_producto TYPE p LENGTH 16 DECIMALS 2. " Precio final en la divisa del producto

  SELECT * FROM zinventario INTO TABLE lt_tinv.
  SELECT * FROM zproducto INTO TABLE lt_tpro.
  SELECT * FROM zdivisas INTO TABLE lt_tdiv.
  SELECT * FROM zfabrica INTO TABLE lt_tfab.
  "primero ajustaremos todos los precios de la tabla fabrica a dolares


  LOOP AT lt_tfab INTO DATA(lv_fab).
     READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = lv_fab-divisa.
          IF sy-subrc = 0.
            lv_tipo_cambio = wa_div-precio_usd.
            lv_precio_convertido = lv_fab-precio_prod * lv_tipo_cambio.
          ENDIF.
      INSERT VALUE #( clave = lv_fab-clave precio_prod = lv_precio_convertido ) INTO TABLE lt_resultado.
  ENDLOOP.

  "actualizamos la tabla variable de fabrica
  LOOP AT lt_resultado INTO DATA(lv_resultado).
  SELECT SINGLE * FROM zfabrica INTO @lv_tfab WHERE clave = @lv_resultado-clave.
    IF sy-subrc = 0.
      lv_tfab-precio_prod = lv_resultado-precio_prod.
      MODIFY lt_tfab FROM lv_tfab TRANSPORTING precio_prod WHERE clave EQ lv_tfab-clave.
     ENDIF.
  ENDLOOP.
  CLEAR lt_resultado.
 "limpiamos la tabla de resultados y volvemos a repetir el procedimiento sobre la tabla de productos
   LOOP AT lt_tpro INTO DATA(lv_pro).
     READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = lv_pro-divisa.
          IF sy-subrc = 0.
            lv_tipo_cambio = wa_div-precio_usd.
            lv_precio_convertido = lv_pro-precio_prod * lv_tipo_cambio.
          ENDIF.
      INSERT VALUE #( clave = lv_pro-clave precio_prod = lv_precio_convertido ) INTO TABLE lt_resultado.
  ENDLOOP.

  "actualizamos la tabla variable de productos
  LOOP AT lt_resultado INTO DATA(lv_resultado2).
  SELECT SINGLE * FROM zproducto INTO @lv_tpro WHERE clave = @lv_resultado2-clave.
  IF sy-subrc = 0.
    lv_tpro-precio_prod = lv_resultado2-precio_prod.
   MODIFY lt_tpro FROM lv_tpro TRANSPORTING precio_prod WHERE clave EQ lv_tpro-clave.
  ENDIF.
  ENDLOOP.
  CLEAR lt_resultado.

*Formar precio final
  LOOP AT lt_tinv INTO DATA(lv_inv).
    CLEAR lv_precio_total.
    "seleccionamos el costo de produccion mas barato
    SELECT * FROM zfabrica WHERE producto = @lv_inv-producto ORDER BY precio_prod DESCENDING INTO @DATA(v_fab) UP TO 1 ROWS.
    ENDSELECT.
     READ TABLE lt_tfab INTO lv_tfab WITH KEY clave = v_fab-clave.
          IF sy-subrc = 0.
            lv_precio_total = lv_tfab-precio_prod.
          ENDIF.
     READ TABLE lt_tpro INTO lv_tpro WITH KEY clave = v_fab-producto.
          IF sy-subrc = 0.
            lv_precio_total = lv_precio_total + lv_tpro-precio_prod.
          ENDIF.
     READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = lv_inv-divisa.
          IF sy-subrc = 0.
            lv_tipo_cambio = wa_div-precio_usd.
            lv_precio_total = lv_precio_total / lv_tipo_cambio.
          ENDIF.
     INSERT VALUE #( clave = lv_inv-clave precio_prod = lv_precio_total ) INTO TABLE lt_resultado.
  ENDLOOP.
*Actualizando inventario
  LOOP AT lt_resultado INTO DATA(lv_resultado9).
  SELECT SINGLE * FROM zinventario INTO @lv_tinv WHERE clave = @lv_resultado9-clave.
  IF sy-subrc = 0.
    lv_tinv-precio_venta = lv_resultado9-precio_prod.
    UPDATE zinventario FROM lv_tinv.
   ENDIF.
   ENDLOOP.
ENDFORM.

FORM SET_DELETE_CASCADE.

TYPES: BEGIN OF tp_itab.
  INCLUDE STRUCTURE zinventario.
  INCLUDE STRUCTURE VIMTBFLAGS.
TYPES: END OF tp_itab.

FIELD-SYMBOLS <fs> TYPE tp_itab.

MESSAGE 'Al borrar el/los registro/s de inventario borrarás todos sus relaciones en la tabla de ordenes' TYPE 'I'.

LOOP at total ASSIGNING <fs> CASTING.

IF <fs>-vim_mark = 'M'.
  "Aqui solo borraremos de la taba de material producto
  DELETE FROM zorden WHERE producto = <fs>-clave.
ENDIF.

ENDLOOP.

ENDFORM.
