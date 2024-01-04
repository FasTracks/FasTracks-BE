FactoryBot.define do
  factory :song do
    name { Faker::Music.album }
  end
end
