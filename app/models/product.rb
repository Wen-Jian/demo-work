class Product < ApplicationRecord

    mount_uploader :image, ImageUploader

    validates_presence_of :item_name, :item_price

    validates_length_of :item_name, maximum: 100
    validates_length_of :item_price, maximum: 6, only_integer: true
    validates_length_of :description, maximum: 255, allow_nil: true, allow_blank: true

end
