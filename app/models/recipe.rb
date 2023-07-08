class Recipe < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user
  has_many :comments, dependent: :destroy
 # belongs_to :genre
end
