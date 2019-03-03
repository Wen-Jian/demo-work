class UsersController < ApplicationController

    include ConstantDefinition

    before_action :check_user_session, except: [:login, :create_session, :logout, :new, :create]
    before_action :get_current_user
    before_action :check_user_role, only: [:index, :edit_user_role]

    def index
        redirect_to root_path unless @user.admin?
        @users = User.all
    end

    def show
        @selected_user = User.find_by(id: params[:id])
        redirect_to root_path if @user.id != @selected_user.id && !@user.admin?
    end

    def new
        redirect_to root_path and return if @user.present?
        @user = User.new()
    end

    def create
        redirect_to root_path and return if @user.present?
        @errors = []
        params = session_params
        @user = User.new(params)
        user_role = Role.find_by(user_role: USER_ROLE_NORMAL)
        @user.role_id = user_role.id
        render action: :new and return if user_duplicate?
        render action: :new and return if password_invalid?
        @user.save
        session[:current_user_id] = @user.id
        redirect_to root_path
    end

    def edit
        
    end

    def update
        params = edit_user_params
        @errors = []
        if params[:new_password].present?
            @errors << "若欲變更密碼，就密碼不可為空" if params[:old_password].blank?
            @errors << "密碼格式不正確" unless params[:new_password] =~ /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,30}\z/
            @errors << "新密碼與舊密碼不可為同一組密碼" if params[:new_password] == params[:old_password]
            @errors << "舊密碼輸入錯誤" unless @user.authenticate(params[:old_password])
        end
        render action: :edit and return if @errors.present?
        @user.update_attributes!(
            name: params[:name],
            account: params[:account],
            password: (params[:new_password].present? ? params[:new_password] : @user.password)
        )
        redirect_to action: :show
    end

    def upgrade
        @user.update_attributes!(role_id: Role.find_by!(user_role: USER_ROLE_PRIME).id)
        redirect_to product_path(session[:selected_prod_id])
    end

    def login
        @user = User.new()
    end

    def create_session
        @errors = []
        params = session_params
        @user = User.find_by(name: params[:name], account: params[:account])
        @errors << "帳號不存在" unless @user.present?
        @errors << "密碼有誤" unless @user&.authenticate(params[:password])
        render action: :login and return if @errors.present?
        session[:current_user_id] = @user.id 
        redirect_to session[:selected_prod_id].present? ? product_path(session[:selected_prod_id]) : root_path
    end

    def logout
        session[:current_user_id] = nil
        redirect_to root_path
    end

    def edit_user_role
        @errors = []
        user_role = Role.find_by(user_role: params[:user_role][:user_role])
        @errors << "請指定使用者權限" if params[:user_role][:user_role].blank? || user_role.nil?
        @selected_user = User.find_by(id: params[:id])
        render action: :show and return if @errors.present?
        @selected_user.update_attributes!(role_id: user_role.id)
        render action: :show
    end

    private

    def session_params
        params.require(:user).permit(:name, :account, :password)
    end

    def password_invalid?
        @errors << "密碼格式不符合" and return true if (@user.password !~ /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,30}\z/)
    end

    def user_duplicate?
        duplicate_user = User.find_by(account: @user.account)
        @errors << "帳號已存在" and return true if duplicate_user.present?
    end

    def edit_user_params
        params.require(:edit_user).permit(:name, :account, :old_password, :new_password)
    end
end
