*&---------------------------------------------------------------------*
*& Report ZORDEN_REP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZORDEN_REP.

DATA: t_ord type table of zorden,
      odd type i VALUE 0.

SELECT * from zorden into table t_ord.

uline (147).
NEW-LINE.
WRITE: '| CLAVE | PRODUCTO' , 62 '| ID CLIENTE | CANTIDAD', 99 '| PRECIO FINAL', 125 '| DIVISA | FECHA      |'.
NEW-LINE.
WRITE: '|_______|____________________________________________________|____________|_______________________|_________________________|________|____________|'.
NEW-LINE.
LOOP AT t_ord INTO data(wa_ord).
  SELECT SINGLE * from zinventario INTO @data(inventario) where clave = @wa_ord-producto.
  SELECT SINGLE * from zproducto into @data(producto) where clave = @inventario-producto.
  IF odd = 0.
    WRITE: '|', wa_ord-clave, '|', producto-nombre ,'|',
      wa_ord-cliente, 75 '|', wa_ord-cantidad CENTERED ,'| $',wa_ord-precio_final LEFT-JUSTIFIED, '|',wa_ord-divisa CENTERED,
      134 '|', wa_ord-fecha_orden DD/MM/YYYY CENTERED,'|' .
    odd = 1.
  ELSEIF odd = 1.
    WRITE: '|' color 2, wa_ord-clave color 2, '|' color 2, producto-nombre color 2 ,'|' color 2,
     wa_ord-cliente color 2 ,75 '|' color 2 ,wa_ord-cantidad color 2 CENTERED,'| $' color 2, wa_ord-precio_final color 2 LEFT-JUSTIFIED,
    '|',wa_ord-divisa CENTERED color 2, 134 '|' color 2, wa_ord-fecha_orden color 2 DD/MM/YYYY CENTERED,'|' color 2 .
    odd = 0.
  ENDIF.
  NEW-LINE.
endloop.
WRITE: '|_______|____________________________________________________|____________|_______________________|_________________________|________|____________|'.
