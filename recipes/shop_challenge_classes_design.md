Shop Challenge Model and Repository Classes Design Recipe
Copy this recipe template to design and implement Model and Repository classes for a database table.

1. Design and create the Table
If the table is already created in the database, you can skip this step.

2. Create Test SQL seeds
Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

-- EXAMPLE
-- (file: spec/seeds_shop_challenge.sql)

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


Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql

3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by Repository for the Repository class name.

# EXAMPLE
# Table name: students

# Model class
# (in lib/item.rb)
class Item
end

# Repository class
# (in lib/item_repository.rb)
class ItemRepository
end

# Model class
# (in lib/order.rb)
class Order
end

# Repository class
# (in lib/order_repository.rb)
class OrderRepository
end

4. Implement the Model class
Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

# EXAMPLE
# Table name: item

# Model class
# (in lib/item.rb)

class Item
  attr_accessor :id, :item_name, :price, :quantity
end

# Table name: orders

# Model class
# (in lib/order.rb)

class Order
  attr_accessor :id, :customer_name, :date_ordered
end

5. Define the Repository Class interface
Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

# EXAMPLE
# Table name: items

# Repository class
# (in lib/item_repository.rb)

class ItemRepository

  # Selecting all records
  # No arguments
  def list
    # Executes the SQL query:
    # SELECT * FROM items;

    # Returns an array of Item objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def create(item)
    # Executes the SQL query:
    # INSERT INTO items (item_name, price, quantity) VALUES ($1, $2, $3);
    # creates a new item
  end
end

# Table name: orders

# Repository class
# (in lib/order_repository.rb)

class OrderRepository

  # Selecting all records
  # No arguments
  def list
    # Executes the SQL query:
    # SELECT * FROM orders;

    # Returns an array of Order objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def create(order)
    # Executes the SQL query:
    # INSERT INTO orders (customer_name, date_ordered) VALUES ($1, $2);
    # creates a new order, will also need a way of selecting itesm to add to order
  end
end




6. Write Test Examples
Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

# EXAMPLES

# 1
# Get all items

repo = ItemRepository.new

all_items = repo.all

all_items.length # =>  3

all_items[0].id # =>  1
all_items[0].item_name # =>  'Gig tickets'
all_items[0].price # => 49.99
all_items[0].quantity # =>  50

all_items[0].id # =>  2
all_items[0].item_name # =>  'Band T-shirt'
all_items[0].price # => 19.99
all_items[0].quantity # =>  5

all_items[0].id # =>  3
all_items[0].item_name # =>  'Bus travel'
all_items[0].price # => 5.0
all_items[0].quantity # =>  25

# 2
# creates a new item

repo = ItemRepository.new
new_item = Item.new

new_item.item_name = 'Wristband'
new_item.price = 2.5
new_item.quantity = 2

repo.create(new_item)

all_items = repo.all

all_items.length # => 4
all_items.last.id # =>  4
all_items.last.item_name # =>  'Bus travel'
all_items.last.price # => 5.0
all_items.last.quantity # =>  25

# 3
# creates a new order

repo = OrderRepository.new
new_order = Order.new

new_order.customer_name = 'Yvonne'
new_order.order_date = 2022-08-26
new_order.ordered_items = [1, 2]

repo.create_order(new_order)

all_orders = repo.order_list

all_orders.length # => 4
all_orders.last.id # =>  4
all_orders.last.customer_name # =>  'Yvonne'
all_orders.last.order_date # => 2022-08-26
# all_orders.last.ordered_items # =>  [1, 2]


7. Reload the SQL seeds before each test run
Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_shops_table
  seed_sql = File.read('spec/seeds_shop_challenge.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_challenge_test' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_shops_table
  end

  # (your tests will go here).
end

8. Test-drive and implement the Repository class behaviour
After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.