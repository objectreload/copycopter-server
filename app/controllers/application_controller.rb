class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :basic_authentication
  
  helper_method :prefer_html?
  hide_action :prefer_html?, :set_html_preference

  def prefer_html?
    session[:html_preference] == 'true'
  end

  def set_html_preference(preference)
    session[:html_preference] = preference
  end

  private
  
  def basic_authentication
    if Rails.env.production?
      authenticate_or_request_with_http_basic("Cramlr") do |username, password|
        username == HTTP_USERNAME && password == HTTP_PASSWORD
      end
    end
  end

  def find_by_id
    Project.find params[:id]
  end

  def find_by_localization_id
    if params[:localization_id]
      Localization.find(params[:localization_id]).project
    end
  end

  def find_by_project_id
    if params[:project_id]
      Project.find params[:project_id]
    end
  end
end