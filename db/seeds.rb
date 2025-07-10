# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# サンプルスロットを作成
puts "Creating sample slots..."

# 今週のスロットを作成
(0..6).each do |day_offset|
  date = Date.current + day_offset.days

  # 各日に複数の時間帯を作成
  [ 9, 10, 11, 14, 15, 16, 17 ].each do |hour|
    start_time = DateTime.new(date.year, date.month, date.day, hour, 0, 0)
    end_time = start_time + 30.minutes

    Slot.find_or_create_by!(
      start_time: start_time,
      end_time: end_time
    ) do |slot|
      slot.available = true
    end
  end
end

# サンプルメニューを作成
puts "Creating sample menus..."

menus_data = [
  { name: "リラクゼーションマッサージ", description: "心身ともにリラックスできる特別な時間", price: 5000, duration: 30 },
  { name: "ビューティーケア", description: "美しさを引き出すプロフェッショナルケア", price: 8000, duration: 30 },
  { name: "プレミアムトリートメント", description: "最高級のサービスで至福のひとときを", price: 12000, duration: 30 }
]

menus_data.each do |menu_data|
  Menu.find_or_create_by!(name: menu_data[:name]) do |menu|
    menu.description = menu_data[:description]
    menu.price = menu_data[:price]
    menu.duration = menu_data[:duration]
    menu.available = true
    menu.slot = Slot.first # 最初のスロットに関連付け
  end
end

puts "Sample data created successfully!"
