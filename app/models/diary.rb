class Diary < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :recorded_on, presence: true

  scope :default_order, -> { order(recorded_on: :desc, id: :desc) }
end
