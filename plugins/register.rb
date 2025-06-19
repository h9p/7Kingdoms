def user_commands(bot, message, db, bd)
  user_id = message.from.id
  
  if message && message.text == "/register" && !db[message.from.id]
    keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(
      inline_keyboard: [
        [
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'المملكة الشمالية', callback_data: "choose_kingdom:north"),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'المملكة الجنوبية', callback_data: "choose_kingdom:south")
        ],
        [
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'المملكة الشرقية', callback_data: "choose_kingdom:east"),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'المملكة الغربية', callback_data: "choose_kingdom:west")
        ],
        [
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'مملكة الجن', callback_data: "choose_kingdom:genie"),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'مملكة الغيلان', callback_data: "choose_kingdom:ghilan"),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: 'مملكة الأيلف', callback_data: "choose_kingdom:elf")
        ]
      ]
    )
    bot.api.send_message(chat_id: message.chat.id, text: "اختر مملكتك:", reply_markup: keyboard)
  end

  if callback_query&.data&.start_with?("choose_kingdom:")
    chosen_kingdom = callback_query.data.split(":")[1]
    unless db[callback_query.from.id]
      db[callback_query.from.id] = {
        "level" => 1,
        "Power" => 0,
        "Defanse" => 0,
        "res" => 0,
        "Gems" => 0,
        "Kingdom" => chosen_kingdom,
        "role" => "مواطن",
        "last_mine_time" => nil
      }
      bot.api.answer_callback_query(callback_query_id: callback_query.id, text: "تم تسجيلك في المملكة #{chosen_kingdom}. مرحباً بك! الرجاء البدء بالتعدين للحصول على الموارد.")
      
      mine_keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [
          [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'تعدين 🛠️', callback_data: "mine")]
        ]
      )
      bot.api.send_message(chat_id: callback_query.message.chat.id, text: "اضغط على زر التعدين لجمع الموارد. يمكنك التعدين مرة واحدة كل 3 دقائق.", reply_markup: mine_keyboard)
    else
      bot.api.answer_callback_query(callback_query_id: callback_query.id, text: "أنت مسجل بالفعل.")
    end
  end
end
