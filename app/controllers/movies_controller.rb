class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     if params[:sort] == "title"
 	    @title_class = "hilite"
 	    @movies = Movie.order("title")
     elsif params[:sort] == "release"
 	    @release_class = "hilite"
 	    @movies = Movie.order("release_date")
     else
 	    @movies = Movie.all
    end
    
    @all_ratings = Movie.distinct.pluck(:rating)
    
    if params[:ratings] == nil
       @clicked_box = Hash.new()
       @all_ratings.each do |rating|
        @clicked_box[rating]=1
       end
      else
       @clicked_box=params[:ratings]
    end
     
     @movies = @movies.where({rating: @clicked_box.keys})
     
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
