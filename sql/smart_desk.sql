/* =========================================================
TAREA FINAL - BASES DE DATOS SQL
CASO: SMART DESK

Alumno: Miguel Angel Castro Torreslanda
========================================================= */


/* =========================================================
CONFIGURACIÓN DEL CONTEXTO
========================================================= */
-- Seleccionar usuario y wh (esto se debería ajustar al de cada usuario)
use role training_role;
use warehouse cobra_wh;

-- Seleccionar base de datos y esquema
use database UCM;
use schema SMART_DESK;

-- Exploración inicial de las tablas
select * 
from sales
order by year, quarter;

select * 
from forecasts;

select * 
from accounts;


select * from targets;


/* =========================================================
CONSULTAS
========================================================= */


/* ---------------------------------------------------------
1. Análisis de Ventas y Beneficio por Categoría de Producto
--------------------------------------------------------- */

select category as "Categoría", sum(maintenance) as Mantenimiento, sum(product) as Producto, sum(parts) as Partes, sum(support) as Soporte, sum(total) as "Total Ventas", sum(units_sold) as "Unidades Vendidas", sum(profit) as "Beneficio Total"
from sales
where account='Adabs Entertainment' and date like '2020%'
group by category
order by "Beneficio Total" desc;

-- Respecto a este primer resultado, creo que podriamos decir que es bastante mejor el margen que se tiene respecto de la categoria electronicos que de sillas. El problema de las sillas es que no nos permite ofrecer el servicio de soporte que al parecer nos permite obtener ingresos extras con la venta de los mismos productos. La diferencia entre los margenes de utilidad es del 36% para los electronicos, y de un 33% para sillas. Esos 3 puntos porcentuales a la larga suman cantidades importantes de dinero.


select  category, sum(units_sold), sum(total), sum(parts),sum(maintenance),sum(support),sum(profit),sum(product), sum(profit)/sum(total)
from sales s
inner join accounts a on s.account=a.account
group by  category
order by  category;



/* ---------------------------------------------------------
2. Comparación de Rendimiento por País en Regiones APAC y EMEA
--------------------------------------------------------- */

-- Primero realice un analisis exploratorio de cuales eran los paises que existian en esas regiones

select distinct country, region
from accounts
where region='APAC' or region='EMEA';

--Despues hago un full outer join primero porque me gusta ver si sobran datos en alguna de las tablas y poder ver que no estoy dejando cosas importantes fuera.

select a.region "Región", a.country "País" , avg(s.total) "Ingreso Promedio", avg(s.units_sold) "Unidades Vendidas Promedio", avg(s.profit) "Beneficio Promedio"
from sales s
full outer join accounts a on s.account=a.account
where a.region='APAC' or a.region='EMEA'
group by a.country, a.region    
order by "Beneficio Promedio" desc;

--De esta tabla, me interesa recalcar que la empresa no tiene presencia en India, a pesar de que sus mejores clientes (mejor beneficio promedio) estan en la región APAC, a lo mejor sería interesante investigar porque no se ha entrado a ese mercado y explorar la posibilida de entrar, al ser uno de los mercados tan grandes, en una region en la que nos va tan bien, podría ser beneficioso empezar a buscar mercado ahi.

select a.region "Región", a.country "País" , count( distinct s.account) ,avg(s.total) "Ingreso Promedio", avg(s.units_sold) "Unidades Vendidas Promedio", avg(s.profit) "Beneficio Promedio", sum(s.profit) "Beneficio Total", sum(units_sold)
from sales s
inner join accounts a on s.account=a.account
where a.region='APAC' or a.region='EMEA'
group by a.country, a.region
order by "Beneficio Promedio" desc;



