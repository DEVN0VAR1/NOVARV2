   local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 

local function index_function(user_id) 
  for k,v in pairs(_config.admins) do 
    if user_id == v[1] then 
       print(k) 
      return k 
    end 
  end 
  -- If not found 
  return false 
end 

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end 

--By @N0VAR 
local function already_sudo(user_id) 
  for k,v in pairs(_config.sudo_users) do 
    if user_id == v then 
      return k 
    end 
  end 
  -- If not found 
  return false 
end 

--By @N0VAR 
local function already_admin(user_id) 
  for k,v in pairs(_config.admins) do 
    if user_id == v[1] then 
       print(k) 
      return k 
    end 
  end 
  -- If not found 
  return false 
end 

--By @N0VAR 
local function sudolist(msg) 
local sudo_users = _config.sudo_users 
local text = "\n `💳￤الــمطوريــن`\n`🔹 ~ ~ ~ ~ ~ ~ ~ ~ ~ 🔹`\n\n" 
for i=1,#sudo_users do 
    text = text..i.." - "..sudo_users[i].."\n" 
end 
return text 
end 

local function adminlist(msg) 
 text = '\n `💳￤الادارييــن`\n`🔹 ~ ~ ~ ~ ~ ~ ~ ~ ~ 🔹`\n\n'
           local compare = text 
           local i = 1 
           for v,user in pairs(_config.admins) do 
             text = text..i..'- '..(user[2] or '')..' 📎 ('..user[1]..')\n' 
           i = i +1 
           end 
           if compare == text then 
              text = ' `لايوجد اداريين في البوت` 💡🌐' 
           end 
           return text 
    end 

local function chat_list(msg) 
   i = 1 
   local data = load_data(_config.moderation.data) 
    local groups = 'groups' 
    if not data[tostring(groups)] then 
        return ' 💡🌐`لاتوجد مجموعات مفعلــﮭه` ' 
    end 
    local message = ' ┋`عدد المجموعات ️\n┋`المفعلــﮭه في هذا البوت` \n\n' 
    for k,v in pairsByKeys(data[tostring(groups)]) do 
      local group_id = v 
      if data[tostring(group_id)] then 
         settings = data[tostring(group_id)]['settings'] 
      end 
        for m,n in pairsByKeys(settings) do 
         if m == 'set_name' then 
            name = n:gsub("", "") 
            chat_name = name:gsub("‮", "") 
            group_name_id = name .. '\n(🔴 : ' ..group_id.. ')\n' 
            if name:match("[\216-\219][\128-\191]") then 
               group_info = i..' - \n'..group_name_id 
            else 
               group_info = i..' - '..group_name_id 
            end 
            i = i + 1 
         end 
        end 
      message = message..group_info 
    end 
   return message 
end 

local function run(msg, matches) 
    local data = load_data(_config.moderation.data) 
   if matches[1] == "المطورين" and is_sudo(msg) then 
    return sudolist(msg) 
   end 
  if tonumber(msg.from.id) == tonumber(sudo_id) then 
   if matches[1] == "رفع مطور" then 
   if not matches[2] and msg.reply_to_message then 
   if msg.reply.username then 
   username = "@"..check_markdown(msg.reply.username) 
    else 
   username = escape_markdown(msg.reply.print_name) 
    end 
   if already_sudo(tonumber(msg.reply.id)) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم ترقيتــﮭه الى مطور` 💡🌐" 
    else 
          table.insert(_config.sudo_users, tonumber(msg.reply.id)) 
      print(msg.reply.id..' `تم ترقيتــﮭه الى مطور` 💡🌐') 
     save_config() 
     reload_plugins(true) 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم ترقيتــﮭه الى مطور` 💡🌐" 
      end 
     elseif matches[2] and matches[2]:match('^%d+') then 
   if not getUser(matches[2]).result then 
   return "┋`العضو غير متوفر`" 
    end 
     local user_name = '@'..check_markdown(getUser(matches[2]).information.username) 
     if not user_name then 
      user_name = escape_markdown(getUser(matches[2]).information.first_name) 
     end 
   if already_sudo(tonumber(matches[2])) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم ترقيتــﮭه الى مطور`💡🌐" 
    else 
           table.insert(_config.sudo_users, tonumber(matches[2])) 
      print(matches[2]..' `تم ترقيتــﮭه الى مطور` 💡🌐') 
     save_config() 
     reload_plugins(true) 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم ترقيتــﮭه الى مطور` 💡🌐" 
   end 
   elseif matches[2] and not matches[2]:match('^%d+') then 
   if not resolve_username(matches[2]).result then 
   return "┋`العضو غير متوفر` " 
    end 
   local status = resolve_username(matches[2]) 
   if already_sudo(tonumber(status.information.id)) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم ترقيتــﮭه الى مطور` 💡🌐" 
    else 
          table.insert(_config.sudo_users, tonumber(status.information.id)) 
      print(status.information.id..' `تم ترقيتــﮭه الى مطور` 💡🌐') 
     save_config() 
     reload_plugins(true) 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم ترقيتــﮭه الى مطور` 💡🌐" 
     end 
  end 
