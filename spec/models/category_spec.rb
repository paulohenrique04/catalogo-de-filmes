require 'rails_helper'

RSpec.describe Category, type: :model do
    describe 'validations' do
        it 'is valid with a name' do
            category = Category.new(name: 'Electronics')
            expect(category).to be_valid
        end
    
        it 'is invalid without a name' do
            category = Category.new(name: nil)
            expect(category).to be_invalid
            expect(category.errors[:name]).to include("não pode ficar em branco")
        end

        it 'is invalid with a duplicate name' do
            Category.create!(name: 'Books')
            category = Category.new(name: 'Books')
            expect(category).to be_invalid
            expect(category.errors[:name]).to include('já está em uso')
        end
    end
end