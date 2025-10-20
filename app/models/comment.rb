class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :movie

  validates :content, presence: true

  scope :newest_first, -> { order(created_at: :desc) }

  def handle_author_name
    user&.name || author_name
  end
end
