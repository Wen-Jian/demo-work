class ProductsController < ApplicationController
    before_action :get_current_user
    before_action :check_user_role, only: [:new, :create, :edit, :update]
    def index
        @products = Product.all
    end

    def show
        @product = Product.find(params[:id])
        session[:selected_prod_id] = params[:id]
    end

    def new
        @product = Product.new()
    end

    def create
        params = product_params
        @product = Product.new(product_params)
        render action: :new and return unless params_valid?(params)
        @product.save
        redirect_to root_path
    end

    def edit
        @product = Product.find(params[:id])
    end

    def update
        params = product_params
        @product = Product.find(params[:id])
        render action: :new and return unless params_valid?(params)
        params.delete(:id)
        @product.update!(params)
        redirect_to root_path
    end

    private

    def product_params
        params.require(:product).permit(:item_name, :item_price, :discount, :image, :description, :id)
    end

    def params_valid?(params)
        @errors = []
        @errors << "商品名稱不可為空值" if params[:item_name].blank?
        @errors << "商品價格不可為空值" if params[:item_price].blank?
        return @errors.blank?
    end

end
