class DownloadController < ApplicationController
  def show
    #send_file '/home/ubuntu/rails_app/ttmate_web/app/assets/images/traveltmate_logo_or.png', :type=>"image/png", :x_sendfile=>true
    response.headers['Content-Length'] = File.size("app/assets/images/traveltmate_logo_or.png").to_s
    send_file 'app/assets/images/traveltmate_logo_or.png', :type=>"image/png", :x_sendfile=>true

  end    
end