class Step < ApplicationRecord
  belongs_to :recipe
  has_one_attached :step_image
  validates :description, presence: true, length: { maximum: 200 }
end
