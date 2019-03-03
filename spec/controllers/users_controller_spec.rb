require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    
    before do 
        @role = Role.create!(
                user_role: 4,
                discount_flag: true
            )
        @user = User.create!(
            name: 'test_name',
            account: 'test_account',
            password: 'Password123',
            role_id: @role.id
        )
        @user_2 = User.create!(
            name: 'test_name_2',
            account: 'test_account_2',
            password: 'Password123',
            role_id: @role.id
        )
        @product = Product.create!(
            item_name: :test_item,
            item_price: 100,
            discount: 10
        )
    end

    describe 'Get index' do
        context 'without login' do
            it "redirect to login" do
                get :index
                expect(response).to redirect_to(login_user_url)
            end
        end
        context 'normal user login' do
            it "redirect to root" do
                get :index, params: {}, session: {current_user_id: @user.id}
                expect(response).to redirect_to(root_path)
            end
        end
        context 'prime user login' do
            before do 
                @role.update_attribute(:user_role, 3)
            end
            it "redirect to root" do
                get :index, params: {}, session: {current_user_id: @user.id}
                expect(response).to redirect_to(root_path)
            end
        end
        context 'authorized admin user login' do
            before do 
                @role.update_attribute(:user_role, 2)
            end
            it "redirect to root" do
                get :index, params: {}, session: {current_user_id: @user.id}
                expect(response).to redirect_to(root_path)
            end
        end
        context 'admin login' do
            before do 
                @role.update_attribute(:user_role, 1)
            end
            it "redirect to root" do
                get :index, params: {}, session: {current_user_id: @user.id}
                expect(response).to render_template(:index)
            end
        end
    end
    
    describe 'Get show' do
        context 'normal user login' do
            before do 
                @role.update_attribute(:user_role, 4)
            end
            it "access @user themself" do
                get :show, params: {id: @user.id}, session: {current_user_id: @user.id}
                expect(response).to render_template(:show)
            end
            it "access other @user" do
                get :show, params: {id: @user_2.id}, session: {current_user_id: @user.id}
                expect(response).to redirect_to(root_path)
            end
        end
        context 'prime user login' do
            before do 
                @role.update_attribute(:user_role, 3)
            end
            it "access @user themself" do
                get :show, params: {id: @user.id}, session: {current_user_id: @user.id}
                expect(response).to render_template(:show)
            end
            it "access other @user" do
                get :show, params: {id: @user_2.id}, session: {current_user_id: @user.id}
                expect(response).to redirect_to(root_path)
            end
        end
        context 'authorized admin user login' do
            before do 
                @role.update_attribute(:user_role, 2)
            end
            it "access @user themself" do
                get :show, params: {id: @user.id}, session: {current_user_id: @user.id}
                expect(response).to render_template(:show)
            end
            it "access other @user" do
                get :show, params: {id: @user_2.id}, session: {current_user_id: @user.id}
                expect(response).to redirect_to(root_path)
            end
        end
        context 'admin login' do
            before do 
                @role.update_attribute(:user_role, 1)
            end
            it "access @user themself" do
                get :show, params: {id: @user.id}, session: {current_user_id: @user.id}
                expect(response).to render_template(:show)
            end
            it "access other @user" do
                get :show, params: {id: @user_2.id}, session: {current_user_id: @user.id}
                expect(response).to render_template(:show)
            end
        end
    end
    describe 'Get new' do
        context 'without login' do
            before do 
                @role.update_attribute(:user_role, 4)
            end
            it "redirect to root_path" do
                get :new, params: {id: @user.id}
                expect(response).to render_template(:new)
            end
        end
        context 'user login' do
            before do 
                @role.update_attribute(:user_role, 4)
            end
            it "redirect to root_path" do
                get :new, params: {id: @user.id}, session: {current_user_id: @user.id}
                expect(response).to redirect_to(root_path)
            end
        end
    end

    describe 'Post create' do
        before do
            @params = {
                user: {
                    name: 'test_name_3',
                    account: 'test_account_3',
                    password: 'Password123'
                }
            }
        end
        context 'all informaions are given correcrly' do
            it "with selected product in session" do
                post :create, params: @params
                expect(response).to redirect_to(root_path)
            end
        end
        context 'with duplicate user account' do
            before do
                @params[:user][:account] = 'test_account'
            end
            it "render new" do
                post :create, params: @params
                expect(response).to render_template(:new)
            end
        end
        context 'with invalid password' do
            before do
                @params[:user][:password] = 'password123'
            end
            it "render new" do
                post :create, params: @params
                expect(response).to render_template(:new)
            end
        end
    end
    describe 'Get edit' do
        context 'user login' do
            it 'render edit' do
                get :edit, params: {id: @user.id}, session: {current_user_id: @user.id}
                expect(response).to render_template(:edit)
            end
        end
        context 'without login' do
            it 'render edit' do
                get :edit, params: {id: @user.id}
                expect(response).to redirect_to(login_user_path)
            end
        end
    end

    describe 'put update' do
        before do
            @params = {
                id: @user.id,
                edit_user: {
                    name: 'test_name_3',
                    account: 'test_account_3',
                    old_password: 'Password123',
                    new_password: 'Password1234'
                }
            }
        end
        context 'all informaions are given correcrly' do
            it "with selected product in session" do
                put :update, params: @params, session: {current_user_id: @user.id}
                expect(response).to redirect_to(user_path(@user.id))
            end
        end
        context 'with new_password, without old_password' do
            before do
                @params[:edit_user][:old_password] = ''
            end
            it "render new" do
                put :update, params: @params, session: {current_user_id: @user.id}
                expect(response).to render_template(:edit)
            end
        end
        context 'with incorrect new_password' do
            before do
                @params[:edit_user][:new_password] = 'password123'
            end
            it "render new" do
                put :update, params: @params, session: {current_user_id: @user.id}
                expect(response).to render_template(:edit)
            end
        end
        context 'new_password same as old password' do
            before do
                @params[:edit_user][:new_password] = 'Password123'
            end
            it "render new" do
                put :update, params: @params, session: {current_user_id: @user.id}
                expect(response).to render_template(:edit)
            end
        end
        context 'incorrect old_password' do
            before do
                @params[:edit_user][:old_password] = 'Password1234'
            end
            it "render new" do
                put :update, params: @params, session: {current_user_id: @user.id}
                expect(response).to render_template(:edit)
            end
        end
    end

    describe 'Get upgrate_user' do
        before do
            @role = Role.create!(
                user_role: 3,
                discount_flag: true
            )
            @params = {
                id: @user.id
            }
        end
        context 'upgrade user_role' do
            it "redirect to root" do
                get :upgrade, params: @params, session: {current_user_id: @user.id, selected_prod_id: @product.id}
                expect(response).to redirect_to(product_path(@product.id))
            end
        end
    end

    describe 'Get login' do
        it 'render login' do
            get :login
            expect(response).to render_template(:login)
        end
    end

    describe 'Post create_session' do
        before do
            @params = {
                user: {
                    name: 'test_name',
                    account: 'test_account',
                    password: 'Password123',
                }
            }
        end
        context 'all informaions are given correcrly' do
            it "with selected product in session" do
                post :create_session, params: @params, session: {selected_prod_id: @product.id}
                expect(response).to redirect_to(product_path(@product.id))
            end
        end
        context 'all informaions are given correcrly' do
            it "without selected product in session" do
                post :create_session, params: @params
                expect(response).to redirect_to(root_path)
            end
        end
    end
    describe 'Get logout' do
        before do
            @params = {
                id: @user.id
            }
        end
        context 'logout' do
            it "redirect to root" do
                get :logout, params: @params, session: {current_user_id: @user.id}
                expect(response).to redirect_to(root_path)
            end
        end
    end

    describe 'Patch user role' do
        before do
            @params = {
                id: @user,
                user_role: {
                    user_role: 2
                }
            }
        end
        context 'edit user role with admin' do
            before do
                @role_2 = Role.create!(
                    user_role: 1,
                    discount_flag: true
                )
                @role_3 = Role.create!(
                    user_role: 2,
                    discount_flag: true
                )
                @user_2.update_attribute(:role_id, @role_2.id)
            end
            it "redirect to root" do
                patch :edit_user_role, params: @params, session: {current_user_id: @user_2.id}
                expect(response).to render_template(:show)
                expect(@user.reload.role.id).to eq(@role_3.id)
            end
        end

        context 'edit user role with non-admin user' do
            before do
                @role_2 = Role.create!(
                    user_role: 3,
                    discount_flag: true
                )
                @role_3 = Role.create!(
                    user_role: 2,
                    discount_flag: true
                )
                @user_2.update_attribute(:role_id, @role_2.id)
            end
            it "redirect to root" do
                patch :edit_user_role, params: @params, session: {current_user_id: @user_2.id}
                expect(response).to redirect_to(root_path)
                expect(@user.reload.role.id).to eq(@role.id)
            end
        end
    end
end
