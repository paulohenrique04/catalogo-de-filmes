class CreateCategoriesMoviesJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :movies, :categories do |t|
      t.index [:movie_id, :category_id], unique: true
      t.index [:category_id, :movie_id]
    end
  end
end
