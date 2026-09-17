-- remove the database if it already exists
drop database if exists amazon_india;

-- create the database
create database amazon_india;

-- use the database
use amazon_india;

-- create the product table
create table amazon_india_products (
    asin varchar(20),
    product_title text,
    category varchar(255),
    product_price decimal(10,2),
    original_price decimal(10,2),
    discount decimal(5,2),
    product_rating decimal(3,2),
    num_ratings int,
    num_offers int,
    is_prime varchar(20),
    is_best_seller varchar(20),
    is_amazon_choice varchar(20),
    climate_pledge_friendly varchar(20),
    scraped_at varchar(100),
    total_rating_points int,
    price_range varchar(50),
    rating_range varchar(50),
    discount_range varchar(50),
    primary key (asin)
);

-- load data from the csv file
load data local infile 'd:/new folder/amazon_india_products_final.csv'
into table amazon_india_products
character set utf8mb4
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
(
    @asin,
    @product_title,
    @category,
    @product_price,
    @original_price,
    @discount,
    @product_rating,
    @num_ratings,
    @num_offers,
    @is_prime,
    @is_best_seller,
    @is_amazon_choice,
    @climate_pledge_friendly,
    @scraped_at,
    @total_rating_points,
    @price_range,
    @rating_range,
    @discount_range
)
set
    asin = nullif(trim(@asin), ''),
    product_title = nullif(trim(@product_title), ''),
    category = nullif(trim(@category), ''),
    product_price = nullif(
        replace(replace(replace(trim(@product_price), '₹', ''), ',', ''), ' ', ''),'' ),
        
    original_price = nullif(
        replace(replace(replace(trim(@original_price), '₹', ''), ',', ''), ' ', ''),''),

    discount = nullif(
        replace(replace(trim(@discount), '%', ''), ' ', ''),''),

    product_rating = nullif(trim(@product_rating), ''),

    num_ratings = nullif(
        replace(trim(@num_ratings), ',', ''),''),

    num_offers = nullif(trim(@num_offers), ''),
    is_prime = nullif(trim(@is_prime), ''),
    is_best_seller = nullif(trim(@is_best_seller), ''),
    is_amazon_choice = nullif(trim(@is_amazon_choice), ''),
    climate_pledge_friendly = nullif(trim(@climate_pledge_friendly), ''),
    scraped_at = nullif(trim(@scraped_at), ''),
    
    total_rating_points = nullif(
        replace(trim(@total_rating_points), ',', ''),''),

    price_range = nullif(trim(@price_range), ''),
    rating_range = nullif(trim(@rating_range), ''),
    discount_range = nullif(trim(@discount_range), '');


-- view the first 10 products
select *
from amazon_india_products
limit 10;

-- check the table structure
describe amazon_india_products;

-- count the total number of products
select 
count(*) as total_products
from amazon_india_products;

-- count products in each category
select category, 
count(*) as product_count
from amazon_india_products
group by category
order by product_count desc;

-- check price details for each category
select category,
    count(*) as product_count,
    round(avg(product_price), 2) as average_price,
    round(min(product_price), 2) as lowest_price,
    round(max(product_price), 2) as highest_price
from amazon_india_products
where product_price is not null
group by category
order by average_price desc;

-- count products in each price range
select
price_range, count(*) as product_pricerange_count
from amazon_india_products
group by price_range
order by product_count desc;

-- find products with the highest discount
select
product_title, product_price, original_price, discount
from amazon_india_products
where discount is not null
order by discount desc
limit 10;

-- find the most expensive products
select
product_title, category, product_price
from amazon_india_products
where product_price is not null
order by product_price desc
limit 10;

-- find products with the highest number of ratings
select
product_title, product_price, num_ratings
from amazon_india_products
where num_ratings is not null
order by num_ratings desc
limit 10;

-- get the overall product summary
select
    count(*) as total_products,
    count(distinct category) as total_categories,
    round(avg(product_price), 2) as average_product_price,
    round(min(product_price), 2) as minimum_price,
    round(max(product_price), 2) as maximum_price,
    round(avg(discount), 2) as average_discount
from amazon_india_products;


