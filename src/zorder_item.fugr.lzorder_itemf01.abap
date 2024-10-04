*----------------------------------------------------------------------*
***INCLUDE LZORDER_ITEMF01.
*----------------------------------------------------------------------*
form SET_CREATOR.
  "se definen las variables
  data units type I.
  data price type f.
  data total type f.
  data uom type string.
  data curre TYPE string.

  "preparamos las variables buscando los valores de la tabla base
  select price,unit_of_measure,currency from zglobal_items into (@price,@uom,@curre) where product_id = @zorder_item-product_id.
  endselect.
  units = zorder_item-quantity.

  "realizamos una operacion para asignar un valor automaticamente
  total = units * price.

  "asignamos los valores a la entrada de la tabla
  zorder_item-unit_of_measure = uom.
  zorder_item-unit_price = price.
  zorder_item-currency = curre.
  zorder_item-total_price = total.
  break-POINT.

endform.

form update_orders.
 DATA: lt_table TYPE TABLE OF zorder_item,
      ls_table TYPE zorder_item.

"Leer los datos de la tabla de referencia
SELECT * FROM zorder_item INTO TABLE lt_table.

LOOP AT lt_table INTO ls_table.

  SELECT SINGLE * FROM zorder_header
    WHERE order_no = @ls_table-order_no
    INTO @DATA(ls_ztable).

  IF sy-subrc = 0.
    ls_ztable-total_amount = ls_table-total_price.
    ls_ztable-currency = ls_table-currency.

    UPDATE zorder_header SET
        total_amount = @ls_ztable-total_amount,
        currency = @ls_ztable-currency
    WHERE order_no = @ls_ztable-order_no.

    IF sy-subrc = 0.
      WRITE: / 'Registro actualizado correctamente para clave:', ls_ztable-order_no.
    ELSE.
      WRITE: / 'Error al actualizar el registro con clave:', ls_ztable-order_no.
    ENDIF.
  ELSE.
    WRITE: / 'Registro no encontrado en ORDER_ITEMS para la clave:', ls_table-order_no.
  ENDIF.

ENDLOOP.
endform.
