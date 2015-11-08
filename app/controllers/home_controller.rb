require 'crxmake'

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:get_files]
  skip_before_action :authenticate_user!, :only => [:get_files]

  def index
  end

  def download
    if current_user.chrome_app_session_id.blank?
      session_id = current_user.create_chrome_app_session_id
    end
      # copy template chrome app directory named session_id
      # add session id to SimpleEditor.js
      # create crx
      dir = File.dirname("#{Rails.root}/tmp/"+current_user.chrome_app_session_id)
      FileUtils.mkdir_p(dir+"/"+current_user.chrome_app_session_id)
      FileUtils.cp_r("#{Rails.root}/public/movie-architect/.",dir+"/"+current_user.chrome_app_session_id)
      newfile = File.open("#{Rails.root}/tmp/#{current_user.chrome_app_session_id}/test.js","w")
      newfile.puts "var session_id = \"" + current_user.chrome_app_session_id + "\";"
      oldfile = File.open("#{Rails.root}/tmp/#{current_user.chrome_app_session_id}/SimpleEditor.js", "r+")
      oldfile.each_line { |line| newfile.puts line}
      oldfile.close()
      newfile.close()
      File.delete("#{Rails.root}/tmp/#{current_user.chrome_app_session_id}/SimpleEditor.js")
      File.rename("#{Rails.root}/tmp/#{current_user.chrome_app_session_id}/test.js", "#{Rails.root}/tmp/#{current_user.chrome_app_session_id}/SimpleEditor.js")

      CrxMake.make(
        :ex_dir => "#{Rails.root}/tmp/#{current_user.chrome_app_session_id}",
        # :pkey   => "#{Rails.root}/tmp/#{current_user.chrome_app_session_id}.pem",
        :crx_output => "#{Rails.root}/vendor/MovieArchitect.crx"
      )
      FileUtils.rm_rf("#{Rails.root}/tmp/#{current_user.chrome_app_session_id}")
      File.delete("#{Rails.root}/#{current_user.chrome_app_session_id}.pem")

      send_file("#{Rails.root}/vendor/MovieArchitect.crx",
         :type => "application/x-chrome-extension")
  end

  # API to expose to Chrome App for retrieving the list of movie paths
  def get_files
    entries = params[:home][:_json]
    @chrome_user.user_latest_uploads.present? ? @chrome_user.user_latest_uploads.delete_all : ""
    entries.each do |entry|
      puts entry
      @chrome_user.user_latest_uploads.create!(file_name: entry)
    end 
    render json: {"success" => true}
  end
end