--Respecto a esta tabla, que ya fue la que se nos solicito, quise agregar ademas dos columnas, una de beneficio total y otra de cuantos clientes/cuentas se tienen en cada uno de los diferentes paises, que me permiten tenen un poco mas de informacion para evaluar los resultados. En primer lugar creo que es importante mencionar que donde mas tenemos cuentas/clientes, es donde no tenemos tanto beneficio, y que a pesar de que vendemos muchas unidades, ni el ingreso promedio ni el beneficio promedio son tan altos. por el contrario parecen estar de la media para abajo. Justo aqui abajo quise hacer un exploratorio por que pensaba que a lo mejor tenia que ver el tipo de producto que se vende, pero tampoco, veamos el caso de Alemania que en la categoria de Break room se vendieron 1664 unidades en promedio, y en Singapur solo 103, pero los beneficios promedio son 3 veces menores! La diferencia es enorme. Mas abajo agregue mas datos a la query para ver si encontraba de donde venia tanta diferencia, pero la verdad por lo que pude ver debe ser el precio al que se venden, porque se vendieron en promedio menos unidades(en magnitud de 15 veces menos) en Singapur, pero el ingreso obtenido por producto, por mantenimiento y por partes promedio es por mucho mas grande en Singapur que en alemania. Yo exploraria expandirme en Singapur y en Australia, ya que nuestra presencia es pequeña, y tenemos el mejor ingreso promedio. el tema o el tradeoff a lo mejor es que en alemania se vende mas barato y por lo tanto tenemos mas volumen, se venden 11.2 millones cuando en Singapur se venden 2.3 millones  y Australia 3.7. Pero el beneficio promedio es mas de 2 veces mayor en Australia (13.4k) y en Singapur (12.5k), que en Alemania (5.6k). A lo mejor explorar la idea de encontrar un mejor equilibrio entre precio y volumen que nos maximice las utilidades totales. Igual es a lo mejor muestra de que la demanda tiene elasticidad en el precio y podriamos buscar subirlo un poco y a lo mejor subir los beneficios.

select a.region "Región", category, a.country "País" , count( distinct s.account) ,avg(s.total) "Ingreso Promedio", avg(s.units_sold) "Unidades Vendidas Promedio", avg(s.profit) "Beneficio Promedio", sum(s.profit) "Beneficio Total"
from sales s
inner join accounts a on s.account=a.account
where a.region='APAC' or a.region='EMEA'
group by a.country, a.region,category
order by 6 desc;


select a.region "Región", category, a.country "País" , avg(parts),avg(maintenance), avg(support), avg(product),count( distinct s.account) ,avg(s.total) "Ingreso Promedio", avg(s.units_sold) "Unidades Vendidas Promedio", avg(s.profit) "Beneficio Promedio", sum(s.profit) "Beneficio Total"
from sales s
inner join accounts a on s.account=a.account
where a.region='APAC' or a.region='EMEA'
group by a.country, a.region,category
order by 10 desc;



/* ---------------------------------------------------------
3. Análisis del Beneficio Total por Industria
Estudio de Clientes en Etapa de Compromiso
--------------------------------------------------------- */

--Primero ver cuales son las empresas que cumplen con las caracteristicas de beneficio factorizado

select account
from forecasts
where prediction_category='Commit'
group by account
having sum(forecast)>500000
order by account;

-- Usando una subconsulta con where, pido que me den un agregado de sales, pero solo de las cuentas que cumplen con la condicion de beneficio factorizado. 

select a.account, sum(maintenance),sum(parts),sum(product), sum(profit), sum(support), sum(total),sum(units_sold)
from sales s
inner join accounts a on s.account=a.account
where a.account in (select account
                    from forecasts
                    where prediction_category='Commit'
                    group by account
                    having sum(forecast)>500000)
group by a.account                    
order by a.account;



--La lista me redujo en numero de 12 en forecast que cumplian con la condicion a 8 en sales, solo queria comprobar con la siguiente query que en efecto hubiera cuentas que estaban en Forecast y que no estuvieran en Sales.

select distinct(s.account) as sales_accounts, f.account as forecast_accounts
from sales s
full outer join (select DISTINCT(account)
                    from forecasts) as f 
                    on s.account=f.account
order by s.account desc;

--Son 4 las empresas que cumplen con la caracteristica de beneficio factorizado pero que no tienen ventas anteriores. Con un right join en la segunda query (en lugar del inner join), podemos ver que las empresas son Fan Tickets, Lowe Recreation, Padberg Health Recruiting y Shoppers FastMart. Dado que califican como beneficio Factorizado, y podrian ayudar a un crecimiento sostenido en el futuro, a lo mejor valdria la pena poner esfurezos o recursos extra en tratar de cerrar estos deals. Sobre todo porque como podemos ver en la consulta de abajo, todos estos tienen un opportunity age de 383, es decir llevan mas de un año en platicas, estando muy por arriba del promedio que esta en 148(igual en la query de abajo puse una funcion ventana para ver el promedio del oportunity age).


select *, avg(opportunity_age) over() as promedio_OA
from forecasts
where account in (select account
                    from forecasts
                    where prediction_category='Commit'
                    group by account
                    having sum(forecast)>500000)
