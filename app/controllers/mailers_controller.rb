class MailersController < ApplicationController
  def create
    PlaylsitSenderJob.perform_async(params[:mailers][:email], params[:mailers][:playlist_link])
  end
end