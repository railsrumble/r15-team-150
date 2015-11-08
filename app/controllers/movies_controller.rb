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

  def scrape
    begin
      ImdbMovie.new(current_user).movie_info(current_user.user_latest_uploads.map(&:file_name))
      redirect_to movies_index_path
    rescue Exception => e
      logger.info "Error: #{e.message}"
      redirect_to root_path, alert: "Something went wrong. Try again later."
    end
  end

end
