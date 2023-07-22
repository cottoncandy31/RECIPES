class Ingredient < ApplicationRecord
  belongs_to :recipe
  validates :name, presence: true, length: { maximum: 20 }
  validates :quantity, presence: true, length: { maximum: 20 }
end
