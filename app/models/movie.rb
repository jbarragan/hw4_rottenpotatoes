class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def find_movies_by_director
    if self.director != nil && self.director != ""
      Movie.where("director = ?", self.director)
    else
      movies = nil
    end
  end
end
