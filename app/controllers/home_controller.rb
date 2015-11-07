require 'crxmake'

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:get_files]

  def index
    if current_user.chrome_app_session_id.blank? 
    
    end
  end

  def get_files
    # if current_user.chrome_app_session_id.blank?
    #   session_id = current_user.create_chrome_app_session_id
      # copy template chrome app directory named session_id
      # add session id to SimpleEditor.js
      # create crx
      dir = File.dirname("#{Rails.root}/tmp/"+current_user.chrome_app_session_id)
      p dir
      p current_user.chrome_app_session_id
      p "hello"
      FileUtils.mkdir_p(dir+"/"+current_user.chrome_app_session_id)
      FileUtils.cp_r("#{Rails.root}/public/movie-architect/.",dir+"/"+current_user.chrome_app_session_id)
      newfile = File.open("tmp/#{current_user.chrome_app_session_id}/test.js","w")
      newfile.puts "var session_id = " + current_user.chrome_app_session_id + ";"
      oldfile = File.open('tmp/#{current_user.chrome_app_session_id}/SimpleEditor.js', "r+")
      oldfile.each_line { |line| newfile.puts line}
      oldfile.close()
      newfile.close()
      File.delete("tmp/#{current_user.chrome_app_session_id}/SimpleEditor.js")
      File.rename("tmp/#{current_user.chrome_app_session_id}/test.js", "tmp/#{current_user.chrome_app_session_id}/SimpleEditor.js")
      
      # CrxMake.make(
      #   :ex_dir => "./src",
      #   :pkey   => "./test.pem",
      #   :crx_output => "./package/test.crx"
      # )
   # end
    puts "Hi..............";
  end

end
