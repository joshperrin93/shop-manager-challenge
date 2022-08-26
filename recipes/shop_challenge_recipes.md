wo Tables Design Recipe Template
Copy this recipe template to design and create two related database tables from a specification.

1. Extract nouns from the user stories or specification
# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a shop manager
So I can know which items I have in stock
I want to keep a list of my shop items with their name and unit price.

As a shop manager
So I can know which items I have in stock
I want to know which quantity (a number) I have for each item.

As a shop manager
So I can manage items
I want to be able to create a new item.

As a shop manager
So I can know which orders were made
I want to keep a list of orders with their customer name.

As a shop manager
So I can know which orders were made
I want to assign each order to their corresponding item.

As a shop manager
So I can know which orders were made
I want to know on which date an order was placed. 

As a shop manager
So I can manage orders
I want to be able to create a new order.

Nouns:
data points:
ITEMS, names, price, quantity, ORDERS, customer name, date
methods:
list (item and order), create (item and order)

2. Infer the Table Name and Columns
Put the different nouns in this table. Replace the example with your own nouns.

Record | Properties
items    item_name, price, quantity
orders   customer_name, date_ordered

3. Decide the column types.
Here's a full documentation of PostgreSQL data types.

Most of the time, you'll need either text, int, bigint, numeric, or boolean. If you're in doubt, do some research or ask your peers.

Remember to always have the primary key id as a first column. Its type will always be SERIAL.

# EXAMPLE:

Table: items
id: SERIAL
item_name: text
price: float
quantity: int


Table: orders
id: SERIAL
customer_name: text
date_ordered: date

4. Decide on The Tables Relationship
Most of the time, you'll be using a one-to-many relationship, and will need a foreign key on one of the two tables.

To decide on which one, answer these two questions:

Can one items have many orders? Yes
Can one order have many items? Yes

# EXAMPLE


5. Design the Join Table
The join table usually contains two columns, which are two foreign keys, each one linking to a record in the two other tables.

The naming convention is table1_table2.

# EXAMPLE

Join table for tables: items and orders
Join table name: orders_items
Columns: order_id, item_id

6. Write the SQL.
-- EXAMPLE
-- file: orders_items.sql

-- Replace the table name, columm names and types.

-- Create the first table.
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_name text,
  date_ordered date
);

-- Create the second table.
CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  item_name text,
  price float,
  quantity int
);

-- Create the join table.
CREATE TABLE orders_items (
  order_id int,
  item_id int,
  constraint fk_order foreign key(order_id) references orders(id) on delete cascade,
  constraint fk_item foreign key(item_id) references items(id) on delete cascade,
  PRIMARY KEY (order_id, item_id)
);

5. Create the tables.
psql -h 127.0.0.1 database_name < shop.sql