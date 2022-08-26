require 'order_repository'
require 'database_connection'

def reset_shops_table
    seed_sql = File.read('spec/seeds_shop_challenge.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_test' })
    connection.exec(seed_sql)
end
  
describe OrderRepository do
    before(:each) do 
      reset_shops_table
    end
  
    it 'returns a list of all orders' do
        repo = OrderRepository.new

        all_orders = repo.order_list

        expect(all_orders.length).to eq 3

        expect(all_orders[0].id).to eq 1
        expect(all_orders[0].customer_name).to eq 'Sam'
        expect(all_orders[0].date_ordered).to eq '2022-01-01'

        
        expect(all_orders[1].id).to eq 2
        expect(all_orders[1].customer_name).to eq 'Jade'
        expect(all_orders[1].date_ordered).to eq '2022-11-03'

        
        expect(all_orders[2].id).to eq 3
        expect(all_orders[2].customer_name).to eq 'Laura'
        expect(all_orders[2].date_ordered).to eq '2022-11-06'
    end

    it 'creates a new order' do
        repo = OrderRepository.new
        new_order = Order.new

        new_order.customer_name = 'Yvonne'
        new_order.date_ordered = '2022-08-26'
        new_order.ordered_items = [1, 2, 3]

        repo.order_create(new_order)

        all_orders = repo.order_list

        expect(all_orders.length).to eq 4
        expect(all_orders.last.id).to eq 4
        expect(all_orders.last.customer_name).to eq 'Yvonne'
        expect(all_orders.last.date_ordered).to eq '2022-08-26'
    end

    it 'returns items for a specific order' do
        repo = OrderRepository.new
        expect(repo.find_order(2)).to eq 'Gig tickets, Bus travel'
    end

    it 'returns items for a new order' do
        repo = OrderRepository.new
        new_order = Order.new

        new_order.customer_name = 'Yvonne'
        new_order.date_ordered = '2022-08-26'
        new_order.ordered_items = [1, 2, 3]

        repo.order_create(new_order)
        expect(repo.find_order(4)).to eq 'Gig tickets, Band T-shirt, Bus travel'
    end
end