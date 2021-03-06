class MainController < ApplicationController
  def index
  end


  ### Helper Methods###
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end


	# Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

   # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])	#assign session-user if current_user is nil.
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])	#else assign it to cookie user.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget #forget in user model, updates remember_digest to nil.
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


# Logs out the current user.
  def log_out
  	forget(current_user)	#forget(user) in helper.
    session.delete(:user_id)
    @current_user = nil
  end

end
