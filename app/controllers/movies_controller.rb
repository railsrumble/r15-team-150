class MoviesController < ApplicationController

  def index
    @movies = current_user.movies
  end

  def show
    @movie = current_user.movies.find(params[:id])
  end

  def delete
    movie = current_user.movies.find(params[:id])
    movie.destroy!
    redirect_to movies_index_path, notice: "Removed Movie Successfully"
  end

end
