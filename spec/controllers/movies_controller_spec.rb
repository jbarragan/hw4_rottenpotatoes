require 'spec_helper'

describe MoviesController do
  describe 'find similar movies' do
    it 'should call the model method that performs find similar movies' do
      fake_movie = Movie.new(:title => "Mock")
      Movie.stub(:find).and_return(fake_movie)
      fake_movie.should_receive(:find_movies_by_director)
      post :Similar_Movies, {:id => '2'}
    end
    it 'should select the Similar Movies template for rendering' do
      fake_movie = Movie.new(:title => "Mock")
      fake_movies = [fake_movie, mock('Movie'), mock('Movie')]
      Movie.stub(:find).and_return(fake_movie)
      fake_movie.stub(:find_movies_by_director).and_return(fake_movies)
      post :Similar_Movies, {:id => '2'}
      response.should render_template('Similar_Movies')
    end
    it 'should execute find movies by director' do
      fake_movie = Movie.new(:title => "Mock", :director => "Jaime")
      fake_movies = [fake_movie, mock('Movie'), mock('Movie')]
      Movie.stub(:find).and_return(fake_movie)
      Movie.stub(:where).and_return(fake_movies)
      post :Similar_Movies, {:id => '2'}
      response.should render_template('Similar_Movies')
    end

    it 'should display alert if no movies found' do
      fake_movie = Movie.new(:title => "Mock")
      fake_movies = nil
      Movie.stub(:find).and_return(fake_movie)
      fake_movie.stub(:find_movies_by_director).and_return(fake_movies)
      post :Similar_Movies, {:id => '2'}      
      response.should redirect_to(movies_path)
    end
    
  end
  describe 'Hilite ordering column' do
    it 'should hilite title column when sort by title' do 
      session.stub(:[]).with("flash").and_return(double(:sweep => true, :update => true, :[]= => []))
      session.stub(:[]).with(:ratings).and_return({})      
      session.stub(:[]).with(:sort).and_return('title')
      Movie.should_receive(:find_all_by_rating)
      post :index, {:sort => 'title', :ratings => {}}
    end
    it 'should hilite release_date column when sort by release_date' do 
      session.stub(:[]).with("flash").and_return(double(:sweep => true, :update => true, :[]= => []))
      session.stub(:[]).with(:ratings).and_return({})      
      session.stub(:[]).with(:sort).and_return('release_date')
      Movie.should_receive(:find_all_by_rating)
      post :index, {:sort => 'release_date', :ratings => {}}
    end
    it 'Test 01' do 
      session.stub(:[]).with("flash").and_return(double(:sweep => true, :update => true, :[]= => []))
      session.stub(:[]).with(:ratings).and_return({})      
      session.stub(:[]).with(:sort).and_return('title')
      flash.stub(:keep)
      selected_ratings = Hash[Movie.all_ratings.map {|rating| [rating, rating]}]
      post :index, {:sort => 'release_date', :ratings => {}}
      response.should redirect_to({:sort => 'release_date', :ratings => selected_ratings})
    end
    it 'Test 02' do 
      session.stub(:[]).with("flash").and_return(double(:sweep => true, :update => true, :[]= => []))
      session.stub(:[]).with(:ratings).and_return({})      
      session.stub(:[]).with(:sort).and_return('title')
      flash.stub(:keep)
      selected_ratings = Hash[Movie.all_ratings.map {|rating| [rating, rating]}]
      post :index, {:sort => 'title', :ratings => selected_ratings }
      response.should redirect_to({:sort => 'title', :ratings => selected_ratings})
    end
  end

  describe 'Test Create' do
    it 'Test 03' do 
      fake_movie = Movie.new(:title => "Mock")
      Movie.stub(:create!).and_return(fake_movie)
      post :create
      response.should redirect_to(movies_path)
    end
  end

  describe 'Test Destroy' do
    it 'Test 04' do 
      fake_movie = Movie.new(:title => "Mock")
      Movie.stub(:find).and_return(fake_movie)
      Movie.stub(:destroy)
      post :destroy, {:id => '2'}    
      response.should redirect_to(movies_path)
    end
  end

  describe 'Test Update' do
    it 'Test 04' do 
      fake_movie = Movie.new(:id => 2, :title => "Mock")
      Movie.stub(:find).and_return(fake_movie)
      Movie.stub(:update_attributes!)
      post :update, {:id => '2'}    
      response.should redirect_to(movie_path(fake_movie))
    end
  end

end