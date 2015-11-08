class CreateMoviesTable < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.integer :user_id
      t.string :name
      t.string :imdb_movie_id
      t.string :imdb_name
      t.string :categories
      t.string :languages
      t.text :tagline
      t.string :runtime
      t.string :rating
    end
  end
end
