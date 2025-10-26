require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:user) { User.create(name: 'Director', email: 'director@example.com', password: 'password') }

  describe 'validations' do
    it 'is valid with all required attributes' do
      movie = Movie.new(
        title: 'Inception',
        synopsis: 'A mind-bending thriller',
        release_year: 2010,
        duration: 148,
        director: 'Christopher Nolan',
        user: user
      )
      expect(movie).to be_valid
    end

    it 'is invalid without title' do
      movie = Movie.new(title: nil, synopsis: 'Test', release_year: 2020, duration: 120, director: 'Director', user: user)
      expect(movie).to be_invalid
    end

    it 'is invalid without synopsis' do
      movie = Movie.new(title: 'Test', synopsis: nil, release_year: 2020, duration: 120, director: 'Director', user: user)
      expect(movie).to be_invalid
    end

    it 'is invalid with release_year before 1888' do
      movie = Movie.new(title: 'Test', synopsis: 'Test', release_year: 1887, duration: 120, director: 'Director', user: user)
      expect(movie).to be_invalid
    end

    it 'is invalid with release_year in the future' do
      movie = Movie.new(title: 'Test', synopsis: 'Test', release_year: Date.current.year + 1, duration: 120, director: 'Director', user: user)
      expect(movie).to be_invalid
    end

    it 'is invalid with non-positive duration' do
      movie = Movie.new(title: 'Test', synopsis: 'Test', release_year: 2020, duration: 0, director: 'Director', user: user)
      expect(movie).to be_invalid
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      association = Movie.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has and belongs to many categories' do
      association = Movie.reflect_on_association(:categories)
      expect(association.macro).to eq(:has_and_belongs_to_many)
    end

    it 'has and belongs to many tags' do
      association = Movie.reflect_on_association(:tags)
      expect(association.macro).to eq(:has_and_belongs_to_many)
    end

    it 'has many comments' do
      association = Movie.reflect_on_association(:comments)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has one attached image' do
      expect(Movie.new).to respond_to(:image)
    end
  end

  describe 'scopes' do
    before do
      @movie1 = Movie.create(title: 'Movie 1', synopsis: 'Test', release_year: 2020, duration: 120, director: 'Director A', user: user, created_at: 1.day.ago)
      @movie2 = Movie.create(title: 'Movie 2', synopsis: 'Test', release_year: 2021, duration: 130, director: 'Director B', user: user, created_at: Time.current)
    end

    it 'searches by title' do
      expect(Movie.search('Movie 1')).to include(@movie1)
    end

    it 'searches by director' do
      expect(Movie.search('Director A')).to include(@movie1)
    end

    it 'searches by release_year' do
      expect(Movie.search('2021')).to include(@movie2)
    end
  end
end