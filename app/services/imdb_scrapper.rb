class ImdbScrapper

  require 'net/https'
  require 'capybara'
	require 'capybara/dsl'
	require 'capybara/poltergeist'
	include Capybara::DSL

  def initialize
		Capybara.current_driver = :poltergeist
		Capybara.register_driver :poltergeist do |app|
		  Capybara::Poltergeist::Driver.new(app, {
				js_errors: false#,
				#phantomjs_options: ['--ignore-ssl-errors=yes']
			})
		end
		Capybara.run_server = false
		@url = "http://www.imdb.com/"
    @exact_match_url = "http://www.imdb.com/find?s=tt&exact=true"
    @name_search_url = "http://www.imdb.com/find?s=tt"
    @title_url = "http://www.imdb.com/title/"
	rescue Capybara::Poltergeist::TimeoutError, NoMethodError
  end

  def name_search(name, exact_match=false)
    results = {}
    serach_url = exact_match ? @exact_match_url : @name_search_url
    visit(serach_url+"&q=#{name}")
    return nil if !page.has_css?('.findList')
    parsed_html = Nokogiri::HTML.parse(page.html)
    name_links = parsed_html.css('.findList a').map{|l| l.attribute('href')}.map(&:value)
    results[name] = []
    name_links.each do |title_url|
      title_id = title_url.split('/')[2]
      visit(@title_url+"#{title_id}")
      imdb_name = page.find('.header .itemprop').text
      category = Nokogiri::HTML.parse(page.html).css('.infobar .itemprop').map(&:text)
      rating = page.find('.star-box-giga-star').text if page.has_css?('.star-box-giga-star')
      results[name] << {imdb_name: imdb_name, rating: rating, category: category}
    end
    results
  end

  def scrape(names)
    results = []
    names.each do |name|
      names << name_search(name, true) || name_search(name, false) #|| clean name and search again
    end
    results
  end

end
