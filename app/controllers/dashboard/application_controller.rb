class Dashboard::ApplicationController < ActionController::Base

  protect_from_forgery
  protected
  http_basic_authenticate_with name: "admin", password: "!tseklisadministrator65fb35f526"
end
