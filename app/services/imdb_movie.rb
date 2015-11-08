class ImdbMovie

  def initialize
    @tmdb_api = 'a6b991e775684f55f3bdb5ae626771f1'
    Tmdb::Api.key(@tmdb_api)
    Tmdb::Api.language("de")
    @user = current_user
  end

  def movie_info(names)
    names.each do |name|
      movies_list = search_by_name(name)
      if !movies_list.present?
        save_empty_result(name)
        break
      end
      movies_list[0..4].each do |movie|
        if !@user.has_this_movie_name?(name, movie.original_title)
          movie_details = Tmdb::Movie.detail(movie.id)
          genres = movie_details['genres'].map{|m| m['name']}.join(',') if movie_details['genres'].present?
          languages = movie_details['spoken_languages'].map{|m| m['name']}.join(',') if movie_details['spoken_languages'].present?
          params = {categories: genres, rating: movie.vote_average, imdb_name: movie.original_title, tagline: movie_details['tagline'], runtime: movie_details['runtime'], languages: languages, name: name, imdb_movie_id: movie.id}
          save_movie(params)
        end
      end
    end
  end

  # TODO Refactor code
  def search_by_name(name)
    results = nil
    i=1
    until (i>3 or results.present?) do
      if i==1
        results = Tmdb::Movie.find(name)
      elsif i==2
        c_name = (name.split( ) - ['[',']','/','-']).delete_if{|m| m.include?('.com')}[0..2].join(' ')
        results = Tmdb::Movie.find(c_name) if c_name
      elsif i==3
        c_name = (name.split( ) - ['[',']','/','-']).delete_if{|m| m.include?('.com')}[0]
        results = Tmdb::Movie.find(c_name) if c_name
      end
      i=i+1
    end
    results
  end

  def save_movie(params)
    movie_obj = @user.movies.where(imdb_name: params[:imdb_name]).find_or_create_by(imdb_movie_id: params[:imdb_movie_id])
    movie_obj.update_attributes!(params)
  end

  def save_empty_result(name)
    @user.movies.find_or_create_by(name: name)
  end

  # TODO Refactor (Use name clean logic in one place)
  def cleanname1(name)
    name.split( )[0]
  end

end
