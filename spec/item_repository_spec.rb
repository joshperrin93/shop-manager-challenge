require 'item_repository'
require 'database_connection'

def reset_shops_table
    seed_sql = File.read('spec/seeds_shop_challenge.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'shop_manager_test' })
    connection.exec(seed_sql)
end
  
describe ItemRepository do
    before(:each) do 
      reset_shops_table
    end
  
    it 'returns a list of all items' do
        repo = ItemRepository.new

        all_items = repo.item_list

        expect(all_items.length).to eq 3

        expect(all_items[0].id).to eq 1
        expect(all_items[0].item_name).to eq 'Gig tickets'
        expect(all_items[0].price).to eq 49.99
        expect(all_items[0].quantity).to eq 50
        
        expect(all_items[1].id).to eq 2
        expect(all_items[1].item_name).to eq 'Band T-shirt'
        expect(all_items[1].price).to eq 19.99
        expect(all_items[1].quantity).to eq 5
        
        expect(all_items[2].id).to eq 3
        expect(all_items[2].item_name).to eq 'Bus travel'
        expect(all_items[2].price).to eq 5.0
        expect(all_items[2].quantity).to eq 25
    end

    it 'creates a new item' do
        repo = ItemRepository.new
        new_item = Item.new

        new_item.item_name = 'Wristband'
        new_item.price = 2.5
        new_item.quantity = 2

        repo.item_create(new_item)

        all_items = repo.item_list

        expect(all_items.length).to eq 4
        expect(all_items.last.id).to eq 4
        expect(all_items.last.item_name).to eq 'Wristband'
        expect(all_items.last.price).to eq 2.5
        expect(all_items.last.quantity).to eq 2
    end
end