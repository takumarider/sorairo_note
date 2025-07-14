require_relative "boot"

require "rails/all"

# Gemfile に記載された gem を読み込む
Bundler.require(*Rails.groups)

# .env の環境変数を読み込む（開発・テスト環境のみ）
if Rails.env.development? || Rails.env.test?
  require "dotenv/load"
end

module SorairoNote
  class Application < Rails::Application
    # 使用する Rails バージョンの初期設定を読み込む
    config.load_defaults 8.0

    # lib ディレクトリのうち、読み込まないサブディレクトリを指定
    config.autoload_lib(ignore: %w[assets tasks])

    # アセットパイプラインのパスに追加
    config.assets.paths << Rails.root.join("app/assets/builds")
    config.assets.paths << Rails.root.join("app/assets/stylesheets")

    # タイムゾーンや eager_load_paths の追加設定は必要に応じて
    # config.time_zone = "Tokyo"
    # config.eager_load_paths << Rails.root.join("lib")
  end
end
