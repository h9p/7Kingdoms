require 'time'
require 'telegram/bot'

def handle_mining(bot, db, callback_query)
  user_id = callback_query.from.id
  now = Time.now

  user_data = db[user_id]
  if user_data.nil?
    bot.api.answer_callback_query(callback_query_id: callback_query.id, text: "يجب أن تسجل أولاً باستخدام /register")
    return
  end

  last_mine = user_data["last_mine_time"] ? Time.parse(user_data["last_mine_time"]) : Time.at(0)
  elapsed = now - last_mine

  if elapsed >= 180 # 3 دقائق
    # اضافة موارد التعدين
    user_data["res"] += 10
    user_data["Gems"] += 1
    user_data["Power"] += 5
    user_data["last_mine_time"] = now.iso8601

    bot.api.answer_callback_query(callback_query_id: callback_query.id, text: "تم التعدين بنجاح! حصلت على 10 موارد، 1 جوهرة، و5 قوة 💪")
    bot.api.send_message(chat_id: callback_query.message.chat.id, text: "مواردك الآن:\nموارد: #{user_data["res"]}\nجواهر: #{user_data["Gems"]}\nقوة: #{user_data["Power"]}")
  else
    remaining = (180 - elapsed).ceil
    bot.api.answer_callback_query(callback_query_id: callback_query.id, text: "يمكنك التعدين مرة أخرى بعد #{remaining} ثانية.")
  end
end
