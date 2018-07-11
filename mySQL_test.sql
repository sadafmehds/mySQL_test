USE sakila;

-- 1a). Display first names and last names from table actor
SELECT first_name, last_name
FROM actor;

-- 1b).
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

-- Practice: Testing going to lower case from upper case
SET SQL_SAFE_UPDATES=0;

UPDATE actor 
SET first_name = LOWER(first_name)
WHERE LOWER(first_name) = first_name;

-- 2a)
SELECT*FROM actor WHERE first_name='JOE';

-- 2b) 
SELECT*FROM actor WHERE last_name LIKE '%GEN%'; 

-- 2c) reorder columns and select from one column the cells that contain 'LI'

ALTER TABLE actor MODIFY COLUMN first_name VARCHAR(100) AFTER last_name;
SELECT*FROM actor WHERE last_name LIKE '%LI%';

SELECT*FROM country;

-- 2d)
SELECT country_id,country
FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');

-- 3a)
ALTER TABLE actor ADD COLUMN middle_name VARCHAR(100) AFTER last_name; 

SELECT*FROM actor;

-- 3b).
ALTER TABLE actor MODIFY COLUMN middle_name BLOB;

-- 3c).
ALTER TABLE actor DROP COLUMN middle_name;
SELECT*FROM actor;

-- 4a) Count how many of each last name there is in the last_name column
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

-- 4b).
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*)>1;

-- 4c). 
UPDATE actor
SET first_name='HARPO'
WHERE first_name='GROUCHO';

-- 4d)
UPDATE actor
SET first_name='GROUCHO'
WHERE first_name='HARPO';

-- 5a).
SHOW CREATE TABLE address;

-- CREATE TABLE `address` (\n  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,\n  `address` varchar(50) NOT NULL,\n  `address2` varchar(50) DEFAULT NULL,\n  `district` varchar(20) NOT NULL,\n  `city_id` smallint(5) unsigned NOT NULL,\n  `postal_code` varchar(10) DEFAULT NULL,\n  `phone` varchar(20) NOT NULL,\n  `location` geometry NOT NULL,\n  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n  PRIMARY KEY (`address_id`),\n  KEY `idx_fk_city_id` (`city_id`),\n  SPATIAL KEY `idx_location` (`location`),\n  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

-- 6a).
		-- address: address id, address, district, city id, postal code, phone, location, last update
		-- staff: staff id, first name, last name, address id, picture, email, store id, actuve, username, password, last update
SELECT first_name, last_name, address
FROM address a
JOIN staff s
ON (s.address_id=a.address_id);

-- OR

SELECT first_name, last_name, address
FROM staff
JOIN address
USING (address_id);

SELECT first_name, last_name, address
FROM staff
JOIN address
USING (address_id);

-- 6b). ask about join method later, used a diff way
select*from staff;
select*from payment;
	-- payment: payment_id,cutomer_id,amount, rental_id, staff_id, payment_date, last_update
    -- staff: staff id, first name, last name, address id, picture, email, store id, actuve, username, password, last update

select year(payment_date) as y, month(payment_date) as m, staff_id as staff_no, sum(amount) as p
from payment
group by year(payment_date), month(payment_date), staff_no;

-- 6c). Get counts of actors in each movie via inner merge
select*from film;	-- film_id,title,description,
select*from film_actor;	-- actor_id,film_id


select film.title,count(actor_id)
from film
inner join film_actor on film.film_id=film_actor.film_id
GROUP by title;

-- 6d).
select*from inventory;	
select*from film;

select count(*) as copy_number
from inventory
where film_id in
(
select film_id 
from film
where title='Hunchback Impossible');

-- 6e).
-- 6e).
select*from payment; -- customer_id,payment_id, staff_id, amount	
select*from customer; -- customer_id,store_id, first_name, last_name, email

select first_name, last_name,sum(amount)
from payment p
join customer c
on (c.customer_id=p.customer_id)
GROUP BY first_name,last_name
ORDER BY last_name;