order by account;


-- Despues ya nada mas me faltaba hacer el agregado por las diferentes industrias, pero para eso se tenia que hacer un join para poner las industrias. En esta tabla, podemos ver que en efecto hay varias industrias que nos pueden ayudar a crear escenarios de seguridad financiera, sobre todo porque son empresas que ya nos han dado muchos beneficios y que pueden darnos mas beneficios hacia el futuro. por lo que a lo mejor deberian enfocarse los recursos en esas industrias. 


select industry, 
        sum(profit), 
        case 
        when sum(profit)>1000000 
        then 'Alto'
        else 'Normal' 
        end as "BENEFIT_CATEGORY"
from sales s
inner join accounts a on a.account=s.account
where a.account in (select account
                    from forecasts
                    where prediction_category='Commit'
                    group by account
                    having sum(forecast)>500000)
group by industry;

-- a continuacion hago una query para ver cuales son las industrias que no cumplen con el requisito de Beneficio Factorizado, que creo que tambien es importante visualizar esto. En este caso, como se muestra con el resultado de abajo tenemos solo 7 industrias con Beneficio Factorizado y 9 que no cumplen con dicho requisito. A lo mejor tambien este resultado nos permite ver que a lo mejor tenemos que mejorar nuestra posicion en dichas industrias para tener mejor proyeccion (conseguir mas deals para que se sumen a los forecasts)) y seguridad hacia el futuro.

Select distinct(industry)
from accounts
where industry not in (select industry
                    from sales s
                    inner join accounts a on a.account=s.account
                    where a.account in (select account
                                        from forecasts
                                        where prediction_category='Commit'
                                        group by account
                                        having sum(forecast)>500000)
                    group by industry);




-- No sabia si la calificacion se tenia que hacer sobre la columna de forecast(agregada) o sobre la de profit(agregada) aqui abajo la hice sobre la de forecast, aunque tuve que hacer uso de CTE para poder unir las tres tablas con diferentes agregados. 



with sum_forecast_by_account as (select a.account, sum(forecast) as Sum_forecast, industry
                                from forecasts f
                                join accounts a on a.account= f.account
                                where prediction_category='Commit'
                                group by a.account, industry, prediction_category
                                having sum(forecast)> 500000
                                order by a.account),
sum_account_by_industry as (select a.account, sum(profit) as Total_profit
                                from sales s
                                inner join accounts a on s.account=a.account
                                where a.account in (select account
                                                    from sum_forecast_by_account)
                                group by a.account, industry                    
                                order by a.account)

select f.industry, sum(Total_profit), sum(Sum_forecast), case when sum(Sum_forecast)>1000000 then 'Alto' else 'Normal' end as "BENEFIT_CATEGORY"
from sum_account_by_industry s
inner join sum_forecast_by_account f on s.account=f.account
group by f.industry
order by f.industry;


/* ---------------------------------------------------------
4. Análisis Trimestral Real vs Target (2019–2021)
--------------------------------------------------------- */

Select s.year, s.quarter, target_total, truncate(sum(total),0 ) as Total_Real_Sales,case when Total_Real_Sales>TARGET_TOTAL then 'Cumplio' else 'NO' end as "Cumplio_T", (total_real_sales-TARGET_TOTAL) as Variacion_Ventas, ROUND((Variacion_Ventas*100)/TARGET_TOTAL) || '%'  as "%_V", target_profit,  truncate(sum(profit),0) as Total_Real_Profit, case when Total_Real_Profit>TARGET_PROFIT then 'Cumplio' else 'NO' end as "Cumplio_B", (total_real_profit-TARGET_PROFIT) as Variacion_Beneficio,   ROUND((Variacion_Beneficio*100)/TARGET_PROFIT)|| '%' as "%_B"
from sales s
inner join targets t on s.year=t.year and s.quarter=t.quarter_of_year
group by s.year, s.quarter, target_total, target_profit
order by year, quarter;


-- Agregue cuatro columnas, dos en las que de manera binaria nos dice si se cumplio o no con el target, siento que visualmente es mas facil verlo asi, y por oto lado, agregue otras dos columnas con el porcentual de a cuanto equivale la variacion del target, es decir, por cuanto se supero o cuanto falto para alcanzar el target. Igual siento que nos da un numero proporcional que a lo mejor nos puede permitir interpretar mas facil la informacion que se nos arroja. Igualmente use truncate para facilitar la lectura. En cuanto a los resultados, creo que son muy alentadores, ya que desde el 2 Q de 2020 la empresa ha cumplido constantemente con los targets, y no solo eso, sino que en cada Q se cumple y ademas se ha excedido cada vez en mayor porcentaje los targets!


