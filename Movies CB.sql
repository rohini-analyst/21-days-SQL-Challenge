use moviesdb;
SHOW DATABASES;       -- Check if moviesdb exists
/* USE moviesdb;          -- Switch to moviesdb
SHOW TABLES;           -- List all tables in moviesdb
SELECT * FROM movies;  -- Query a table inside moviesdb
*/
SHOW TABLES;
describe movies;
show databases;
use moviesdb;
show TABLES from gdb041;
select * from gdb041.dim_customer;

select * from movies;

select distinct industry from movies;

select count(*)
from movies
where industry='bollywood';

select * from movies
where title like '%Thor%';

select * 
from movies 
where studio='';

select * 
from movies 
where imdb_rating in (6,7,8,9);

select * 
from movies 
where release_year = 2018 or release_year= 2022;

select * 
from movies 
where release_year in (2018,2019,2020,2021,2022)
order by release_year desc;

select * 
from movies 
where imdb_rating is null;

select * 
from movies 
where industry='bollywood'
order by imdb_rating desc;

select * 
from movies 
where industry='bollywood'
order by imdb_rating desc 
limit 10 offset 4;

select distinct studio from movies;
select * from movies where studio='Dharma Productions';

select round(avg(imdb_rating),2) as avg_rating from movies where studio='Dharma Productions';



-- Fetch all columns from the movies table
select * from movies;

-- Display only the first 5 movies
select * from movies limit 5;

-- Get distinct industries from the movies table
select distinct industry from movies;

-- Find all movies released after 2015
select title, release_year
from movies 
where release_year > 2015;

-- Find all Bollywood movies
select title, industry
from movies 
where industry ='bollywood';

-- List movie titles and their release year
select title, release_year
from movies ;

-- Find movies with an IMDb rating greater than 8
select title, imdb_rating
from movies 
where imdb_rating > 8;

-- Find movies with an IMDb rating between 7 and 9
select title, imdb_rating
from movies 
where imdb_rating between 7 and 9;


-- Find movies where the studio is NULL
select title, studio
from movies 
where studio is null;

-- Count total number of movies
select count(*) 
from movies;

-- Count total number of movies per industry
select industry, count(*) as total_movies
from movies
group by industry;

-- Find the average IMDb rating of all movies
select round(avg(imdb_rating),1) as avg_rating
from movies; 

-- Find the maximum IMDb rating
select round(max(imdb_rating),1) as max_rating
from movies; 

-- Find the minimum IMDb rating
select round(min(imdb_rating),1) as min_rating
from movies;

-- Find movies released in the year 2020
select title, release_year
from movies
where release_year = 2020;

-- Find movies whose title starts with 'A'
select title
from movies
where title like 'A%';

-- Find movies whose title contains the word 'Love'
select title
from movies
where title like '%Love%';

-- Sort movies by IMDb rating in descending order
select title, imdb_rating
from movies
order by imdb_rating desc ;
-- Sort movies by release year (latest first)
select title, release_year
from movies
order by release_year desc;

-- Find top 5 highest rated movies
select title, imdb_rating
from movies
order by imdb_rating desc 
limit 5;

-- Find bottom 5 lowest rated movies
select title, imdb_rating
from movies
order by imdb_rating asc 
limit 5;

-- Find number of movies released per year
select release_year, count(*) as no_of_movie_released
from  movies
group by release_year
order by no_of_movie_released desc;

-- Find movies released between 2010 and 2020
select title, release_year
from  movies
where release_year between 2010 and 2020;
 
-- Find movies where language_id is not NULL
select title, language_id
from  movies
where language_id is not null;

-- Find movies where IMDb rating is NULL
select title, imdb_rating
from  movies
where imdb_rating is null;
select distinct studio from movies;
-- Find movies produced by a specific studio
select title, studio 
from movies 
where studio ='Marvel Studios';


-- Find total movies per studio
select studio , count(*) as Total_Movies
from movies 
group by studio
order by Total_Movies desc;

-- Find studios with more than 5 movies
select studio , count(*) as Total_Movies
from movies 
group by studio
having Total_Movies >5;

-- Find movies from multiple industries using IN
select title, studio 
from movies 
where studio in ('Marvel Studios', 'Hombale Films', 'Warner Bros. Pictures');

-- Find movies that are not from Bollywood
select * 
from movies 
where industry <> 'bollywood';

-- Add an alias to columns for better readability
select title,max(imdb_rating) as max_rating
from movies;

-- Find movies with IMDb rating above the overall average rating
select title, imdb_rating
from movies
having imdb_rating >(select avg(imdb_rating) 
					from movies);


-- Find the latest released movie
select title, release_year
from movies
order by release_year desc
limit 1;

-- Find the oldest movie in the dataset
select title, release_year
from movies
order by release_year 
limit 1;

-- Find movies where release year is missing
select title, release_year
from movies
where release_year is null or release_year = '' or release_year=0;

-- Find movies sorted by title alphabetically
select title 
from movies
order by  title; 

-- Find movies that do not have a studio assigned
select title, studio
from movies
where studio is null;

-- Fetch movie title, industry, and IMDb rating only
select title, industry, imdb_rating
from movies;

-- Find movies released in the last 3 years (based on max year)
select title, release_year
from movies 
where release_year >= (select MAX(release_year) - 2 from movies);



