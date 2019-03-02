class Role < ApplicationRecord
    has_many :users
    validates_presence_of :user_role
    validates_inclusion_of :discount_flag, :in => [true, false]
    validates_length_of :user_role, maximum: 1
    validates_uniqueness_of :user_role
    validates_format_of :user_role, with: /\A[1-4]\z/
end
