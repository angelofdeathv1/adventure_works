/* Formatted on 3/9/2017 2:59:17 PM (QP5 v5.300) */
--EASY
--1-Muestre el nombre y direccion de correo electronico del cliente con nombre de la compañia 'XXXXXXXXX'

SELECT cus.first_name || ' ' || cus.last_name AS Full_Name,
       cus.email_address,
       cus.company_name
  FROM AARAMBULA.CUSTOMERS cus
 WHERE cus.company_name LIKE '%Jefferson%';

--2-Muestre el nombre de la compañia de todos los clientes con una dirección en la ciudad de 'XXXXXXXXX'

SELECT DISTINCT cus.company_name, addr.city
  FROM AARAMBULA.CUSTOMERS  cus
       INNER JOIN AARAMBULA.CUSTOMER_ADDRESSES cus_add
           ON cus.CUSTOMER_ID = cus_add.CUSTOMER_ID
       INNER JOIN aarambula.addresses addr
           ON cus_add.ADDRESS_ID = addr.ADDRESS_ID
 WHERE addr.CITY LIKE '%Atlanta%';

--3-Cuantos articulos con un precio de lista mayor a 'XXXXXXXXX' han sido vendidos

SELECT COUNT (*) AS cuenta, SUM (sal_dtl.order_qty) AS total_qty
  FROM aarambula.sales_order_detail  sal_dtl
       INNER JOIN aarambula.products prod
           ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
 WHERE prod.list_price > 50000000;

--4-Obtener el nombre de la compañia con clientes con ordenes mayores a 'XXXXXXXX'

SELECT DISTINCT cus.company_name
  FROM aarambula.sales_order_header  sal_hdr
       INNER JOIN AARAMBULA.CUSTOMERS cus
           ON sal_hdr.CUSTOMER_ID = cus.CUSTOMER_ID
 WHERE (sal_hdr.SUBTOTAL + sal_hdr.TAX_AMOUNT + sal_hdr.SHIPPING) > 50000000;

--5-Obtener el numero de productos 'YYYYYYYYY' ordenados por la compañia 'XXXXXXXX'

SELECT SUM (sal_dtl.order_qty) AS total_qty
  FROM aarambula.sales_order_header  sal_hdr
       INNER JOIN aarambula.sales_order_detail sal_dtl
           ON sal_hdr.SALES_ORDER_ID = sal_dtl.sales_order_id
       INNER JOIN aarambula.products prod
           ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
       INNER JOIN AARAMBULA.CUSTOMERS cus
           ON sal_hdr.CUSTOMER_ID = cus.CUSTOMER_ID
 WHERE     prod.PRODUCT_NAME LIKE '%oTJkeFpfBgOplnfVAZVWWS%'
       AND cus.COMPANY_NAME LIKE '%FKSX Shoes%';

--MEDIUM
--6-encontrar las ordenes donde solo se ha vendido un solo articulo

  SELECT sal_dtl.sales_order_id, COUNT (sal_dtl.product_id)
    FROM aarambula.sales_order_detail sal_dtl
         INNER JOIN aarambula.products prod
             ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
GROUP BY sal_dtl.sales_order_id
  HAVING COUNT (sal_dtl.product_id) = 1;

--7-liste los articulos y todos los clientes que ordenaron algun producto perteneciente al product model 'XXXXX'

SELECT cus.COMPANY_NAME,
       cus.first_name || ' ' || cus.last_name AS Full_Name,
       prod.PRODUCT_NAME,
       prod_mod.PRODUCT_MODEL_NAME
  FROM aarambula.sales_order_header  sal_hdr
       INNER JOIN aarambula.sales_order_detail sal_dtl
           ON sal_hdr.SALES_ORDER_ID = sal_dtl.sales_order_id
       INNER JOIN aarambula.products prod
           ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
       INNER JOIN aarambula.product_models prod_mod
           ON prod.PRODUCT_MODEL_ID = prod_mod.product_model_id
       INNER JOIN aarambula.customers cus
           ON sal_hdr.CUSTOMER_ID = cus.CUSTOMER_ID
 WHERE prod_mod.PRODUCT_MODEL_NAME LIKE '%BDY%';

