require 'rails_helper'

RSpec.describe Role, type: :model do
  before do 
    @role = Role.new(
      user_role: 1,
      discount_flag: true
    )
  end

  describe '正常情況' do
    describe '正確建立資料' do
      it 'save' do
        expect(@role).to be_valid
      end
    end
  end

  describe '必要項目' do 
    valid_columns = %w(user_role)
    valid_columns.each do |col|
      it "#{col} 不可為空" do
        @role.send("#{col}=", '')
        expect(@role).not_to be_valid
      end
    end
  end

  describe '內容長度檢測' do
    valid_columns = {
      user_role: 1
    }
    valid_columns.each do |key, val|
      it "#{key} 長度不可超過#{val}" do
        if key == :item_price
          @role.send("#{key}=", '1' * (val + 1))
        else
          @role.send("#{key}=", 'a' * (val + 1))
        end
        expect(@role).not_to be_valid
      end
    end
  end

  describe '唯一性' do
    before do 
      @role.save
      @role_2 = Role.new(
        user_role: 1,
        discount_flag: true
      )
    end
    valid_columns = %w( user_role )
    valid_columns.each do |col|
      it "#{col} 不可重複" do
        expect(@role_2).not_to be_valid
      end
    end
  end

  describe '格式' do
    valid_columns = %w( user_role )
    valid_columns.each do |col|
      it "#{col} 接受1~4" do
        @role.send("#{col}=", '1')
        expect(@role).to be_valid
        @role.send("#{col}=", '2')
        expect(@role).to be_valid
        @role.send("#{col}=", '3')
        expect(@role).to be_valid
        @role.send("#{col}=", '4')
        expect(@role).to be_valid
      end
      it "#{col} 不接受1~4以外的值" do
        @role.send("#{col}=", 'a')
        expect(@role).not_to be_valid
        @role.send("#{col}=", '5')
        expect(@role).not_to be_valid
        @role.send("#{col}=", '測')
        expect(@role).not_to be_valid
      end
    end
  end

  describe "關聯" do
    it "has_many users" do
      assc = Role.reflect_on_association(:users)
      expect(assc.macro).to eq :has_many
    end
  end
end
