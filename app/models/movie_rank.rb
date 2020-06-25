class MovieRank < ApplicationRecord
  belongs_to :user
  belongs_to :review
  enum rank_status: { "Myランキングに登録する。": "0", "1位": 1, "2位": 2, "3位": 3 }

end
