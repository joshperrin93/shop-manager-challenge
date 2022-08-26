TRUNCATE TABLE orders, items, orders_items RESTART IDENTITY;

INSERT INTO orders (customer_name, date_ordered) VALUES ('Sam', '01-01-2022');
INSERT INTO orders (customer_name, date_ordered) VALUES ('Jade', '11-03-2022');
INSERT INTO orders (customer_name, date_ordered) VALUES ('Laura', '11-06-2022');
INSERT INTO items (item_name, price, quantity) VALUES ('Gig tickets', 49.99, 50);
INSERT INTO items (item_name, price, quantity) VALUES ('Band T-shirt', 19.99, 5);
INSERT INTO items (item_name, price, quantity) VALUES ('Bus travel', 5.00, 25);
INSERT INTO orders_items (order_id, item_id) VALUES (1, 2);
INSERT INTO orders_items (order_id, item_id) VALUES (2, 1);
INSERT INTO orders_items (order_id, item_id) VALUES (2, 3);
INSERT INTO orders_items (order_id, item_id) VALUES (3, 1);
INSERT INTO orders_items (order_id, item_id) VALUES (3, 2);
INSERT INTO orders_items (order_id, item_id) VALUES (3, 3);