/* =========================================================
CASO PRÁCTICO: Análisis de Estrategia de catálogo de productos — Smart Desk
========================================================= */

/* ---------------------------------------------------------
1. Pregunta de Negocio
--------------------------------------------------------- */

--¿Existe un mix óptimo de productos en el catálogo de Smart Desk que maximice el beneficio total, y está la empresa gestionando ese mix/catálogo de forma deliberada o es el resultado de la demanda orgánica de cada mercado sin una estrategia explícita detrás?


/* ---------------------------------------------------------
2. Análisis Exploratorio
--------------------------------------------------------- */

SELECT a.region, a.country,
       COUNT(DISTINCT s.account) AS cuentas,
       ROUND(AVG(s.total))       AS ingreso_promedio,
       ROUND(AVG(s.profit))      AS beneficio_promedio,
       ROUND(SUM(s.profit))      AS beneficio_total,
       COUNT(*)                  AS num_transacciones
FROM   sales s
INNER  JOIN accounts a ON s.account = a.account
WHERE  a.region IN ('APAC', 'EMEA')
GROUP  BY a.region, a.country
ORDER  BY beneficio_promedio DESC;



/* ---------------------------------------------------------
3. Respuesta a la Pregunta de Negocio (SQL)
--------------------------------------------------------- */

---Primera consulta

SELECT a.country,
       SUM(s.units_sold)                         AS unidades,
       ROUND(SUM(s.total))                       AS ingresos,
       ROUND(SUM(s.product)/SUM(s.units_sold))   AS precio_unitario,
       ROUND(SUM(s.profit))                      AS beneficio_total,
       COUNT(*)                                  AS transacciones
FROM   sales s
INNER  JOIN accounts a ON s.account = a.account
WHERE  a.region IN ('APAC', 'EMEA')
  AND  s.units_sold > 0
GROUP  BY a.country
ORDER  BY a.country, unidades DESC;


-- Segunda Consulta

SELECT a.region, a.country, s.category, s.year,
       ROUND(SUM(s.product)/SUM(s.units_sold))  AS precio_unitario,
       ROUND(SUM(s.profit)/SUM(s.units_sold))   AS beneficio_por_unidad,
       ROUND(SUM(s.units_sold))                 AS volumen_total,
       ROUND(SUM(s.profit))                     AS beneficio_total
FROM   sales s
INNER  JOIN accounts a ON s.account = a.account
WHERE  s.units_sold > 0
GROUP  BY a.region, a.country, s.category, s.year
ORDER  BY s.category, precio_unitario DESC;

--Tercera Consulta


SELECT a.region, a.country,
       COUNT(*)                                 AS num_transacciones,
       ROUND(AVG(s.units_sold))                 AS unidades_por_transaccion,
       ROUND(AVG(s.total))                      AS ingreso_por_transaccion,
       ROUND(AVG(s.profit))                     AS beneficio_por_transaccion,
       ROUND(SUM(s.product)/SUM(s.units_sold))  AS precio_unitario,
       CASE WHEN precio_unitario > 300 THEN 'alto'
            WHEN precio_unitario >  70 THEN 'medio'
            ELSE                           'bajo'
       END AS "Cat_Prod",
       SUM(profit) AS beneficio_total
FROM   sales s
INNER  JOIN accounts a ON s.account = a.account
GROUP  BY a.region, a.country
ORDER  BY beneficio_por_transaccion DESC;

-- Cuarta Consulta

SELECT a.region,
       ROUND(SUM(s.total), 0)                         AS ingresos_totales,
       ROUND(SUM(s.profit), 0)                        AS beneficio_total,
       ROUND((SUM(s.profit)*100)/SUM(s.total)) || '%' AS margen,
       ROUND(SUM(s.profit)/NULLIF(SUM(s.units_sold),0)) AS beneficio_por_unidad
FROM   sales s
INNER  JOIN accounts a ON s.account = a.account
WHERE  s.units_sold > 0
GROUP  BY a.region
ORDER  BY SUM(s.profit) DESC;


/* ---------------------------------------------------------
4. Reflexión y Sugerencia de Estrategias
(ESTA PARTE SE DESARROLLA ÚNICAMENTE EN EL PDF)
--------------------------------------------------------- */