--8-muestre id_articulo, descripcion de los articulos con la cultura 'XXXXXXX'

SELECT prod.PRODUCT_ID, prod_des.PRODUCT_DESCRIPTION, prod_mod_des.CULTURE
  FROM aarambula.products  prod
       INNER JOIN aarambula.product_models prod_mod
           ON prod.PRODUCT_MODEL_ID = prod_mod.product_model_id
       INNER JOIN aarambula.product_model_description prod_mod_des
           ON prod_mod.product_model_id = prod_mod_des.product_model_id
       INNER JOIN aarambula.product_descriptions prod_des
           ON prod_mod_des.PRODUCT_DESCRIPTION_ID =
                  prod_des.PRODUCT_DESCRIPTION_ID
 WHERE prod_mod_des.CULTURE LIKE '%MX%';

/*9-utilizando el valor subtotal en SaleOrderHeader liste las ordenes de mayor a menor. 
Por cada orden muestre la compania y el peso total de la orden*/

  SELECT sal_hdr.SALES_ORDER_ID,
         cus.company_name,
         sal_hdr.subtotal,
         order_weight.TOTAL_WEIGHT
    FROM AARAMBULA.SALES_ORDER_HEADER sal_hdr
         INNER JOIN aarambula.customers cus
             ON sal_hdr.CUSTOMER_ID = cus.CUSTOMER_ID
         INNER JOIN
         (  SELECT sal_dtl.SALES_ORDER_ID,
                   SUM (sal_dtl.order_qty * prod.product_weight) AS total_weight
              FROM aarambula.sales_order_detail sal_dtl
                   INNER JOIN aarambula.products prod
                       ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
          GROUP BY sal_dtl.sales_order_id) order_weight
             ON sal_hdr.sales_order_id = order_weight.SALES_ORDER_ID
ORDER BY subtotal;

--10-cuantos articulos 'XXXXX' fueron vendidos a una direccion en la ciudad 'YYYYYY'

SELECT SUM (sal_dtl.order_qty)
  FROM aarambula.sales_order_header  sal_hdr
       INNER JOIN aarambula.sales_order_detail sal_dtl
           ON sal_hdr.SALES_ORDER_ID = sal_dtl.sales_order_id
       INNER JOIN AARAMBULA.ADDRESSES addr
           ON sal_hdr.BILL_TO_ADDRESS_ID = addr.ADDRESS_ID
       INNER JOIN aarambula.products prod
           ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
 WHERE     addr.city LIKE '%Baltimore, MD%'
       AND prod.PRODUCT_NAME LIKE
               '%BLwqyMqbnvyQIhREuitqDeqPOqYiLkMBWiEdVMBiQSLRIGDfxaflKLTiGqx%';

--Medium Hard
--11-Por cada cliente con un TIPO de direccion 'XXXXXXXXX' en la ciudad 'YYYYYYYYY' muestre los datos de la direccion

SELECT DISTINCT addr.address_line_1,
                addr.address_line_2,
                addr.postal_code,
                addr.city,
                addr.state_province,
                addr.country
  FROM aarambula.customers  cus
       INNER JOIN aarambula.customer_addresses cus_addr
           ON cus.CUSTOMER_ID = cus_addr.CUSTOMER_ID
       INNER JOIN aarambula.addresses addr
           ON cus_addr.ADDRESS_ID = addr.ADDRESS_ID
 WHERE cus_addr.ADDRESS_TYPE = 'Main' AND addr.CITY LIKE '%Little Rock, AR%';

/*12-Por cada orden, muestre el SalesOrderID y el subtotal calculado de tres formas:
A) Del encabezado de la orden
B) Suma de la cantidad de la orden por precio unitario
C) Suma de la cantidad de la orden por precio de lista*/

  SELECT sal_hdr.sales_order_id,
         MAX (sal_hdr.subtotal),
         SUM (sal_dtl.order_qty * sal_dtl.unit_price) AS sub_unit,
         SUM (sal_dtl.order_qty * prod.list_price)  AS sub_list
    FROM aarambula.sales_order_header sal_hdr
         INNER JOIN aarambula.sales_order_detail sal_dtl
             ON sal_hdr.SALES_ORDER_ID = sal_dtl.sales_order_id
         INNER JOIN aarambula.products prod
             ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
