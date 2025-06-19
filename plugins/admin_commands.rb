# plugins/admin_commands.rb

# شروط صلاحيات المستخدم
def admin_commands(bot, message, db, bd, is_owner, is_admin)
  user_id = message.from.id
  return unless is_owner || is_admin
end

# تنفيذ أوامر خاصة بالمطور والمشرفين
case message.text
when '/ban'
  if is_admin?(message.from.id) || is_owner?(message.from.id)
    if message.reply_to_message
      user_to_ban = message.reply_to_message.from.id
      bd.transaction do
        bd[user_to_ban] = true
      end
      bot.api.send_message(chat_id: message.chat.id, text: "🚫 تم حظر المستخدم بنجاح.")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "يرجى الرد على رسالة المستخدم الذي تريد حظره.")
    end
  else
    bot.api.send_message(chat_id: message.chat.id, text: "❌ ليس لديك صلاحية استخدام هذا الأمر.")
  end

when '/unban'
  if is_admin?(message.from.id) || is_owner?(message.from.id)
    if message.reply_to_message
      user_to_unban = message.reply_to_message.from.id
      bd.transaction do
        bd.delete(user_to_unban)
      end
      bot.api.send_message(chat_id: message.chat.id, text: "✅ تم إلغاء الحظر عن المستخدم.")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "يرجى الرد على رسالة المستخدم الذي تريد إلغاء حظره.")
    end
  else
    bot.api.send_message(chat_id: message.chat.id, text: "❌ ليس لديك صلاحية استخدام هذا الأمر.")
  end

when '/stats'
  if is_owner?(message.from.id)
    bot.api.send_message(chat_id: message.chat.id, text: "📊 عدد المحظورين: #{bd.transaction { bd.roots.size }}")
  else
    bot.api.send_message(chat_id: message.chat.id, text: "❌ فقط المطور يمكنه استخدام هذا الأمر.")
  end

when '/restart'
  if is_owner?(message.from.id)
    bot.api.send_message(chat_id: message.chat.id, text: "🔄 جاري إعادة تشغيل البوت...")
    exec("ruby main.rb") # يعيد تشغيل السكربت
  else
    bot.api.send_message(chat_id: message.chat.id, text: "❌ فقط المطور يمكنه استخدام هذا الأمر.")
  end
end
