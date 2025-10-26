require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'associations' do
    it 'has and belongs to many movies' do
      association = Tag.reflect_on_association(:movies)
      expect(association.macro).to eq(:has_and_belongs_to_many)
    end
  end
end