GROUP BY sal_hdr.sales_order_id;

--13-Muestre el articulo mejor vendido
--a)

  SELECT sal_dtl.product_id, prod.product_name
    FROM aarambula.sales_order_detail sal_dtl
         INNER JOIN aarambula.products prod
             ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
GROUP BY sal_dtl.product_id, prod.product_name
  HAVING SUM (sal_dtl.order_qty) =
             (  SELECT MAX (SUM (sal_dtl.order_qty)) AS qty
                  FROM aarambula.sales_order_detail sal_dtl
                       INNER JOIN aarambula.products prod
                           ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
              GROUP BY sal_dtl.product_id);

--b)

SELECT product_id, product_name
  FROM (  SELECT SUM (sal_dtl.order_qty) AS qty,
                 sal_dtl.product_id,
                 prod.product_name,
                 ROW_NUMBER () OVER (ORDER BY SUM (sal_dtl.order_qty) DESC)
                     AS product_rank
            FROM aarambula.sales_order_detail sal_dtl
                 INNER JOIN aarambula.products prod
                     ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
        GROUP BY sal_dtl.product_id, prod.product_name)
 WHERE product_rank = 1;

/*15-Identifique las 10 ciudades mas importantes, muestre la categoria de producto 
mas popular por ciudad. (ciudades con mayores ventas)*/

SELECT city
  FROM (  SELECT addr.CITY,
                 SUM (sal_dtl.unit_price * sal_dtl.order_qty) AS total_sales,
                 ROW_NUMBER ()
                 OVER (
                     ORDER BY SUM (sal_dtl.unit_price * sal_dtl.order_qty) DESC)
                     AS city_rank
            FROM aarambula.sales_order_header sal_hdr
                 INNER JOIN aarambula.sales_order_detail sal_dtl
                     ON sal_hdr.SALES_ORDER_ID = sal_dtl.SALES_ORDER_ID
                 INNER JOIN AARAMBULA.ADDRESSES addr
                     ON sal_hdr.SHIP_TO_ADDRESS_ID = addr.address_id
        GROUP BY addr.CITY)
 WHERE city_rank BETWEEN 0 AND 10;


  SELECT addr.CITY,
         SUM (sal_dtl.unit_price * sal_dtl.order_qty) AS sales_total,
         cat.PRODUCT_CATEGORY,
         ROW_NUMBER ()
         OVER (PARTITION BY addr.CITY
               ORDER BY SUM (sal_dtl.unit_price * sal_dtl.order_qty) DESC)
             AS product_rank
    FROM aarambula.sales_order_header sal_hdr
         INNER JOIN aarambula.sales_order_detail sal_dtl
             ON sal_hdr.SALES_ORDER_ID = sal_dtl.SALES_ORDER_ID
         INNER JOIN aarambula.products prod
             ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
         INNER JOIN AARAMBULA.PRODUCT_CATEGORIES cat
             ON prod.PRODUCT_CATEGORY_ID = cat.product_category_id
         INNER JOIN AARAMBULA.ADDRESSES addr
             ON sal_hdr.SHIP_TO_ADDRESS_ID = addr.address_id
GROUP BY cat.product_category, addr.city;


