# SQL Scripts for Store Management 👩🏻‍💻☕
Welcome! This repository contains a set of SQL scripts developed as part of a practical project to simulate the core operations of a retail store system. These scripts were designed to work with MySQL and implement several typical database tasks — from creating tables and inserting sample data, to managing complex operations like order processing and cancellation through stored procedures and triggers.

The goal of this project is to demonstrate how SQL can be used not just for data storage, but also to handle business logic at the database level in a clean, consistent, and transaction-safe way.

## What You’ll Find Here 📑

- create-insert-select.sql
This script creates all the necessary tables (Clients, Vendors, Products, Orders, etc.), inserts a complete dataset with sample values, and includes multiple example queries to analyze sales data, customer activity, and product statistics.

- procedure-anularpedido.sql
This stored procedure allows you to cancel an existing order. It performs multiple checks (like whether the order exists or is already canceled), restores the product stock, and updates the order status. It also includes error handling and uses a cursor to process each item in the order.

- procedure-registrarpedido.sql
A handy procedure that updates the unit prices of products based on their origin (nacional or importado) by applying a percentage increase or decrease.

- procedure-actualizarpreciospororigen.sql
This stored procedure allows you to cancel an existing order. It performs multiple checks (like whether the order exists or is already canceled), restores the product stock, and updates the order status. It also includes error handling and uses a cursor to process each item in the order.

- create-tablalog & trigger-tablalog
These files (not viewable here but part of the project) create a log table and its associated trigger to automatically register events — like when an order gets canceled — enhancing data traceability.

## For Testing and Learning 📚
All procedures and queries include test cases and sample calls, so you can run them directly to see how they work. This makes the project especially useful for students or anyone learning SQL who wants to see real-world logic implemented using:

- Transactions
- Cursors
- Conditionals and error handling
- Triggers
- Table relationships and constraints

