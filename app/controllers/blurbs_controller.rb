class BlurbsController < ApplicationController
  def destroy
    blurb = Blurb.find(params[:id])
    blurb.destroy
    flash[:notice] = 'Blurb successfully deleted'
    redirect_to blurb.project
  end
end
