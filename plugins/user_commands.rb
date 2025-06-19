# plugins/user_commands.rb

when '/profile', 'ملفي'
  if db[message.from.id]
    user = db[message.from.id]
    text = <<~TEXT
      🛡️ ملفك الشخصي:
      اسم المستخدم: #{user["username"]}
      المملكة: #{user["kingdom"] || "لم تختار بعد"}
      المستوى: #{user["level"]}
      الدور: #{user["role"]}
      الموارد: #{user["resources"]}
      القوة: #{user["power"]}
      الدفاع: #{user["defense"]}
      الجواهر: #{user["gems"]}
      الدرع: #{user["shield"] ? "مفعل" : "غير مفعل"}
    TEXT
    bot.api.send_message(chat_id: message.chat.id, text: text)
  else
    bot.api.send_message(chat_id: message.chat.id, text: "لم تسجل بعد. اكتب /start للتسجيل.")
  end

when '/help', 'مساعدة'
  help_text = <<~HELP
    أهلاً بك في لعبة حرب الممالك! 🏰⚔️

    الأوامر الأساسية:
    /start - تسجيل في اللعبة
    /profile - عرض ملفك الشخصي
    /kingdoms - عرض قائمة الممالك المتاحة
    /register_kingdom - اختيار مملكتك
    /attack - مهاجمة لاعب آخر (رد على رسالته و اكتب هجوم)
    /gift - إرسال موارد أو جواهر للاعب آخر (رد على رسالته و اكتب هدية <نوع> <كمية>)
    
    للمساعدة الإضافية تواصل مع المطور.
  HELP
  bot.api.send_message(chat_id: message.chat.id, text: help_text)

end