/*15-Identifique las 10 ciudades mas importantes, muestre la categoria de producto 
mas popular por ciudad. (ciudades con mayores ventas)*/
--producto mas vendido por cada ciudad top 10

  SELECT city, product_name, sales_total
    FROM (  SELECT addr.CITY,
                   SUM (sal_dtl.unit_price * sal_dtl.order_qty) AS sales_total,
                   sal_dtl.product_id,
                   prod.product_name,
                   ROW_NUMBER ()
                   OVER (
                       PARTITION BY addr.CITY
                       ORDER BY SUM (sal_dtl.unit_price * sal_dtl.order_qty) DESC)
                       AS product_rank
              FROM aarambula.sales_order_header sal_hdr
                   INNER JOIN aarambula.sales_order_detail sal_dtl
                       ON sal_hdr.SALES_ORDER_ID = sal_dtl.SALES_ORDER_ID
                   INNER JOIN aarambula.products prod
                       ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
                   INNER JOIN AARAMBULA.ADDRESSES addr
                       ON sal_hdr.SHIP_TO_ADDRESS_ID = addr.address_id
          GROUP BY sal_dtl.product_id, prod.product_name, addr.city)
         top_products
   WHERE     top_products.product_rank = 1
         AND top_products.city IN
                 (SELECT top_cities.city
                    FROM (  SELECT addr.CITY,
                                   SUM (sal_dtl.unit_price * sal_dtl.order_qty)
                                       AS total_sales,
                                   ROW_NUMBER ()
                                   OVER (
                                       ORDER BY
                                           SUM (
                                                 sal_dtl.unit_price
                                               * sal_dtl.order_qty) DESC)
                                       AS city_rank
                              FROM aarambula.sales_order_header sal_hdr
                                   INNER JOIN
                                   aarambula.sales_order_detail sal_dtl
                                       ON sal_hdr.SALES_ORDER_ID =
                                              sal_dtl.SALES_ORDER_ID
                                   INNER JOIN AARAMBULA.ADDRESSES addr
                                       ON sal_hdr.SHIP_TO_ADDRESS_ID =
                                              addr.address_id
                          GROUP BY addr.CITY) top_cities
                   WHERE top_cities.city_rank BETWEEN 0 AND 10)
ORDER BY sales_total DESC;

--categoria de producto mas vendido por cada ciudad top 10

  SELECT city, product_category, sales_total
    FROM (  SELECT addr.CITY,
                   SUM (sal_dtl.unit_price * sal_dtl.order_qty) AS sales_total,
                   cat.PRODUCT_CATEGORY,
                   ROW_NUMBER ()
                   OVER (
                       PARTITION BY addr.CITY
                       ORDER BY SUM (sal_dtl.unit_price * sal_dtl.order_qty) DESC)
                       AS product_rank
              FROM aarambula.sales_order_header sal_hdr
                   INNER JOIN aarambula.sales_order_detail sal_dtl
                       ON sal_hdr.SALES_ORDER_ID = sal_dtl.SALES_ORDER_ID
                   INNER JOIN aarambula.products prod
                       ON sal_dtl.PRODUCT_ID = prod.PRODUCT_ID
                   INNER JOIN AARAMBULA.PRODUCT_CATEGORIES cat
                       ON prod.PRODUCT_CATEGORY_ID = cat.product_category_id
                   INNER JOIN AARAMBULA.ADDRESSES addr
                       ON sal_hdr.SHIP_TO_ADDRESS_ID = addr.address_id
          GROUP BY cat.product_category, addr.city) top_products
   WHERE     top_products.product_rank = 1
         AND top_products.city IN
                 (SELECT top_cities.city
                    FROM (  SELECT addr.CITY,
                                   SUM (sal_dtl.unit_price * sal_dtl.order_qty)
                                       AS total_sales,
                                   ROW_NUMBER ()
                                   OVER (
                                       ORDER BY
                                           SUM (
                                                 sal_dtl.unit_price
                                               * sal_dtl.order_qty) DESC)
                                       AS city_rank
                              FROM aarambula.sales_order_header sal_hdr
                                   INNER JOIN
                                   aarambula.sales_order_detail sal_dtl
                                       ON sal_hdr.SALES_ORDER_ID =
                                              sal_dtl.SALES_ORDER_ID
                                   INNER JOIN AARAMBULA.ADDRESSES addr
                                       ON sal_hdr.SHIP_TO_ADDRESS_ID =
                                              addr.address_id
                          GROUP BY addr.CITY) top_cities
                   WHERE top_cities.city_rank BETWEEN 0 AND 10)
ORDER BY sales_total DESC;