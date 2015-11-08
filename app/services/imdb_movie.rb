class ImdbMovie

  def initialize
    @tmdb_api = 'a6b991e775684f55f3bdb5ae626771f1'
    Tmdb::Api.key(@tmdb_api)
    Tmdb::Api.language("de")
    @user = current_user
  end

  def movie_info(names)
    names.each do |name|
      movies_list = Tmdb::Movie.find(name)
      movies_list.each do |movie|
        if !@user.has_this_movie?
          movie_details = Tmdb::Movie.detail(movie.id)
          genres = movie_details['genres'].map{|m| m['name']}.join(',') if movie_details['genres'].present?
          languages = movie_details['spoken_languages'].map{|m| m['name']}.join(',') if movie_details['spoken_languages'].present?
          params = {categories: genres, rating: movie.vote_average, imdb_name: movie.original_title, tagline: movie_details['tagline'], runtime: movie_details['runtime'], languages: languages, name: name, imdb_movie_id: movie.id}
          save_movie(params)
        end
      end
    end
  end

  def save_movie(params)
    movie_obj = @user.movies.where(imdb_name: params[:imdb_name]).find_or_create_by(imdb_movie_id: params[:imdb_movie_id])
    movie_obj.update_attributes!(params)
  end

end
