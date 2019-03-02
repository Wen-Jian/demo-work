class User < ApplicationRecord

    include ConstantDefinition

    belongs_to :role

    validates_presence_of :name, :account, :password, :role_id

    validates_uniqueness_of :account

    validates_format_of :password, with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,30}\z/

    def authenticate(password)
        self.password == password
    end

    def admin?
        self.role.user_role == USER_ROLE_ADMIN
    end
end
