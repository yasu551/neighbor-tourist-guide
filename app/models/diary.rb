class Diary < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :recorded_on, presence: true
end
