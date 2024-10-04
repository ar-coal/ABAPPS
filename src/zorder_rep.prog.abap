*&---------------------------------------------------------------------*
*& Report ZORDER_REP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZORDER_REP.
tables: zorder_header,
        zorder_item,
        zglobal_items.

SELECTION-SCREEN begin of BLOCK b1 with frame title text-001.

select-OPTIONS: s_date for zorder_header-created_on.


SELECTION-SCREEN end of BLOCK b1.

INITIALIZATION.
s_date-high = sy-datum.
s_date-low = sy-datum - 30.
s_date-option = 'BT'.
s_date-sign = 'I'.
append s_date.


START-OF-SELECTION.
data : total type p decimals 2,
       pair type i .

SELECT * from zorder_header into TABLE @data(t_odh) where created_on in @s_date.

WRITE:/'REPORTE DE VENTAS'.
WRITE:/'CLIENTE' COLOR COL_HEADING, 13 'PRODUCTO' COLOR COL_HEADING, 26 'PRECIO' COLOR COL_HEADING, 40 'UND' COLOR COL_HEADING, 44 'DIV' COLOR COL_HEADING, 55 'TOTAL' COLOR COL_HEADING.
ULINE.

LOOP AT t_odh INTO DATA(ls_odh).
  select SINGLE * from zorder_item into @data(ls_odi) where order_no = @ls_odh-order_no.

  select SINGLE * from zglobal_items into @data(ls_gi) where product_id = @ls_odi-product_id.
  if pair = 0.
    WRITE:/ ls_odh-customer_id, 11 ls_gi-name RIGHT-JUSTIFIED, 26 ls_gi-price RIGHT-JUSTIFIED, 38 ls_odi-quantity, 44 ls_odh-currency, 48 ls_odh-total_amount.
    pair = 1.
  else.
    WRITE:/ ls_odh-customer_id color COL_NORMAL, 11 ls_gi-name color COL_NORMAL RIGHT-JUSTIFIED, 26 ls_gi-price RIGHT-JUSTIFIED color COL_NORMAL, 38 ls_odi-quantity color COL_NORMAL,44 ls_odh-currency color COL_NORMAL, 48 ls_odh-total_amount color
COL_NORMAL .
    pair = 0.
  ENDIF.
  total = total + ls_odh-total_amount.
ENDLOOP.
uline.

WRITE:/'TOTAL: $',total color COL_TOTAL.

END-OF-SELECTION.
