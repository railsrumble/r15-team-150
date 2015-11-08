class MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:delete]
  def index
    @movies = current_user.movies.group_by(&:name)
  end

  def show
    @movie = current_user.movies.find(params[:id])
  end

  def delete
    movie = current_user.movies.find(params[:id])
    movie.destroy!
    render json: {code: 200}
  end

end
