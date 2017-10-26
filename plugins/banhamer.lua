 local function NOVAR(msg, matches) 
local data = load_data(_config.moderation.data) 
----------------kick by replay ---------------- 
if matches[1] == 'طرد' and is_mod(msg) then 
   if msg.reply_id then 
if tonumber(msg.reply.id) == tonumber(our_id) then 
   return " `ليس مـن صـلاحيــﮭه‏‏ البوت طـرد آدمـن`💡🌐" 
    end 
if is_mod1(msg.to.id, msg.reply.id) then 
   return " `ليس مـن صـلاحيــﮭه البوت طـرد آدمـن`💡🌐" 
    else 
   kick_user(msg.reply.id, msg.to.id) 
 end 
   elseif matches[2] and not string.match(matches[2], '^%d+$') then 
   if not resolve_username(matches[2]).result then 
   return " `العضو لا يوجد في المجموعــﮭه`💡🌐" 
    end 
   local User = resolve_username(matches[2]).information 
if tonumber(User.id) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه‏‏ البوت طـرد آدمـن`💡🌐" 
    end 
if is_mod1(msg.to.id, User.id) then 
   return "`ليس مـن صـلاحيــﮭه‏‏ البوت طـرد آدمـن`💡🌐" 
     else 
   kick_user(User.id, msg.to.id) 
  end 
   elseif matches[2] and string.match(matches[2], '^%d+$') then 
if tonumber(matches[2]) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه‏‏ البوت طـرد آدمـن`💡🌐" 
    end 
if is_mod1(msg.to.id, tonumber(matches[2])) then 
   return "`ليس مـن صـلاحيــﮭه البوت طـرد آدمـن`💡🌐" 
   else 
     kick_user(tonumber(matches[2]), msg.to.id) 
        end 
     end 
   end 

---------------Ban------------------- 
if matches[1] == 'حظر' and is_mod(msg) then 
if msg.reply_id then 
if tonumber(msg.reply.id) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن`💡🌐" 
    end 
if is_mod1(msg.to.id, msg.reply.id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن`💡🌐" 
    end 
  if is_banned(msg.reply.id, msg.to.id) then 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ بالفعل تم حضره عام 💡🌐`" 
    else 
ban_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id) 
     kick_user(msg.reply.id, msg.to.id) 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🔗┊ `تم حضره عام 💡🌐`" 
  end 
   elseif matches[2] and not string.match(matches[2], '^%d+$') then 
   if not  resolve_username(matches[2]).result then 
   return "`العضو لا يوجد في المجموعــﮭه`💡🌐" 
    end 
   local User = resolve_username(matches[2]).information 
if tonumber(User.id) == tonumber(our_id) then 
   return "`العضو لا يوجد في المجموعــﮭه`💡🌐" 
    end 
if is_mod1(msg.to.id, User.id) then 
   return "`ليس مـن صـلاحيــﮭه‏‏ البوت حظـر آدمـن`💡🌐" 
    end 
  if is_banned(User.id, msg.to.id) then 
    return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن`💡🌐"..check_markdown(User.username).." "..User.id.." `🔗┊ بالفعل تم حضره عام 💡🌐`" 
    else 
   ban_user(check_markdown(User.username), User.id, msg.to.id) 
     kick_user(User.id, msg.to.id) 
    return "`العہٰ۫ﹻﹻﹻضہٰ۫ﹻﹻﹻـو`"..check_markdown(User.username).." "..User.id.." 🔗┊ `تم حضره عام 💡🌐`" 
  end 
   elseif matches[2] and string.match(matches[2], '^%d+$') then 
if tonumber(matches[2]) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن` 💡🌐" 
    end 
if is_mod1(msg.to.id, tonumber(matches[2])) then 
   return "`ليس مـن صـلاحيــﮭه‏‏ البوت حظـر آدمـن` 💡🌐" 
    end 
  if is_banned(tonumber(matches[2]), msg.to.id) then 
    return "`👨┊ العضو` : @"..matches[2].."\n`🔗┊ بالفعل تم حضره عام 💡🌐`" 
    else 
   ban_user('', matches[2], msg.to.id) 
     kick_user(tonumber(matches[2]), msg.to.id) 
    return "`👨┊ العضو` : @"..matches[2].."\n 🔗┊ `تم حضره عام 💡🌐`" 
        end 
     end 
   end 

---------------Unban------------------- 

if matches[1] == 'الغاء حظر' and is_mod(msg) then 
if msg.reply_id then 
if tonumber(msg.reply.id) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه‏‏ البوت حظـر آدمـن` 💡🌐" 
    end 
