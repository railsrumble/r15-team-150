require 'crxmake'

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:get_files]

  def index
    if current_user.chrome_app_session_id.blank? 
    
    end
  end

  def get_files
    if current_user.chrome_app_session_id.blank?
      session_id = current_user.create_chrome_app_session_id
      # copy template chrome app directory named session_id
      # add session id to SimpleEditor.js
      # create crx
      dir = File.dirname("#{Rails.root}/tmp/"+current_user.chrome_app_session_id)
      FileUtils.mkdir_p(dir+"/"+current_user.chrome_app_session_id)
      FileUtils.cp_r("#{Rails.root}/public/movie-architect/.",dir+"/"+current_user.chrome_app_session_id)
      newfile = File.open("#{Rails.root}/tmp/#{current_user.chrome_app_session_id}/test.js","w")
      newfile.puts "var session_id = " + current_user.chrome_app_session_id + ";"
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
      # FileUtils.rm_rf("#{Rails.root}/tmp/#{current_user.chrome_app_session_id}")
      # File.delete("#{Rails.root}/tmp/#{current_user.chrome_app_session_id}.pem")

      send_file("#{Rails.root}/vendor/MovieArchitect.crx")
    end
  end
end