end 
   if matches[1] == "تنزيل مطور" then 
      if not matches[2] and msg.reply_to_message then 
   if msg.reply.username then 
   username = "@"..check_markdown(msg.reply.username) 
    else 
   username = escape_markdown(msg.reply.print_name) 
    end 
   if not already_sudo(tonumber(msg.reply.id)) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم تنزيلــﮭه من قائمــﮭه المطور` 💡🌐" 
    else 
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(msg.reply.id))) 
      save_config() 
     reload_plugins(true) 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم تنزيلــﮭه من قائمــﮭه المطور` 💡🌐" 
      end 
     elseif matches[2] and matches[2]:match('^%d+') then 
  if not getUser(matches[2]).result then 
   return "┋`العضو غير متوفر` " 
    end 
     local user_name = '@'..check_markdown(getUser(matches[2]).information.username) 
     if not user_name then 
      user_name = escape_markdown(getUser(matches[2]).information.first_name) 
     end 
   if not already_sudo(tonumber(matches[2])) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم تنزيلــﮭه من قائمــﮭه المطور` 💡🌐" 
    else 
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(matches[2]))) 
      save_config() 
     reload_plugins(true) 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم تنزيله من قائمــﮭه المطور` 💡🌐" 
      end 
   elseif matches[2] and not matches[2]:match('^%d+') then 
   if not resolve_username(matches[2]).result then 
   return "┋`العضو غير متوفر` " 
    end 
   local status = resolve_username(matches[2]) 
   if not already_sudo(tonumber(status.information.id)) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم تنزيلــﮭه من قائمــﮭه المطور` 💡🌐" 
    else 
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(status.information.id))) 
      save_config() 
     reload_plugins(true) 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم تنزيلــﮭه من قائمــﮭه المطور` 💡🌐" 
          end 
      end 
   end 
