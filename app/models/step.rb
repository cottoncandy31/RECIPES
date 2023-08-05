class Step < ApplicationRecord
  belongs_to :recipe
  has_one_attached :step_image
  has_many :tags, dependent: :destroy
  validates :description, presence: true, length: { maximum: 200 }
end
