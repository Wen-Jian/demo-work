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
    context '正確建立資料' do
      it 'save' do
        expect(@product).to be_valid
      end
    end
  end

  context '必要項目' do 
    valid_columns = %w(item_name item_price)
    valid_columns.each do |col|
      it "#{col} 不可為空" do
        @product.send("#{col}=", '')
        expect(@product).not_to be_valid
      end
    end
  end
end
