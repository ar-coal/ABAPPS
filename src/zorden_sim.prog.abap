*&---------------------------------------------------------------------*
*& Report ZORDEN_SIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zorden_sim.
TABLES: zinventario,zproducto,zcliente.

DATA: wa_inv type zinventario.


SELECTION-SCREEN BEGIN OF SCREEN 100.

SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE text-001.

SELECTION-SCREEN COMMENT /1(50) comm1.
SELECT-OPTIONS producto FOR zinventario-clave NO INTERVALS NO-EXTENSION OBLIGATORY DEFAULT '00000'.
SELECTION-SCREEN COMMENT /1(50) comm2 MODIF ID cm2.
SELECTION-SCREEN COMMENT /1(50) comm3 MODIF ID cm3.
PARAMETERS cantidad TYPE i OBLIGATORY DEFAULT '0'.
SELECT-OPTIONS divisa FOR zinventario-divisa NO INTERVALS NO-EXTENSION OBLIGATORY.
SELECTION-SCREEN COMMENT /1(79) comm4.
SELECTION-SCREEN END OF BLOCK part1.

SELECTION-SCREEN BEGIN OF BLOCK part2 WITH FRAME TITLE TEXT-002.
PARAMETERS: cliente AS CHECKBOX USER-COMMAND flag.
PARAMETERS:nombre(50) TYPE c MODIF ID sc1,
           correo(50) TYPE c MODIF ID sc1.
SELECT-OPTIONS clientID FOR zcliente-clave NO INTERVALS NO-EXTENSION OBLIGATORY MODIF ID sc2 DEFAULT 'S/N'.
SELECTION-SCREEN END OF BLOCK part2.


SELECTION-SCREEN END OF SCREEN 100.


AT SELECTION-SCREEN OUTPUT.

 LOOP AT SCREEN INTO DATA(screen_wa).
   comm1 = 'Primero es necesario rellenar los datos'.
   comm2 = 'Producto disponible'.
   comm3 = 'Producto no encontrado ó no disponible'.
   comm4 = 'Presiona ENTER para comprobar la disponibilidad en el inventario'.

   SELECT SINGLE * from zinventario into wa_inv where clave = producto-low.
    IF sy-subrc = 0 AND screen_wa-group1 = 'CM2'.
      screen_wa-active = '1'.
    ENDIF.
    IF sy-subrc = 0 AND screen_wa-group1 = 'CM3'.
      screen_wa-active ='0'.
    ENDIF.
    IF sy-subrc <> 0 AND screen_wa-group1 = 'CM2'.
      screen_wa-active = '0'.
    ENDIF.
    IF sy-subrc <> 0 AND screen_wa-group1 = 'CM3'.
      screen_wa-active ='1'.
    ENDIF.
    IF cliente <> 'X' AND screen_wa-group1 = 'SC1'.
      screen_wa-active = '1'.
    ENDIF.
    IF cliente <> 'X' AND screen_wa-group1 = 'SC2'.
      screen_wa-active = '0'.
    ENDIF.
    IF cliente = 'X' AND screen_wa-group1 = 'SC1'.
      screen_wa-active = '0'.
    ENDIF.
    IF cliente = 'X' AND screen_wa-group1 = 'SC2'.
      screen_wa-active = '1'.
    ENDIF.
    MODIFY screen FROM screen_wa.
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
     DATA: nombre_c TYPE string,                         "nombre del cliente
           correo_c type string,                        "correo del cliente
      precio_produccion TYPE p LENGTH 16 DECIMALS 2,   "precio desde el inventario
      medida TYPE string,                           "unidad de medida
      ndivisa TYPE waers,                            "divisa del producto en inventario
      ncantidad type i,
      text TYPE string,
      prod TYPE string,
      modelo_prod TYPE string,
      fabrica type string,
      prodxdia type i,
      tipo_cambio TYPE p LENGTH 16 DECIMALS 2,
      precio_total TYPE p LENGTH 16 DECIMALS 2,
      lt_tdiv TYPE TABLE OF zdivisas,
      wa_div TYPE zdivisas.
      SELECT * FROM zdivisas INTO TABLE lt_tdiv.
      SELECT SINGLE precio_venta,unidad_de_medida,divisa,producto,cantidad FROM zinventario INTO (@precio_produccion,@medida,@ndivisa,@modelo_prod,@ncantidad) WHERE clave = @producto-low.
       IF sy-subrc <> 0.
         MESSAGE 'Producto no encontrado, consulte nuestro inventario para mas informacion consulta la transaccion: zconsulta_inv' TYPE 'I'.
         exit.
      ENDIF.
      SELECT SINGLE nombre FROM zproducto INTO @prod WHERE clave = @modelo_prod.
      IF clientid-low <> 'S/N'.
        SELECT SINGLE nombre,correo from zcliente INTO (@nombre_c,@correo_c) WHERE clave = @clientid-low
          .
          IF sy-subrc <> 0.
          MESSAGE 'Id de cliente no encontrado, contactese con el administrador en caso de querer ser ingresado al sistema' TYPE 'I'.
          exit.
          ENDIF.
      ELSE.
        nombre_c = nombre.
        correo_c = correo.
      ENDIF.
      READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = ndivisa.
      IF sy-subrc = 0.
        tipo_cambio = wa_div-precio_usd.
        precio_total = precio_produccion * tipo_cambio.
        ENDIF.

      CLEAR wa_div.

      READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = divisa-low.
      IF sy-subrc = 0.
        tipo_cambio = wa_div-precio_usd.
        precio_total = precio_total / tipo_cambio.
        precio_total = precio_total * cantidad.
      ENDIF.
      DATA:
            s_cantidad TYPE c LENGTH 20,
            s_precio TYPE c LENGTH 20.
      s_precio = precio_total.
      s_cantidad = cantidad.
      CONDENSE s_precio NO-GAPS.
      CONDENSE s_cantidad NO-GAPS.


      WRITE:'Bienvenido:', nombre_c,
      / 'Muchas gracias por usar nuestro simulador de orden...',
      / 'Todos los valores son tomados directamente de nuestro inventario en caso de querer un desgloce de los precios visita nuestra hoja de costos de productos', /.
      ULINE (50).
      WRITE:
      / '| Tu producto:', prod, 50 '|',
      / '| Cantidad:', s_cantidad ,46 medida, 50 '|',
      / '| Total: $', s_precio, 46 divisa-low , 50 '|',
      / '|________________________________________________|'.

      Write: /, /, 'Actualmente se cuentan con:', ncantidad, 'de elementos en el inventario'.
      IF cantidad > ncantidad.
        data: tinv TYPE TABLE of zfabrica,
              dif type i .
        dif = cantidad - ncantidad.
        WRITE: /, 'No contamos con la cantidad suficiente nos hacen falta:',dif, /, 'Contamos con los siguientes productores'.
        SELECT * from zfabrica into TABLE @tinv where producto = @modelo_prod.
         loop at tinv into data(wa_inv).
           WRITE: 'Productor:', wa_inv-nombre, /, 'Produccion por dia: ', wa_inv-produccionxdia.
         endloop.
      ENDIF.

      WRITE: /, /, 50 'Se enviará mas informacion al correo:', correo_c.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  start=>main( ).
