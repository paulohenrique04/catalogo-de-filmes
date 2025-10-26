require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with name and email' do
      user = User.new(name: 'John Doe', email: 'john@example.com', password: 'password')
      expect(user).to be_valid
    end

    it 'is invalid without name' do
      user = User.new(name: nil, email: 'john@example.com', password: 'password')
      expect(user).to be_invalid
    end

    it 'is invalid without email' do
      user = User.new(name: 'John Doe', email: nil, password: 'password')
      expect(user).to be_invalid
    end

    it 'is invalid with duplicate email' do
      User.create(name: 'John', email: 'test@example.com', password: 'password')
      user = User.new(name: 'Jane', email: 'test@example.com', password: 'password')
      expect(user).to be_invalid
    end
  end

  describe 'associations' do
    it 'has many comments' do
      association = User.reflect_on_association(:comments)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:nullify)
    end

    it 'has many movies' do
      association = User.reflect_on_association(:movies)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'Devise modules' do
    it 'includes database_authenticatable module' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable module' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable module' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable module' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable module' do
      expect(User.devise_modules).to include(:validatable)
    end
  end
end