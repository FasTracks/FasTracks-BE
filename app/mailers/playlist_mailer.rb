class PlaylistMailer < ApplicationMailer
  def send_playlist_email(email, playlist_link)
    @email = email
    @playlist_link = playlist_link

    mail( :to => @email,
    :subject => 'Open this message for your FasTracks playlist.',
    :content_type => "text/html")
  end
end
