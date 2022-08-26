require_relative './order.rb'

class OrderRepository

    def order_list
        sql = 'SELECT * FROM orders;'
        result = DatabaseConnection.exec_params(sql, [])
        orders = []
        result.each do |record|
            order = Order.new
            order.id = record['id'].to_i
            order.customer_name = record['customer_name']
            order.date_ordered = record['date_ordered']
            
            orders << order
        end
        return orders
    end

    def order_create(order)
        sql = 'INSERT INTO orders (customer_name, date_ordered) VALUES ($1, $2);'
        params = [order.customer_name, order.date_ordered]
        DatabaseConnection.exec_params(sql, params)
        order.ordered_items.each do |item|
            sql = 'INSERT INTO orders_items (order_id, item_id) VALUES ($1, $2);'
            params = [order_list[-1].id, item]
            DatabaseConnection.exec_params(sql, params)
        end
        return nil
    end

    def find_order(id)
        sql = 'SELECT items.id, items.item_name
                FROM items
                JOIN orders_items ON orders_items.item_id = items.id
                JOIN orders ON orders_items.order_id = orders.id
                WHERE orders.id = $1;'
        params = [id]
        result = DatabaseConnection.exec_params(sql, params)
        items = []
        result.each do |record|
            item = record['item_name']
            items << item
        end
        return items.join(', ')
    end

    def insert_join_table(order)
    end

end