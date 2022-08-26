require 'app'
require 'database_connection'

def reset_shops_table
    seed_sql = File.read('spec/seeds_shop_challenge.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_test' })
    connection.exec(seed_sql)
end

RSpec.describe App do
    before(:each) do 
        reset_shops_table
    end

    # it 'lists all shop items' do
    #     io = double :io
    #     expect(io).to receive(:puts).with("Welcome to the shop management program!\nWhat do you want to do?\n1 = list all shop items\n2 = create a new item\n3 = list all orders\n4 = create a new order\n").ordered
    #     expect(io).to receive(:gets).and_return("1").ordered
    #     expect(io).to receive(:puts).with("#1 - Gig tickets - Price: £49.99 - Quantity: 50\n#2 - Band T-shirt - Price: £19.99 - Quantity: 5\n#3 - Bus travel - Price: £5.0 - Quantity: 25").ordered
    #     app = App.new('shop_manager_test', io, ItemRepository.new, OrderRepository.new)
    #     app.run
    # end

end