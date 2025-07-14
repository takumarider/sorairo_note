# Puma configuration file for production deployment on Render

# スレッド数設定（最小・最大ともに同じ値）
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Webサービスのポート（Renderが環境変数 PORT を渡してくる）
port ENV.fetch("PORT") { 3000 }

# 実行環境（production 等）
environment ENV.fetch("RAILS_ENV") { "development" }

# プロセス数（Render の Webサービスでは 1~2 を想定）
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# pid ファイル（Render では通常指定不要だが、必要なら）
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Worker モード用：コードのプリロード（効率的な起動のため）
preload_app!

# Workerが起動するたびに接続を再確立（DBなど）
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Renderでは `bin/rails restart` を使えるようにする
plugin :tmp_restart
