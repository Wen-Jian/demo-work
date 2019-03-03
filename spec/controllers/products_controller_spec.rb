require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
    
    before do 
        @product = Product.create!(
            item_name: :test_item,
            item_price: 100,
            discount: 10
        )
        @role = Role.create!(
                user_role: 1,
                discount_flag: true
            )
        @user = User.create!(
            name: 'test_name',
            account: 'test_account',
            password: 'Password123',
            role_id: @role.id
        )
    end
    describe 'Get index' do
        it "renders the index template" do
            get :index
            expect(response).to render_template("index")
        end
    end

    describe 'Get show' do
        it "renders the show template" do
            get :show, params: {id: @product.id}, session: {test: '123'}
            expect(response).to render_template("show")
        end
        it "not existed id => redirect to index" do
            get :show, params: {id: Product.last.id + 1}
            expect(response).to redirect_to(root_path)
        end
    end

    describe 'Get new' do
        context "not lgin" do
            it 'redirect to root' do
                get :new
                expect(response).to redirect_to(root_path)
            end
        end
        context "normal_user login" do
            before do 
                @role.update_attribute(:user_role, 4)
            end
            it 'redirect to index' do
                get :new
                expect(response).to redirect_to(root_path)
            end
        end
        context "prime user login" do
            before do 
                @role.update_attribute(:user_role, 3)
            end
            it 'redirect to root' do
                get(:new, params: {}, session: { current_user_id: @user.id})
                expect(response).to redirect_to(root_path)
            end
        end
        context "authorized admin user login" do
            before do 
                @role.update_attribute(:user_role, 2)
            end
            it 'render new template' do
                get :new, params: {}, session: {current_user_id: @user.id}
                expect(response).to render_template(:new)
            end
        end
        context "admin login" do
            before do 
                @role.update_attribute(:user_role, 1)
            end
            it 'render new template' do
                get :new, params: {}, session: {current_user_id: @user.id}
                expect(response).to render_template(:new)
            end
        end
    end
    describe 'Post create' do
        before do
            @params = {
                product: {
                    item_name: 'test_item', 
                    item_price: 100, 
                    discount: 10, 
                    description: nil, 
                    id: nil
                }
            }
            @session = {current_user_id: @user.id}
        end
        context "not lgin" do
            it 'redirect to root' do
                expect{ post :create, params: @params }.to change{Product.count}.by(0)
                expect(response).to redirect_to(root_path)
            end
        end
        context "normal_user login" do
            before do 
                @role.update_attribute(:user_role, 4)
            end
            it 'redirect to index' do
                expect{ post :create, params: @params, session: @session }.to change{Product.count}.by(0)
                expect(response).to redirect_to(root_path)
            end
        end
        context "prime user login" do
            before do 
                @role.update_attribute(:user_role, 3)
            end
            it 'redirect to root' do
                expect{ post :create, params: @params, session: @session }.to change{Product.count}.by(0)
                expect(response).to redirect_to(root_path)
            end
        end
        context "authorized admin user login" do
            before do 
                @role.update_attribute(:user_role, 2)
            end
            it 'redirect to root' do
                expect{ post :create, params: @params, session: @session }.to change{Product.count}.by(1)
                expect(response).to redirect_to(root_path)
            end
        end
        context "admin login" do
            before do 
                @role.update_attribute(:user_role, 1)
            end
            it 'redirect to root' do
                expect{ post :create, params: @params, session: @session }.to change{Product.count}.by(1)
                expect(response).to redirect_to(root_path)
            end
        end
        context "authorized admin user login without item_name" do
            before do 
                @role.update_attribute(:user_role, 2)
                @params[:product][:item_name] = ''
            end
            it 'render new template' do
                expect{ post :create, params: @params, session: @session }.to change{Product.count}.by(0)
                expect(response).to render_template(:new)
            end
        end
        context "authorized admin user login without item_price" do
            before do 
                @role.update_attribute(:user_role, 2)
                @params[:product][:item_price] = ''
            end
            it 'render new template' do
                expect{ post :create, params: @params, session: @session }.to change{Product.count}.by(0)
                expect(response).to render_template(:new)
            end
        end
    end
    describe 'Get edit' do
        before do
            @params = {
                id: @product.id
            }
            @session = {current_user_id: @user.id}
        end
        context "not lgin" do
            it 'redirect to root' do
                get :edit, params: @params
                expect(response).to redirect_to(root_path)
            end
        end
        context "normal_user login" do
            before do 
                @role.update_attribute(:user_role, 4)
            end
            it 'redirect to root' do
                get :edit, params: @params, session: @session
                expect(response).to redirect_to(root_path)
            end
        end
        context "prime user login" do
            before do 
                @role.update_attribute(:user_role, 3)
            end
            it 'redirect to root' do
                get :edit, params: @params, session: @session
                expect(response).to redirect_to(root_path)
            end
        end
        context "authorized admin user login" do
            before do 
                @role.update_attribute(:user_role, 2)
            end
            it 'render new template' do
                get :edit, params: @params, session: @session 
                expect(response).to render_template(:edit)
            end
        end
        context "admin login" do
            before do 
                @role.update_attribute(:user_role, 1)
            end
            it 'render new template' do
                get :edit, params: @params, session: @session
                expect(response).to render_template(:edit)
            end
        end
    end
    describe 'Put update' do
        before do
            @params = {
                id: @product.id,
                product: {
                    item_name: 'updated_item', 
                    item_price: 100, 
                    discount: 10, 
                    description: nil, 
                    id: @product.id
                }
            }
            @session = {current_user_id: @user.id}
        end
        context "not lgin" do
            it 'redirect to root' do
                put :update, params: @params
                expect(response).to redirect_to(root_path)
                expect(@product.reload.item_name).to eq('test_item')
            end
        end
        context "normal_user login" do
            before do 
                @role.update_attribute(:user_role, 4)
            end
            it 'redirect to index' do
                put :update, params: @params, session: @session
                expect(response).to redirect_to(root_path)
                expect(@product.reload.item_name).to eq('test_item')
            end
        end
        context "prime user login" do
            before do 
                @role.update_attribute(:user_role, 3)
            end
            it 'redirect to root' do
                put :update, params: @params, session: @session
                expect(response).to redirect_to(root_path)
                expect(@product.reload.item_name).to eq('test_item')
            end
        end
        context "authorized admin user login" do
            before do 
                @role.update_attribute(:user_role, 2)
            end
            it 'redirect to root' do
                put :update, params: @params, session: @session
                expect(response).to redirect_to(root_path)
                expect(@product.reload.item_name).to eq('updated_item')
            end
        end
        context "admin login" do
            before do 
                @role.update_attribute(:user_role, 1)
            end
            it 'redirect to root' do
                put :update, params: @params, session: @session
                expect(response).to redirect_to(root_path)
                expect(@product.reload.item_name).to eq('updated_item')
            end
        end
        context "authorized admin user login without item_name" do
            before do 
                @role.update_attribute(:user_role, 2)
                @params[:product][:item_name] = ''
            end
            it 'render edit template' do
                put :update, params: @params, session: @session
                expect(response).to render_template(:edit)
                expect(@product.reload.item_name).to eq('test_item')
            end
        end
        context "authorized admin user login without item_price" do
            before do 
                @role.update_attribute(:user_role, 2)
                @params[:product][:item_price] = ''
            end
            it 'render edit template' do
                put :update, params: @params, session: @session
                expect(response).to render_template(:edit)
                expect(@product.reload.item_name).to eq('test_item')
            end
        end
    end
end
