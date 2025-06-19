require 'json'
require 'telegram/bot'
require 'yaml/store'

# تحميل الإعدادات
config_file = File.read('config.json')
@config = JSON.parse(config_file)

# قواعد بيانات اللعبة والمستخدمين
db = YAML::Store.new('Game.yml')
bd = YAML::Store.new('banned.yml')

token = @config["Token"]
owner_id = @config["owner_id"]
admins = @config["admins"]

# تحميل ملفات الأوامر (plugins)
require_relative './plugins/admin_commands'
require_relative './plugins/user_commands'
require_relative './plugins/callbacks'

Telegram::Bot::Client.run(token) do |bot|
  puts "Bot started successfully, version #{@config["Version"]}"

  bot.listen do |message|
    user_id = message.from.id
    is_owner = (user_id == owner_id)
    is_admin = admins.include?(user_id)

    # تجاهل المحظورين
    banned = bd.transaction { bd.roots.include?(user_id) } || @config["bban"].include?(user_id)
    next if banned

    # طباعة معلومات المستخدم (للتجربة)
    puts "Message from: #{message.from.username} (ID: #{user_id}), Owner: #{is_owner}, Admin: #{is_admin}"

    # تشغيل أوامر المطورين والإداريين
    admin_commands(bot, message, db, bd, is_owner, is_admin)
    
    # تشغيل أوامر المستخدمين العامة
    user_commands(bot, message, db, bd)

    # التعامل مع ردود الأزرار (Callback Queries)
    if message.is_a?(Telegram::Bot::Types::CallbackQuery)
      callbacks(bot, message, db, bd)
    end
  end
end
