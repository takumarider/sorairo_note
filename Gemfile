source "https://rubygems.org"

gem "rails", "~> 8.0.3"
gem "propshaft"

# DB: ローカルはMySQL、本番はPostgreSQL
gem "mysql2", "~> 0.5" # development & test
gem "pg", group: :production

gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# 認証
gem "bcrypt", "~> 3.1.7" # devise用
gem "devise"

# Windows互換用
gem "tzinfo-data", platforms: %i[windows jruby]

# Solid系
# gem "solid_cache"
# gem "solid_queue"
# gem "solid_cable"

# 起動高速化・デプロイ系
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

# ActiveStorage（今は未使用。将来使うなら有効化）
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "dotenv-rails" # 開発・テスト環境だけ
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