end 
  if is_sudo(msg) then 
   if matches[1] == "رفع اداري" then 
   if not matches[2] and msg.reply_to_message then 
   if msg.reply.username then 
   username = "@"..check_markdown(msg.reply.username) 
    else 
   username = escape_markdown(msg.reply.print_name) 
    end 
   if already_admin(tonumber(msg.reply.id)) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم رفعــﮭه اداري في البوت` 💡🌐" 
    else 
       table.insert(_config.admins, {tonumber(msg.reply.id), username}) 
      save_config() 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم رفعــﮭه اداري في البوت` 💡🌐" 
      end 
     elseif matches[2] and matches[2]:match('^%d+') then 
   if not getUser(matches[2]).result then 
   return "┋`العضو غير متوفر`" 
    end 
     local user_name = '@'..check_markdown(getUser(matches[2]).information.username) 
     if not user_name then 
      user_name = escape_markdown(getUser(matches[2]).information.first_name) 
     end 
   if already_admin(tonumber(matches[2])) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم رفعــﮭه اداري في البوت` 💡🌐" 
    else 
       table.insert(_config.admins, {tonumber(matches[2]), user_name}) 
      save_config() 
    return "┋`العضو`  "..user_name.." "..matches[2].."\n `تم رفعــﮭه اداري في البوت` 💡🌐" 
   end 
   elseif matches[2] and not matches[2]:match('^%d+') then 
   if not resolve_username(matches[2]).result then 
   return "┋`العضو غير متوفر` " 
    end 
   local status = resolve_username(matches[2]) 
   if already_admin(tonumber(status.information.id)) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم رفعــﮭه اداري في البوت`  💡🌐" 
    else 
       table.insert(_config.admins, {tonumber(status.information.id), check_markdown(status.information.username)}) 
      save_config() 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم رفعــﮭه اداري في البوت` 💡🌐" 
     end 
  end 
end 
   if matches[1] == "تنزيل اداري" then 
      if not matches[2] and msg.reply_to_message then 
   if msg.reply.username then 
   username = "@"..check_markdown(msg.reply.username) 
    else 
   username = escape_markdown(msg.reply.print_name) 
    end 
   if not already_admin(tonumber(msg.reply.id)) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم تنزيلــﮭه من الاداره` 💡🌐" 
    else 
   local nameid = index_function(tonumber(msg.reply.id)) 
      table.remove(_config.admins, nameid) 
      save_config() 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم تنزيلــﮭه من الاداره` 💡🌐" 
      end 
     elseif matches[2] and matches[2]:match('^%d+') then 
  if not getUser(matches[2]).result then 
   return "┋`العضو غير متوفر` " 
    end 
     local user_name = '@'..check_markdown(getUser(matches[2]).information.username) 
     if not user_name then 
      user_name = escape_markdown(getUser(matches[2]).information.first_name) 
     end 
   if not already_admin(tonumber(matches[2])) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم تنزيلــﮭه من الاداره` 💡🌐" 
    else 
   local nameid = index_function(tonumber(matches[2])) 
      table.remove(_config.admins, nameid) 
      save_config() 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم تنزيلــﮭه من الاداره` 💡🌐" 
      end 
   elseif matches[2] and not matches[2]:match('^%d+') then 
   if not resolve_username(matches[2]).result then 
   return "┋`العضو غير متوفر` " 
    end 
   local status = resolve_username(matches[2]) 
   if not already_admin(tonumber(status.information.id)) then 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `بالفعل تم تنزيلــﮭه من الاداره` 💡🌐" 
    else 
   local nameid = index_function(tonumber(status.information.id)) 
      table.remove(_config.admins, nameid) 
      save_config() 
    return "`👨┊ العضو` : "..username.."\n🚸┊` الايدي ` : "..msg.reply.id.."\n🖇┋ `تم تنزيلــﮭه من الاداره` 💡🌐" 
          end 
      end 
   end 
end 
  if is_sudo(msg) then 
   if matches[1]:lower() == "``" and matches[2] and matches[3] then 
      local send_file = "./"..matches[2].."/"..matches[3] 
      sendDocument(msg.to.id, send_file, msg.id, "@DEV_NOVAR") 
   end 
   if matches[1]:lower() == "``" and matches[2] then 
       local plug = "./plugins/"..matches[2]..".lua" 
      sendDocument(msg.to.id, plug, msg.id, "@DEV_NOVAR") 
    end 
   if matches[1]:lower() == "``" and matches[2]then 
   local fn = matches[2]:gsub('(.*)/', '') 
   local pt = matches[2]:gsub('/'..fn..'$', '') 
if msg.reply_to_message then 
if msg.reply_to_message.photo then 
if msg.reply_to_message.photo[3] then 
fileid = msg.reply_to_message.photo[3].file_id 
elseif msg.reply_to_message.photo[2] then 
fileid = msg.reply_to_message.photo[2].file_id 
   else 
fileid = msg.reply_to_message.photo[1].file_id 
  end 
elseif msg.reply_to_message.sticker then 
fileid = msg.reply_to_message.sticker.file_id 
elseif msg.reply_to_message.voice then 
fileid = msg.reply_to_message.voice.file_id 
elseif msg.reply_to_message.video then 
fileid = msg.reply_to_message.video.file_id 
elseif msg.reply_to_message.document then 
fileid = msg.reply_to_message.document.file_id 
end 
downloadFile(fileid, "./"..pt.."/"..fn) 
return "*File* `"..fn.."` _has been saved in_ *"..pt.."*" 
  end 
end 
   if matches[1]:lower() == "``" and matches[2] then 
if msg.reply_to_message then 
if msg.reply_to_message.document then 
fileid = msg.reply_to_message.document.file_id 
filename = msg.reply_to_message.document.file_name 
if tostring(filename):match(".lua") then 
downloadFile(fileid, "./plugins/"..matches[2]..".lua") 
return "*Plugin* `"..matches[2]..".lua` _has been saved_" 
        end 
     end 
  end 
end 
if matches[1] == 'الاداريين' and is_admin(msg) then 
return adminlist(msg) 
    end 
if matches[1] == 'المجموعات' and is_admin(msg) then 
return chat_list(msg) 
    end 
      if matches[1] == 'تعطيل' and matches[2] and is_admin(msg) then 
    local data = load_data(_config.moderation.data) 
         -- Group configuration removal 
         data[tostring(matches[2])] = nil 
         save_data(_config.moderation.data, data) 
         local groups = 'groups' 
         if not data[tostring(groups)] then 
            data[tostring(groups)] = nil 
            save_data(_config.moderation.data, data) 
         end 
         data[tostring(groups)][tostring(matches[2])] = nil 
         save_data(_config.moderation.data, data) 
      send_msg(matches[2], "`تم تعطيل هذه المجموعــﮭه` \n`عن طريق الايدي المجموعــﮭه` 💡🌐", nil, 'md') 
    return ' `المجموعــﮭه` '..matches[2]..'*\n`تم تعطيل المجموعــﮭه`💡🌐' 
      end 
     if matches[1] == 'مغادره' and is_admin(msg) then 
  leave_group(msg.to.id) 
   end 
     if matches[1] == 'ارسل الى' and is_admin(msg) and matches[2] and matches[3] then 
      local text = matches[2] 
send_msg(matches[3], text)   end 
 end 
   if matches[1] == 'اذاعه' and is_sudo(msg) then 
  local data = load_data(_config.moderation.data) 
  local bc = matches[2] 
  for k,v in pairs(data) do 
send_msg(k, bc) 
  end 
end 
     if matches[1] == 'المغادره تلقائيا' and is_admin(msg) then 
local hash = 'المغادره تلقائيا' 
--Enable Auto Leave 
     if matches[2] == 'تفعيل' then 
    redis:del(hash) 
   return ' `تم تفعيل المغادره تلقائي` 🎐' 
--Disable Auto Leave 
     elseif matches[2] == 'تعطيل' then 
    redis:set(hash, true) 
   return ' `تم تعطيل المغادره تلقائيا` 🎐' 
--Auto Leave Status 
      elseif matches[2] == 'مغادرة البوت' then 
      if not redis:get(hash) then 
   return '``' 
       else 
   return '``' 
         end 
      end 
   end 
------------------------------ 
end 
return { 
  patterns = { 
    "^(رفع مطور)$", 
    "^(تنزيل مطور)$", 
    "^(رفع مطور) (.*)$", 
    "^(تنزيل مطور) (.*)$", 
    "^(المطورين)$", 
    "^(رفع اداري)$", 
    "^(تنزيل اداري)$", 
    "^(رفع اداري) (.*)$", 
    "^(تنزيل اداري) (.*)$", 
    "^(الاداريين)$", 
    "^(المجموعات)$", 
    "^(ارسل الى) (.*) (-%d+)$", 
    "^(اذاعه) (.*)$", 
    "^(مغادره)$", 
    "^(المغادره تلقائيا) (.*)$", 
    "^(تعطيل) (-%d+)$", 
    }, 
  run = run, 
  pre_process = pre_process 
} 
