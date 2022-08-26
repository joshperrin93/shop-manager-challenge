require_relative './database_connection'
require_relative './item_repository'
require_relative './order_repository'

class App

    def initialize(database_name, io, item_repository, order_repository)
        DatabaseConnection.connect(database_name)
        @io = io
        @item_repository = item_repository
        @order_repository = order_repository
    end
    
    def run
        print_intro
        make_choice
        if @io.to_i == 1
            result = @item_repository.item_list
            puts item_list_formatter(result)
        elsif @io.to_i == 2
            new_item = Item.new
            user_item_creator(new_item)
            @item_repository.item_create(new_item)
        elsif @io.to_i == 3
            result = @order_repository.order_list
            puts order_list_formatter(result)
        elsif @io.to_i == 4
            new_order = Order.new
            user_order_creator(new_order)
            @order_repository.order_create(new_order)
        else
            puts "please re-enter"
        end
    end

    private

    def print_intro
        @io.puts "Welcome to the shop management program!\nWhat do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = list all orders\n4 = create a new order\n"
    end
    
    def make_choice
        @io = gets.chomp
    end

    def item_list_formatter(result)
        formatted_list = []
        result.each do |item|
            formatted_item = "##{item.id} - #{item.item_name} - Price: £#{item.price} - Quantity: #{item.quantity}"
            formatted_list << formatted_item
        end
        return formatted_list.join("\n")
    end

    def order_list_formatter(result)
        formatted_list = []
        result.each do |order|
            binding.irb
            formatted_order = "##{order.id} - #{order.customer_name} - Ordered on: #{order.date_ordered} - Ordered: #{find_order(order.id)}"
            formatted_list << formatted_order
        end
        return formatted_list.join("\n")
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

    def user_item_creator(new_item)
        puts "Enter new item name:"
        new_item.item_name = gets.chomp
        puts "Enter new item price:"
        new_item.price = gets.chomp
        puts "Enter new item quantity:"
        new_item.quantity = gets.chomp
        return new_item
    end

    def user_order_creator(new_order)
        puts "Enter name:"
        new_order.customer_name = gets.chomp
        new_order.date_ordered =  Time.now.strftime("%Y-%m-%d")
        puts "Enter items you would like to order from the list below, inputting each item ID between commas"
        result = @item_repository.item_list
        puts item_list_formatter(result)
        users_order = gets.chomp
        new_order.ordered_items = item_order_formatter(users_order)
        binding.irb
        return new_order
    end

    def item_order_formatter(users_order)
        order_array = users_order.gsub(" ","").split(',')
        return order_array.map { |item| item.to_i }
    end
end

if __FILE__ == $0
    app = App.new(
        'shop_manager_test',
        Kernel,
        ItemRepository.new,
        OrderRepository.new
    )
    app.run
end