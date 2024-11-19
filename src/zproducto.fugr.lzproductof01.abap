*----------------------------------------------------------------------*
***INCLUDE LZPRODUCTOF01.
*----------------------------------------------------------------------*
form SET_UPDATE.
* Aqui calcularemos el total del precio de todos los productos en la tabla antes de que se guarde un cambio
* Primero una tabla local y temporal para guardar los resultados de las operaciones
 TYPES: BEGIN OF ty_result,
         clave TYPE zproducto-clave,
         precio_prod  TYPE p LENGTH 16 DECIMALS 2,
        END OF ty_result.

* Despues los datos necesarios para el calculo
 DATA: lt_tprod TYPE TABLE OF ZPRODUCTO,        " Tabla de productos
       lv_tprod type zproducto,                  "Tabla temporal de productos
      lt_tmatprod TYPE TABLE OF ZMATPROD,         " Tabla de relaciones Producto-Material
      lt_tmat TYPE TABLE OF ZMATERIAL,         " Tabla de materiales y precios
      lt_tdiv TYPE TABLE OF zdivisas,         " Tabla de divisas
      wa_div TYPE zdivisas,                   " Area de trabajo del manejo de divisas (una especie de tabla temporal modificable)
      lt_resultado TYPE TABLE OF ty_result, " Tabla de los resultados de cálculos
      lv_precio_total TYPE p LENGTH 16 DECIMALS 2, " Precio total de producción
      lv_precio_convertido TYPE p LENGTH 16 DECIMALS 2, " Precio material convertido a dólares
      lv_tipo_cambio TYPE p LENGTH 16 DECIMALS 7, " Tipo de cambio para conversión
      lv_divisa_destino TYPE WAERS, " Divisa del producto (moneda destino)
      lv_precio_producto TYPE p LENGTH 16 DECIMALS 2. " Precio final en la divisa del producto

* Ahora haremos una consulta sql donde verificaremos: los materiales y su precio y finalmente la divisa
* una vez realizada la cosulta construiremos un precio previo el cual todo el tiempo lo manejaremos en dolares y finalmente lo
*  convertiremos a la moneda final, si no tenemos materiales en la tabla zmatprod dejaremos el precio en 0.

* Leer productos de la tabla y las divisas para interactuar con ellos
  SELECT * FROM ZDIVISAS INTO TABLE lt_tdiv.
  SELECT * FROM zproducto INTO TABLE lt_tprod.

* Iterar sobre los productos disponibles
  LOOP AT lt_tprod INTO DATA(lv_product).

* Inicializar el precio total en 0 para este producto
    CLEAR lv_precio_total.
*Buscar materiales relacionados en Zmatprod para el producto actual
    SELECT * FROM zmatprod
      WHERE producto = @lv_product-clave
      INTO TABLE @lt_tmatprod.

* Si no se encuentra ninguna material, asignamos precio 0
    IF sy-subrc <> 0.
      lv_precio_total = 0.
*En caso contrario buscamos en la tabla zmatprod
    ELSE.
      LOOP AT lt_tmatprod INTO DATA(lv_material).
* Buscar precio del material en zmaterial
        SELECT * FROM ZMATERIAL
          WHERE clave = @lv_material-material
          INTO @DATA(lv_material_data).

        IF sy-subrc = 0.
*Si se encuentra, buscar la divisa en zdivisas y obtener el tipo de cambio

          READ TABLE lt_tdiv INTO wa_div WITH KEY codigo = lv_material_data-divisa.
          IF sy-subrc = 0.
            lv_tipo_cambio = wa_div-precio_usd.

* Convertir el precio del material a dólares multiplicando por su factor de conversion
            lv_precio_convertido = lv_material_data-precio * lv_tipo_cambio.

* Sumar el precio de este material (convertido a dólares) multiplicado por la cantidad
            lv_precio_total = lv_precio_total + ( lv_precio_convertido * lv_material-cantidad ).

          ENDIF.

        ENDIF.
          ENDSELECT.
      ENDLOOP.
    ENDIF.

*  Convertir el precio total a la moneda del producto según zprdoucto
  lv_divisa_destino = lv_product-divisa.

* Buscar tipo de cambio de zdivisa para la moneda del producto
  READ TABLE lt_tdiv into wa_div WITH KEY codigo = lv_divisa_destino.
    IF sy-subrc = 0.
      lv_tipo_cambio = wa_div-precio_usd.

* Convertir el precio total a la moneda del producto con la operacion inversa
      lv_precio_producto = lv_precio_total / lv_tipo_cambio.

    ELSE.
      lv_precio_producto = lv_precio_total. " Si no se encuentra tipo de cambio, dejamos el precio en USD.
    ENDIF.

* Establecer el precio de producción del producto en la tabla de resultados
  INSERT VALUE #( clave = lv_product-clave precio_prod = lv_precio_producto ) INTO TABLE lt_resultado.

ENDLOOP.

* Al final, lt_resultado contendrá los precios de producción por producto en la divisa correspondiente.

LOOP AT lt_resultado INTO DATA(lv_resultado).

* Buscar el registro en zproducto que corresponda al producto actual de lt_resultado
  SELECT SINGLE * FROM zproducto INTO @lv_tprod WHERE clave = @lv_resultado-clave.

* Si el producto existe en zproducto, actualizamos el campo de precio
  IF sy-subrc = 0.
    lv_tprod-precio_prod = lv_resultado-precio_prod.

*Actualizar el registro en la tabla zprod con la tabla temporal creada
    update zproducto FROM lv_tprod.


  ELSE.
    WRITE: / 'Producto', lv_resultado-clave, 'no encontrado en zproducto.'.
  ENDIF.

ENDLOOP.
*Mostramos un mensaje de ayuda
MESSAGE 'Favor de actualizar la pagina para observar los cambios' TYPE 'I'.

ENDFORM.

FORM SET_DELETE_CASCADE.

TYPES: BEGIN OF tp_itab.
  INCLUDE STRUCTURE zproducto.
  INCLUDE STRUCTURE VIMTBFLAGS.
TYPES: END OF tp_itab.

FIELD-SYMBOLS <fs> TYPE tp_itab.

MESSAGE 'Al borrar el/los producto/s borrarás todos sus relaciones en la tabla de material-producto' TYPE 'I'.

LOOP at total ASSIGNING <fs> CASTING.

IF <fs>-vim_mark = 'M'.
  "Si llegaramos a borrar un producto por consecuente deberia dejar de existir en el inventario y en la tabla de matertiales y productos
  DELETE FROM zmatprod WHERE producto = <fs>-clave.
  DELETE FROM zinventario where producto = <fs>-clave.
ENDIF.

ENDLOOP.

ENDFORM.
