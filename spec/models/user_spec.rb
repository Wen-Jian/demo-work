require 'rails_helper'

RSpec.describe User, type: :model do
  
  before do
    @role = Role.create!(user_role: 4, discount_flag: false)
    @user = User.new(
      name: 'test_name',
      account: 'test_account',
      password: 'Password123',
      role_id: @role.id
    )
  end
  
  describe '正常情況' do
    describe '正確建立資料' do
      it 'save' do
        expect(@user).to be_valid
      end
    end
  end

  describe '必要項目' do 
    valid_columns = %w(name account password role_id)
    valid_columns.each do |col|
      it "#{col} 不可為空" do
        @user.send("#{col}=", '')
        expect(@user).not_to be_valid
      end
    end
  end

  describe '唯一性' do
    before do 
      @user.save
      @user_2 = User.new(
      name: 'test_name',
      account: 'test_account',
      password: 'Password123',
      role_id: @role.id
    )
    end
    valid_columns = %w( account )
    valid_columns.each do |col|
      it "#{col} 不可重複" do
        expect(@user_2).not_to be_valid
      end
    end
  end

  describe '格式' do
    valid_columns = %w( password )
    valid_columns.each do |col|
      it "#{col} 必須含有至少一個大寫字母" do
        @user.send("#{col}=", 'password123')
        expect(@user).not_to be_valid
      end
      it "#{col} 必須含有至少一個小寫字母" do
        @user.send("#{col}=", 'PASSWORD123')
        expect(@user).not_to be_valid
      end
      it "#{col} 必須含有至少一個數字" do
        @user.send("#{col}=", 'PASSWORDaaa')
        expect(@user).not_to be_valid
      end
      it "#{col} 長度介於6~30" do
        @user.send("#{col}=", 'Pa1')
        expect(@user).not_to be_valid
        @user.send("#{col}=", 'Pa1'* 2)
        expect(@user).to be_valid
        @user.send("#{col}=", 'Pa1'* 11)
        expect(@user).not_to be_valid
      end
    end
  end

  describe "關聯" do
    it "belongs to role" do
      assc = User.reflect_on_association(:role)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe "事件處理" do
    before do
      @user.save
    end
    it "密碼認證" do
      expect(@user.authenticate('Password123')).to eq true
      expect(@user.authenticate('Password1234')).to eq false
    end
    it "權限判斷" do
      expect(@user.admin?).to eq false
    end
  end
end
