# E-Commerce Relational Database Analysis (PostgreSQL)

## Project Overview
An end-to-end SQL analysis project handling **100,000+ transactional records** using PostgreSQL and pgAdmin 4. The project demonstrates database schema design, bulk data ingestion, sales performance analysis, and automated inventory reconciliation.

## Database Schema
The database consists of three relational tables:
- **Books:** Catalog containing titles, authors, genres, prices, and stock levels.
- **Customers:** Demographic and location details across multiple cities.
- **Orders:** Transactional logs tracking customer purchases, order dates, and total amounts.

## Key Business Insights & Operations
1. **Bulk Ingestion:** Ingested 100k+ rows efficiently using PostgreSQL `COPY` commands.
2. **Customer Retention:** Filtered repeat customers with multiple purchases using `GROUP BY` and `HAVING` clauses.
3. **Revenue Analysis:** Tracked top-grossing categories and identified high-value customers driving total sales.
4. **Inventory Tracking:** Solved stock discrepancy issues by calculating real-time remaining inventory using `LEFT JOIN` and `COALESCE()`.

## Tech Stack
- **Database Engine:** PostgreSQL
- **Query Environment:** pgAdmin 4
- **Language:** SQL (DDL, DML, Aggregations, Relational Joins)
