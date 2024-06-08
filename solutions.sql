use sakila;


-- 1. ¿Cuántas copias de la película El Jorobado Imposible existen en el sistema de inventario?


select count(*) as cantidad_de_copias
from inventory
where film_id = (
	select film_id 
	from film 
	where title like '%hunchback%' and title like '%impossible%'
);


-- 2. Lista todas las películas cuya duración sea mayor que el promedio de todas las películas.

select *
from film
where length > (select avg(length) from film);

-- 3. Usa subconsultas para mostrar todos los actores que aparecen en la película Viaje Solo.


select a.*
from actor a
join film_actor fa on a.actor_id = fa.actor_id
where fa.film_id = (
	select film_id 
	from film 
    where title like '%alone%' and title like '%trip%'
);

-- 4. Las ventas han estado disminuyendo entre las familias jóvenes, y deseas dirigir todas las películas familiares a una promoción. Identifica todas las películas categorizadas como películas familiares.


select *
from film
where film_id in (
	select film_id from 
	film_category 
	where category_id = (
		select category_id 
        from category 
        where name = 'Family'
	)
);

-- 5. Obtén el nombre y correo electrónico de los clientes de Canadá usando subconsultas. Haz lo mismo con uniones. Ten en cuenta que para crear una unión, tendrás que identificar las tablas correctas con sus claves primarias y claves foráneas, que te ayudarán a obtener la información relevante.

select first_name, last_name, email
from customer
where address_id in (
	select address_id 
    from address 
    where city_id in (
		select city_id from 
        city where country_id in (
			select country_id 
            from country 
            where country = 'Canada'
		)
	)
);


select c.first_name, c.last_name, c.email
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = 'Canada';

-- 6. ¿Cuáles son las películas protagonizadas por el actor más prolífico? El actor más prolífico se define como el actor que ha actuado en el mayor número de películas. Primero tendrás que encontrar al actor más prolífico y luego usar ese actor_id para encontrar las diferentes películas en las que ha protagonizado.

select f.title
from film f
join film_actor fa on f.film_id = fa.film_id
where fa.actor_id = (
    select actor_id
    from film_actor
    group by actor_id
    order by count(*) desc
    limit 1
);

-- 7. Películas alquiladas por el cliente más rentable. Puedes usar la tabla de clientes y la tabla de pagos para encontrar al cliente más rentable, es decir, el cliente que ha realizado la mayor suma de pagos.

select film.title
from film
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
where rental.customer_id = (
    select customer_id
    from payment
    group by customer_id
    order by sum(amount) desc
    limit 1
);

-- 8. Obtén el client_id y el total_amount_spent de esos clientes que gastaron más que el promedio del total_amount gastado por cada cliente.

select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having sum(amount) > (
	select avg(total_amount) 
    from (
		select customer_id, sum(amount) as total_amount 
        from payment 
        group by customer_id
	) as avg_amount
);

