def callbacks(bot, callback_query, db, bd)
  user_id = callback_query.from.id
  data = callback_query.data

if update.callback_query
  user_id = update.callback_query.from.id
  data = update.callback_query.data

  if data.start_with?('kingdom_')
    kingdom_name = case data
                   when 'kingdom_north' then 'المملكة الشمالية'
                   when 'kingdom_south' then 'المملكة الجنوبية'
                   when 'kingdom_east' then 'المملكة الشرقية'
                   when 'kingdom_west' then 'المملكة الغربية'
                   when 'kingdom_jinn' then 'مملكة الجن'
                   when 'kingdom_ghilan' then 'مملكة الغيلان'
                   when 'kingdom_elf' then 'مملكة الأيلف'
                   else 'غير معروف'
                   end

    if db[user_id]
      bot.api.answer_callback_query(callback_query_id: update.callback_query.id, text: "أنت مسجل بالفعل في اللعبة.")
    else
      db.transaction do
        db[user_id] = {
          "username" => update.callback_query.from.username || update.callback_query.from.first_name,
          "level" => 1,
          "kingdom" => kingdom_name,
          "resources" => 100,
          "power" => 10,
          "defense" => 5,
          "shield" => false,
          "gems" => 0,
          "role" => "مواطن"
        }
      end

      bot.api.edit_message_text(
        chat_id: update.callback_query.message.chat.id,
        message_id: update.callback_query.message.message_id,
        text: "تم تسجيلك في اللعبة وانضممت إلى #{kingdom_name} بنجاح! يمكنك الآن بدء اللعب."
      )
      bot.api.answer_callback_query(callback_query_id: update.callback_query.id)
    end
  end
end
