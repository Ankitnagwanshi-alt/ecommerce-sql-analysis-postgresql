-- =============================================
-- 1. DATABASE SCHEMA SETUP
-- =============================================

DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE books (
    book_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100), 
    genre VARCHAR(50), 
    published_year INT,
    price NUMERIC(10,2),
    stock INT
);

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50),
    country VARCHAR(150)
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) REFERENCES customers(customer_id),
    book_id VARCHAR(10) REFERENCES books(book_id),
    order_date DATE,
    quantity INT,
    total_amount NUMERIC(10, 2)
);

-- VERIFY TABLE STRUCTURE
SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

-- =============================================
-- 2. BULK DATA INGESTION (100K RECORDS)
-- =============================================

COPY books (book_id, title, author, genre, published_year, price, stock)
FROM 'C:\import csv\books_data_100k.csv'
CSV HEADER;

COPY customers (customer_id, name, email, phone, city, country)
FROM 'C:\import csv\customers_data_100k.csv'
CSV HEADER;

COPY orders (order_id, customer_id, book_id, order_date, quantity, total_amount)
FROM 'C:\import csv\orders_data_100k.csv'
CSV HEADER;

-- =============================================
-- 3. BASIC & INTERMEDIATE BUSINESS QUERIES
-- =============================================

-- Retrieve all books in the 'Business' genre
SELECT * FROM books
WHERE genre = 'Business';

-- Find books published after the year 1950
SELECT * FROM books 
WHERE published_year > 1950;

-- List all customers located in Bhopal
SELECT * FROM customers
WHERE city = 'Bhopal';

-- Show orders placed in November 2023
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- Retrieve total stock of books available across inventory
SELECT SUM(stock) AS total_stock
FROM books;

-- Find details of the most expensive book
SELECT * FROM books 
ORDER BY price DESC 
LIMIT 1;

-- Show orders where quantity is greater than 1
SELECT * FROM orders 
WHERE quantity > 1;

-- Retrieve all orders where total amount exceeds $20
SELECT * FROM orders 
WHERE total_amount > 20;

-- List all distinct genres available in the books catalog
SELECT DISTINCT genre 
FROM books;

-- Find the book with the lowest inventory stock
SELECT * FROM books 
ORDER BY stock ASC 
LIMIT 1;

-- Calculate total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue 
FROM orders;

-- =============================================
-- 4. ADVANCED RELATIONAL ANALYTICS
-- =============================================

-- Total quantity of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS total_books_sold 
FROM orders o
JOIN books b ON o.book_id = b.book_id 
GROUP BY b.genre;

-- Average price of books in the 'Business' genre
SELECT AVG(price) AS average_price 
FROM books
WHERE genre = 'Business';

-- Identify customers who placed 2 or more orders (Customer Retention)
SELECT o.customer_id, c.name, COUNT(o.order_id) AS order_count 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id 
GROUP BY o.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;

-- Find the most frequently ordered book
SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM orders o
JOIN books b ON o.book_id = b.book_id 
GROUP BY o.book_id, b.title
ORDER BY order_count DESC 
LIMIT 1;

-- Show top 3 most expensive books in 'Business' genre
SELECT * FROM books 
WHERE genre = 'Business'
ORDER BY price DESC 
LIMIT 3;

-- Total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) AS total_books_sold 
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY b.author;

-- Distinct cities where orders exceeded $30
SELECT DISTINCT c.city 
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id 
WHERE o.total_amount > 30;

-- Highest spending customer (Customer Lifetime Value)
SELECT 
    c.customer_id, 
    c.name, 
    SUM(o.total_amount) AS total_spent
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC 
LIMIT 1;

-- Inventory reconciliation: Calculate remaining stock after fulfilled orders
SELECT 
    b.book_id, 
    b.title, 
    b.stock, 
    COALESCE(SUM(o.quantity), 0) AS order_quantity,
    b.stock - COALESCE(SUM(o.quantity), 0) AS remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock
ORDER BY b.book_id;