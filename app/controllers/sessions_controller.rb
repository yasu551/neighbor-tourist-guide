class SessionsController < ApplicationController
  def create
    if (user = User.find_or_create_from_auth_hash(auth_hash))
      log_in user
    end
    redirect_to root_path
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
