require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }
  let(:movie) { Movie.create(title: 'Test Movie', synopsis: 'Test', release_year: 2020, duration: 120, director: 'Director', user: user) }

  describe 'validations' do
    it 'is valid with content' do
      comment = Comment.new(content: 'Great movie!', movie: movie)
      expect(comment).to be_valid
    end

    it 'is invalid without content' do
      comment = Comment.new(content: nil, movie: movie)
      expect(comment).to be_invalid
      expect(comment.errors[:content]).to include("não pode ficar em branco")
    end
  end

  describe 'associations' do
    it 'belongs to user (optional)' do
      association = Comment.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be true
    end

    it 'belongs to movie' do
      association = Comment.reflect_on_association(:movie)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe '#handle_author_name' do
    it 'returns user name when user exists' do
      comment = Comment.new(content: 'Test', movie: movie, user: user)
      expect(comment.handle_author_name).to eq('John')
    end

    it 'returns author_name when user is nil' do
      comment = Comment.new(content: 'Test', movie: movie, author_name: 'Guest')
      expect(comment.handle_author_name).to eq('Guest')
    end
  end
end