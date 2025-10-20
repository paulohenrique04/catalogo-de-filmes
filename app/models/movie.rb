class Movie < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, :synopsis, :release_year, :duration, :director, presence: true
  validates :release_year, numericality: { only_integer: true, greater_than: 1888, less_than_or_equal_to: Date.current.year }
  validates :duration, numericality: { only_integer: true, greater_than: 0 }

  scope :newest_first, -> { order(created_at: :desc) }
end
