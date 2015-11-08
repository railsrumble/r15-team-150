class ImdbMovie

  def initialize
    @tmdb_api = 'a6b991e775684f55f3bdb5ae626771f1'
    Tmdb::Api.key(@tmdb_api)
    Tmdb::Api.language("de")
  end

  def movie_info(names)
    results = {}
    names.each do |name|
      movies_list = Tmdb::Movie.find(name)
      results[name] = []
      movies_list.each do |movie|
        movie_details = Tmdb::Movie.detail(movie.id)
        genres = movie_details['genres'].map{|m| m['name']}
        results[name] << {genres: genres, rating: movie.vote_average, original_name: movie.original_title}
      end
    end
    results
  end

end
