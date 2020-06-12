class CreateMovieGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_genres do |t|
      t.integer :movie_id, foreign_key: true
      t.integer :genre_id, foreign_key: true

      t.timestamps
    end
  end
end
