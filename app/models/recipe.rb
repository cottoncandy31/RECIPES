class Recipe < ApplicationRecord
  has_one_attached :post_image  
  belongs_to :user
 # belongs_to :genre
end
