require "rails_helper"

describe "Spotify API service" do
  before(:each) do
    genres = %w[acoustic afrobeat alt-rock alternative ambient anime black-metal bluegrass blues bossanova brazil breakbeat british cantopop chicago-house children chill classical club comedy country dance dancehall death-metal deep-house detroit-techno disco disney drum-and-bass dub dubstep edm electro electronic emo folk forro french funk garage german gospel goth grindcore groove grunge guitar happy hard-rock hardcore hardstyle heavy-metal hip-hop holidays honky-tonk house idm indian indie indie-pop industrial iranian j-dance j-idol j-pop j-rock jazz k-pop kids latin latino malay mandopop metal metal-misc metalcore minimal-techno movies mpb new-age new-release opera pagode party philippines-opm piano pop pop-film post-dubstep power-pop progressive-house psych-rock punk punk-rock r-n-b rainy-day reggae reggaeton road-trip rock rock-n-roll rockabilly romance sad salsa samba sertanejo show-tunes singer-songwriter ska sleep songwriter soul soundtracks spanish study summer swedish synth-pop tango techno trance trip-hop turkish work-out world-music]
    allow(SpotifyApiService).to receive(:get_genres).with("fakeToken").and_return({data: {genres: genres}})
  end

  it "retrieves genres" do
    response = SpotifyApiService.get_genres("fakeToken")
    expect(response).to be_a Hash
    expect(response[:data][:genres]).to be_a Array
  end

  it "retrieves recommended tracks" do
    rec_response = File.read("spec/fixtures/songs_selection/songs.json")

    stub_request(:get, "https://api.spotify.com/v1/recommendations?limit=10&seed_genres=pop&target_tempo=140")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer 1234",
          "User-Agent" => "Faraday v2.8.1"
        }
      )
      .to_return(status: 200, body: rec_response, headers: {})

    response = SpotifyApiService.get_song_recommendations("1234", "pop", 140, 10)

    expect(response[:status]).to eq 200

    expect(response[:data]).to have_key(:tracks)

    response[:data][:tracks].each do |track|
      expect(track).to have_key(:uri)
      expect(track).to have_key(:name)
      expect(track[:uri]).to be_a(String)
      expect(track[:name]).to be_a(String)

      track[:artists].each do |artist|
        expect(artist[:name]).to be_a(String)
      end
    end
  end
end
