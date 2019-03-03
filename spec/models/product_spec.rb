require 'rails_helper'

RSpec.describe Product, type: :model do
  before do 
    @product = Product.new(
    item_name: :test_item,
    item_price: 100,
    discount: 10
  )
  end
  describe '正常情況' do
    describe '正確建立資料' do
      it 'save' do
        expect(@product).to be_valid
      end
    end
  end

  describe '必要項目' do 
    valid_columns = %w(item_name item_price)
    valid_columns.each do |col|
      it "#{col} 不可為空" do
        @product.send("#{col}=", '')
        expect(@product).not_to be_valid
      end
    end
  end

  describe '內容長度檢測' do
    valid_columns = {
      item_name: 100,
      item_price: 6,
      description: 255
    }
    valid_columns.each do |key, val|
      it "#{key} 長度不可超過#{val}" do
        if key == :item_price
          @product.send("#{key}=", '1' * (val + 1))
        else
          @product.send("#{key}=", 'a' * (val + 1))
        end
        expect(@product).not_to be_valid
      end
    end
  end

  
end
