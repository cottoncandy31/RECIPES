class Tag < ApplicationRecord
  belongs_to :recipe, optional: true
  belongs_to :step, optional: true
end
