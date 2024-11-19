*&---------------------------------------------------------------------*
*& Report ZPRODUCTO_COTIZAR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPRODUCTO_COTIZAR.

TABLES:zinventario.
SELECTION-SCREEN BEGIN OF SCREEN 100.

SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE text-001.
SELECTION-SCREEN COMMENT /1(50) comm1.
SELECTION-SCREEN COMMENT /1(52) comm4.
SELECT-OPTIONS clave FOR zinventario-producto NO INTERVALS NO-EXTENSION OBLIGATORY DEFAULT '00000'.
SELECTION-SCREEN COMMENT /1(50) comm2 MODIF ID cm1 .
SELECTION-SCREEN COMMENT /1(50) comm3 MODIF ID cm2.
SELECTION-SCREEN END OF BLOCK part1.

SELECTION-SCREEN END OF SCREEN 100.



AT SELECTION-SCREEN OUTPUT.

  LOOP AT screen INTO DATA(screen_wa).
    comm1 = 'Ingresa la clave del producto'.
    comm4 = 'Despues presiona ENTER para verificar su existencia'.
    comm2 = 'Producto no encontrado'.
    comm3 = 'Producto encontrado'.
    SELECT * from zproducto into TABLE @data(disposable) where clave = @clave-low.
      if sy-subrc = 0 AND screen_wa-group1 = 'CM1'.
        screen_wa-active = '0'.
      ENDIF.
      if sy-subrc = 0 AND screen_wa-group1 = 'CM2'.
        screen_wa-active = '1'.
       endif.
       if sy-subrc <> 0 AND screen_wa-group1 = 'CM1'.
        screen_wa-active = '1'.
       endif.
       if sy-subrc <> 0 AND screen_wa-group1 = 'CM2'.
        screen_wa-active = '0'.
       endif.
      MODIFY SCREEN FROM screen_wa.
  ENDLOOP.

CLASS start DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS start IMPLEMENTATION.
  METHOD main.
    CALL SELECTION-SCREEN 100 STARTING AT 10 10.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

 DATA: lt_tprod TYPE TABLE OF ZPRODUCTO,        " Tabla de productos
       lv_tprod type zproducto,                  "Tabla temporal de productos
      lt_tmatprod TYPE TABLE OF ZMATPROD,         " Tabla de relaciones Producto-Material
      lt_tmat TYPE TABLE OF ZMATERIAL,         " Tabla de materiales y precios
      lt_tdiv TYPE TABLE OF zdivisas,         " Tabla de divisas
      wa_div TYPE zdivisas,                   " Area de trabajo del manejo de divisas (una especie de tabla temporal modificable)
      lv_precio_total TYPE p LENGTH 16 DECIMALS 2, " Precio total de producción
      lv_precio_convertido TYPE p LENGTH 16 DECIMALS 2, " Precio material convertido a dólares
      lv_tipo_cambio TYPE p LENGTH 16 DECIMALS 7, " Tipo de cambio para conversión
      precio_temporal type p LENGTH 16 DECIMALS 2.


  SELECT * FROM zproducto INTO TABLE @lt_tprod where clave = @clave-low.
  SELECT * FROM ZDIVISAS INTO TABLE lt_tdiv.

  LOOP AT lt_tprod INTO DATA(lv_product).
    SELECT * FROM zmatprod WHERE producto = @lv_product-clave INTO TABLE @lt_tmatprod.

    IF sy-subrc <> 0.
      MESSAGE: 'El producto aun no cuenta con materiales, para mas informacion contacte a un administrador' type 'I'.
      exit.

    ELSE.
      WRITE: 'Producto:', lv_product-nombre LEFT-JUSTIFIED, / , 'Gama:', lv_product-gama LEFT-JUSTIFIED, /,
       'Precio: $', lv_product-precio_prod LEFT-JUSTIFIED, /, 'Divisa: ', lv_product-divisa LEFT-JUSTIFIED, /.
      ULINE (118).
      NEW-LINE.
      WRITE:'| MATERIAL' COLOR 2, 34 '| PRECIO' COLOR 2, 58 '| DIV' COLOR 2, 66 '| CANTIDAD' COLOR 2, 82 '| PRECIO USD                        |' COLOR 2.
      NEW-LINE.
      LOOP AT lt_tmatprod INTO DATA(lv_material).
        clear precio_temporal.
        SELECT * FROM ZMATERIAL WHERE clave = @lv_material-material INTO @DATA(lv_material_data).
        IF sy-subrc = 0.
          READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = lv_material_data-divisa.
          IF sy-subrc = 0.
            lv_tipo_cambio = wa_div-precio_usd.
            lv_precio_convertido = lv_material_data-precio * lv_tipo_cambio.
            precio_temporal = lv_precio_convertido * lv_material-cantidad .
            lv_precio_total = lv_precio_total + precio_temporal.
            WRITE:'|', lv_material_data-nombre , '|' , lv_material_data-precio, '|', lv_material_data-divisa, '|', lv_material-cantidad, '|', precio_temporal, '|'.
            NEW-LINE.
          ENDIF.

        ENDIF.
          ENDSELECT.
      ENDLOOP.
      WRITE:'|________________________________|_______________________|_______|_______________|___________________________________|'.
    ENDIF.

ENDLOOP.


  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  start=>main( ).
