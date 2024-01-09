require 'rails_helper'

RSpec.describe PlaylistSenderJob, type: :job do
  describe "#perform" do
    it "sends an email with a playlist link" do
      email = "test@example.com"
      playlist_link = "https://open.spotify.com/playlist/3cEYpjA9oz9GiPac4AsH4n"

      expect(PlaylistMailer).to receive(:send_playlist_email).with(email, playlist_link).and_call_original

      PlaylistSenderJob.new.perform(email, playlist_link)
    end
  end
end
