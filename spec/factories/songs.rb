FactoryBot.define do
  factory :songs do
    name { Faker::Music::Prince.song }
  end
end