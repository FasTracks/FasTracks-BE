class PlaylistSenderJob
  include Sidekiq::Job

  def perform(email, playlist_link)
    PlaylistMailer.send_playlist_email(email, playlist_link).deliver_now
  end
end
