class Work < ApplicationRecord
  has_one_attached :thumbnail

  validates :title, presence: true
end
