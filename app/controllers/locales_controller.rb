class LocalesController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
  end
end
