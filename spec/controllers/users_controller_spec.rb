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
    end
    
end
