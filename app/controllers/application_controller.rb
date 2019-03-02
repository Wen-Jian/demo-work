class ApplicationController < ActionController::Base
    
    include ConstantDefinition

    private
    def check_user_role
        redirect_to root_path if @user.nil? || (!@user.admin? && @user.role.user_role != USER_ROLE_AUTHORIZED_ADMIN)
    end

    def check_user_session
        redirect_to controller: :users, action: :login if session[:current_user_id].nil?
    end

    def get_current_user
        @user = User.find_by(id: session[:current_user_id])
    end
end
