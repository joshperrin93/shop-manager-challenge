require_relative './item.rb'

class ItemRepository

    def item_list
        sql = 'SELECT * FROM items;'
        result = DatabaseConnection.exec_params(sql, [])
        items = []
        result.each do |record|
            item = Item.new
            item.id = record['id'].to_i
            item.item_name = record['item_name']
            item.price = record['price'].to_f
            item.quantity = record['quantity'].to_i
            
            items << item
        end
        return items
    end

    def item_create(item)
        sql = 'INSERT INTO items (item_name, price, quantity) VALUES ($1, $2, $3);'
        params = [item.item_name, item.price, item.quantity]
        DatabaseConnection.exec_params(sql, params)
        return nil
    end

end