if is_mod1(msg.to.id, msg.reply.id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن` 💡🌐" 
    end 
  if not is_banned(msg.reply.id, msg.to.id) then 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ بالفعل تم الغاء الحضر عنــﮭه` 💡🌐" 
    else 
unban_user(msg.reply.id, msg.to.id) 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ تم الغاء الحضر عنــﮭه` 💡🌐" 
  end 
   elseif matches[2] and not string.match(matches[2], '^%d+$') then 
   if not resolve_username(matches[2]).result then 
   return "`العضو لا يوجد في المجموعــﮭه` 💡🌐" 
    end 
   local User = resolve_username(matches[2]).information 
  if not is_banned(User.id, msg.to.id) then 
    return "`👨┊ العضو` : @"..check_markdown(User.username).."\n 🚸┊الايدي :"..User.id.."\n`🔗┊ بالفعل تم الغاء الحضر عنــﮭه` 💡🌐" 
    else 
   unban_user(User.id, msg.to.id) 
    return "`👨┊ العضو` : @"..check_markdown(User.username).."\n 🚸┊الايدي :"..User.id.."\n`🔗┊ تم الغاء الحضر عنــﮭه` 💡🌐" 
  end 
   elseif matches[2] and string.match(matches[2], '^%d+$') then 
  if not is_banned(tonumber(matches[2]), msg.to.id) then 
    return "`👨┊ العضو` : @"..matches[2].."\n`🔗┊ بالفعل تم الغاء الحضر عنــﮭه` 💡🌐" 
    else 
   unban_user(matches[2], msg.to.id) 
    return "`👨┊ العضو` : @"..matches[2].."\n`🔗┊ تم الغاء الحضر عنــﮭه` 💡🌐" 
        end 
     end 
   end 

------------------------Silent------------------------------------- 

if matches[1] == 'كتم' and is_mod(msg) then 
if msg.reply_id then 
if tonumber(msg.reply.id) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت ڪتم آدمـن` 💡🌐" 
    end 
if is_mod1(msg.to.id, msg.reply.id) then 
   return "`ليس مـن صـلاحيــﮭه‏‏ البوت ڪتم آدمـن` 💡🌐" 
    end 
  if is_silent_user(msg.reply.id, msg.to.id) then 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ بالفعل تم ڪتمــﮭه سابقآ` 💡🌐️" 
    else 
silent_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id) 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ تم ڪتم العضو بنجاح` 💡🌐️" 
  end 
   elseif matches[2] and not string.match(matches[2], '^%d+$') then 
   if not resolve_username(matches[2]).result then 
   return "`العضو لا يوجد في المجموعــﮭه` 💡🌐" 
    end 
   local User = resolve_username(matches[2]).information 
if tonumber(User.id) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت ڪتم آدمـن` 💡🌐" 
    end 
if is_mod1(msg.to.id, User.id) then 
   return "`ليس مـن صـلاحيــﮭه البوت ڪتم آدمـن` 💡🌐" 
    end 
  if is_silent_user(User.id, msg.to.id) then 
    return "`👨┊ العضو` : @"..check_markdown(User.username).."\n 🚸┊الايدي :"..User.id.."\n`🔗┊ بالفعل تم ڪتمــﮭه سابقآ` 💡🌐️" 
    else 
   silent_user("@"..check_markdown(User.username), User.id, msg.to.id) 
    return"`👨┊ العضو` : @"..check_markdown(User.username).."\n 🚸┊الايدي :"..User.id.."\n`🔗┊ تم ڪتم العضو بنجاح` 💡🌐️" 
  end 
   elseif matches[2] and string.match(matches[2], '^%d+$') then 
if tonumber(matches[2]) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت ڪتم آدمـن` 💡🌐" 
    end 
if is_mod1(msg.to.id, tonumber(matches[2])) then 
   return "`ليس مـن صـلاحيــﮭه‏‏ البوت ڪتم آدمـن` 💡🌐" 
    end 
  if is_silent_user(tonumber(matches[2]), msg.to.id) then 
    return "`👨┊ العضو` : @"..matches[2].."\n`🔗┊ بالفعل تم ڪتمــﮭه سابقآ` 💡🌐️" 
    else 
   ban_user('', matches[2], msg.to.id) 
     kick_user(tonumber(matches[2]), msg.to.id) 
    return "`👨┊ العضو` : @"..matches[2].."\n`🔗┊ تم ڪتم العضو بنجاح` 💡🌐️" 
        end 
     end 
   end 

------------------------Unsilent---------------------------- 
if matches[1] == 'الغاء الكتم' and is_mod(msg) then 
if msg.reply_id then 
if tonumber(msg.reply.id) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت ڪتم آدمـن` 💡🌐" 
    end 
if is_mod1(msg.to.id, msg.reply.id) then 
   return "`ليس مـن صـلاحيــﮭه‏‏ البوت ڪتم آدمـن` 💡🌐" 
    end 
  if not is_silent_user(msg.reply.id, msg.to.id) then 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ بالفعل تم الغاء ڪتمــﮭه سابقآ` 💡🌐" 
    else 
unsilent_user(msg.reply.id, msg.to.id) 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ تم الغاء الڪتم عن هذا العضو` 💡🌐" 
  end 
   elseif matches[2] and not string.match(matches[2], '^%d+$') then 
   if not resolve_username(matches[2]).result then 
   return "`العضو لا يوجد في المجموعــﮭه` 💡🌐" 
    end 
   local User = resolve_username(matches[2]).information 
  if not is_silent_user(User.id, msg.to.id) then 
    return "`👨┊ العضو` : @"..check_markdown(User.username).."\n 🚸┊الايدي :"..User.id.."\n`🔗┊ بالفعل تم الغاء ڪتمــﮭه سابقآ` 💡🌐" 
    else 
   unsilent_user(User.id, msg.to.id) 
    return "`👨┊ العضو` : @"..check_markdown(User.username).."\n 🚸┊الايدي :"..User.id.."\n`🔗┊ تم الغاء الڪتم عن هذا العضو` 💡🌐️" 
  end 
   elseif matches[2] and string.match(matches[2], '^%d+$') then 
  if not is_silent_user(tonumber(matches[2]), msg.to.id) then 
    return "`👨┊ العضو` : @"..matches[2].."\n`🔗┊ بالفعل تم الغاء ڪتمــﮭه سابقآ` 💡🌐" 
    else 
   unsilent_user(matches[2], msg.to.id) 
    return "`👨┊ العضو` : @"..matches[2].."\n`🔗┊ تم الغاء الڪتم عن هذا العضو` 💡🌐️" 
        end 
     end 
   end 
-------------------------Banall------------------------------------- 
if matches[1] == 'حظر عام' and is_admin(msg) then 
if msg.reply_id then 
if tonumber(msg.reply.id) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن` 💡🌐" 
    end 
if is_admin1(msg.reply.id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن` 💡🌐" 
    end 
  if is_gbanned(msg.reply.id) then 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ بالفعل تم حضره عام 💡🌐`" 
    else 
banall_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id) 
     kick_user(msg.reply.id, msg.to.id) 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🔗┊ `تم حضره عام 💡🌐`" 
  end 
   elseif matches[2] and not string.match(matches[2], '^%d+$') then 
   if not resolve_username(matches[2]).result then 
   return "`العضو لا يوجد في المجموعــﮭه` 💡🌐" 
    end 
   local User = resolve_username(matches[2]).information 
if tonumber(User.id) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن` 💡🌐" 
    end 
if is_admin1(User.id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن` 💡🌐" 
    end 
  if is_gbanned(User.id) then 
    return "`👨┊ العضو` : @"..check_markdown(User.username).."\n 🚸┊الايدي :"..User.id.."\n`🔗┊ بالفعل تم حضره عام 💡🌐`" 
    else 
   banall_user("@"..check_markdown(User.username), User.id) 
     kick_user(User.id, msg.to.id) 
    return "`👨┊ العضو` : @"..check_markdown(User.username).."\n 🚸┊الايدي :"..User.id.."\n🔗┊ `تم حضره عام 💡🌐`" 
  end 
   elseif matches[2] and string.match(matches[2], '^%d+$') then 
if is_admin1(tonumber(matches[2])) then 
if tonumber(matches[2]) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن` 💡🌐" 
    end 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن` 💡🌐" 
    end 
  if is_gbanned(tonumber(matches[2])) then 
    return "`👨┊ العضو` : @"..matches[2].."\n`🔗┊ بالفعل تم حضره عام 💡🌐`" 
    else 
   banall_user('', matches[2]) 
     kick_user(tonumber(matches[2]), msg.to.id) 
    return "`👨┊ العضو` : @"..matches[2].."\n🔗┊ `تم حضره عام 💡🌐`" 
        end 
     end 
   end 
--------------------------Unbanall------------------------- 

if matches[1] == 'الغاء العام' and is_admin(msg) then 
if msg.reply_id then 
if tonumber(msg.reply.id) == tonumber(our_id) then 
   return "`ليس مـن صـلاحيــﮭه البوت حظـر آدمـن` 💡🌐" 
    end 
if is_mod1(msg.to.id, msg.reply.id) then 
   return "`ليس من صـلاحيــﮭه‏‏ البوت حظـر آدمـن` 💡🌐" 
    end 
  if not is_gbanned(msg.reply.id) then 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n `🔗┊ بالفعل تم الغاء حضره عام` 💡🌐" 
    else 
unbanall_user(msg.reply.id) 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ تم الغاء حضره عام` 💡🌐" 
  end 
   elseif matches[2] and not string.match(matches[2], '^%d+$') then 
   if not resolve_username(matches[2]).result then 
   return "`العضو لا يوجد في المجموعــﮭه` 💡🌐" 
    end 
   local User = resolve_username(matches[2]).information 
  if not is_gbanned(User.id) then 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ بالفعل تم الغاء حضره عام` 💡🌐" 
    else 
   unbanall_user(User.id) 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ تم الغاء حضره عام` 💡🌐" 
  end 
   elseif matches[2] and string.match(matches[2], '^%d+$') then 
  if not is_gbanned(tonumber(matches[2])) then 
    return "`👨┊ العضو :`"..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🚸┊` الايدي ` : "..msg.reply.id.."\n`🔗┊ بالفعل تم الغاء حضره عام` 💡🌐" 
    else 
   unbanall_user(matches[2]) 
    return "`👨┊ العضو` : @"..matches[2].."\n`🔗┊ تم الغاء حضره عام` 💡🌐" 
        end 
     end 
   end 
   -----------------------------------LIST--------------------------- 
   if matches[1] == 'المحظورين' and is_mod(msg) then 
   return banned_list(msg.to.id) 
   end 
   if matches[1] == 'المكتومين' and is_mod(msg) then 
   return silent_users_list(msg.to.id) 
   end 
   if matches[1] == 'قائمه العام' and is_admin(msg) then 
   return gbanned_list(msg) 
   end 
   ---------------------------clean--------------------------- 
   if matches[1] == 'مسح' and is_mod(msg) then 
   if matches[2] == 'المحظورين' then 
      if next(data[tostring(msg.to.id)]['banned']) == nil then 
         return " `لم يتم العثور عن المحظورين`️ 💡🌐" 
      end 
      for k,v in pairs(data[tostring(msg.to.id)]['banned']) do 
         data[tostring(msg.to.id)]['banned'][tostring(k)] = nil 
         save_data(_config.moderation.data, data) 
      end 
      return "`تم مسح المحظورين` 💡🌐" 
   end 
   if matches[2] == 'المكتومين' then 
      if next(data[tostring(msg.to.id)]['is_silent_users']) == nil then 
         return "`لم يتم العثور عن المڪتومين` 💡🌐" 
      end 
      for k,v in pairs(data[tostring(msg.to.id)]['is_silent_users']) do 
         data[tostring(msg.to.id)]['is_silent_users'][tostring(k)] = nil 
         save_data(_config.moderation.data, data) 
      end 
      return "`تم مسح المڪتومين` 💡🌐" 
   end 
   if matches[2] == 'قائمه العام' and is_admin(msg) then 
      if next(data['gban_users']) == nil then 
         return "`لم يتم العثور عن المحظورين عا۾` 💡🌐" 
      end 
      for k,v in pairs(data['gban_users']) do 
         data['gban_users'][tostring(k)] = nil 
         save_data(_config.moderation.data, data) 
      end 
      return "`تم مسح قائمــﮭه العام` 💡🌐" 
   end 
   end 

end 
return { 
   patterns = { 
"^(حظر) (.*)$", 
"^(حظر)$", 
"^(الغاء حظر) (.*)$", 
"^(الغاء حظر)$", 
"^(طرد) (.*)$", 
"^(طرد)$", 
"^(حظر عام) (.*)$", 
"^(حظر عام)$", 
"^(الغاء العام) (.*)$", 
"^(الغاء العام)$", 
"^(الغاء الكتم) (.*)$", 
"^(الغاء الكتم)$", 
"^(كتم) (.*)$", 
"^(كتم)$", 
"^(المكتومين)$", 
"^(المحظورين)$", 
"^(قائمه العام)$", 
"^(مسح) (.*)$", 
   }, 
   run = NOVAR, 

} 
