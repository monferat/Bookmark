class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to bookmarkers_path(uid: current_user.uid)
    else
      render 'index'
    end
  end
end
