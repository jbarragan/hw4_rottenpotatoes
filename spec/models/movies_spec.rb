require 'spec_helper'

describe Movie do
  describe 'find similar movies' do
    it 'should return no movies if director is nil' do
      fake_movie = Movie.new(:director => nil)
      #Movie.stub(:find).and_return(fake_movie)
      fake_movie.find_movies_by_director.should == nil
    end
    
  end
end