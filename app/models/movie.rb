class Movie < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :title, :synopsis, :release_year, :duration, :director, presence: true
  validates :release_year, numericality: { only_integer: true, greater_than: 1888, less_than_or_equal_to: Date.current.year }
  validates :duration, numericality: { only_integer: true, greater_than: 0 }

  scope :newest_first, -> { order(created_at: :desc) }
end
