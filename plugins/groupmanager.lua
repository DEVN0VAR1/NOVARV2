
local function modadd(msg)
    -- تريد تخمط تع كلي حخمط لان نشك طيزي واتعلم ولا تخمط
    if not is_admin(msg) then
        return '`📮┋انـــت لســـت ادمـــن ⚠`'
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
   return '`📮┋ الــمجموعــه تـــم تفعيـــلها بالفعــل 💬`'
end
local status = getChatAdministrators(msg.to.id).result
for k,v in pairs(status) do
if v.status == "creator" then
if v.user.username then
creator_id = v.user.id
user_name = '@'..check_markdown(v.user.username)
else
user_name = check_markdown(v.user.first_name)
end
end
end
        -- create data array in moderation.json
      data[tostring(msg.to.id)] = {
              owners = {[tostring(creator_id)] = user_name},
      mods ={},
      banned ={},
      is_silent_users ={},
      filterlist ={},
      settings = {
          set_name = msg.to.title,
          lock_link = 'yes',
          lock_tag = 'yes',
          lock_spam = 'yes',
          lock_edit = 'no',
          lock_mention = 'no',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes',
          lock_pin = 'no',
          welcome = 'no',
		  lock_join = 'no',
		  lock_arabic = 'no',
		  num_msg_max = '5',
		  set_char = '40',
		  time_check = '2',
          },
   mutes = {
                  mute_forward = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photo = 'no',
                  mute_gif = 'no',
                  mute_location = 'no',
                  mute_document = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                   mute_all = 'no',
				   mute_tgservice = 'no',
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
  return '`📇￤الــمجمــوعــه`\n`🚸￤{ '..msg.to.title..'}`\n`💭￤تــم تفــعيل الــمجموعــه`\n`🔹~~ ~~ ~~ ~~ ~~🔹`\n`📌┊بواسطه :` @'..msg.from.username..'\n`👁‍🗨┊ايـــدي :` '..msg.from.id
end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        return '`📮┋انـــت لســـت ادمـــن ⚠`'
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
    return '`📮┋ الــمجموعــه لـم يتـــم تفعيـــلها`'
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
  return '`📮┋ الـــمجموعـــه تــم تـعطيلــها`'
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return '`📮┋ الـــمجموعـــه تــم تـعطيلــها بالفـــعل`'
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
    return '`⚠┋لا يــوجــد مـدراء هنـــا`'
end
   message = '\n `💳￤المـــدراء`\n`🔱➖➖➖🔱➖➖➖🔱`\n\n'
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return '`📮┋ الـــمجموعـــه تــم تـعطيلــها بالفـــعل`'
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
    return "`⚠┋لا يــوجــد ادمنيـــه هنـــا`"
end
   message = '\n `📇￤الادمنـــيه`\n\n`🔗-----🔗-----🔗`\n\n'
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function filter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][(word)] then
         return  "`🚸┋الـــكلمـه`{ "..word.." }\n`🔇┋تــم منـعهـا`"
      end
    data[tostring(msg.to.id)]['filterlist'][(word)] = true
    save_data(_config.moderation.data, data)
       return  "`🚸┋الـــكلمـه`{ "..word.." }\n`🔕┋ بــالفعــل تـم منعـــها`"
    end

local function unfilter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
      save_data(_config.moderation.data, data)
        return  "`🚸┋الـــكلمـه`{ "..word.." }\n`🔊┋تــم الغــاء منعــها`"
    else
      return  "`🚸┋الـــكلمـه`{ "..word.." }\n`🔔┋ بــالفعــل تـم الغــاء منعــها`"
    end
  end
  
----------قفل الروابط-----------
local function lock_link(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــروابـــط `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_link"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــروابـــط `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_link(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــروابـــط `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــروابـــط `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل التاكات------------------- 
local function lock_tag(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــتـــاك `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_tag"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــتـــاك `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_tag(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــتـــاك `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــتـــاك `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------Lock Mention------------------- 
local function lock_mention(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــتذكير `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_mention"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــتذكير `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_mention(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــتذكير `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــتذكير `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل العربيه-------------- 
local function lock_arabic(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـعربيـــــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_arabic"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـعربيـــــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_arabic(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـعربيـــــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـعربيـــــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل التعديل------------------- 
local function lock_edit(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل التـــعديـــل`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_edit"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل التـــعديـــل`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_edit(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح التـــعديـــل`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح التـــعديـــل`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل الكلايش------------------- 
local function lock_spam(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــكلايـــش`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_spam"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــكلايـــش`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_spam(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــكلايـــش`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــكلايـــش`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل التكرار------------------- 
local function lock_flood(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_flood = data[tostring(target)]["settings"]["lock_flood"] 
if lock_flood == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــتكـــرار `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_flood"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــتكـــرار `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_flood(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_flood = data[tostring(target)]["settings"]["lock_flood"] 
if lock_flood == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــتكـــرار `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_flood"] = "no" save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــتكـــرار `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل البوتات------------------- 
local function lock_bots(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الــبوتـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_bots"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الــبوتـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_bots(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الــبوتـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الــبوتـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل الدخول------------------- 
local function lock_join(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـدخول`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_join"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــدخول`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_join(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـدخول `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_join"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــدخول`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل الماركداون------------------- 
local function lock_markdown(msg, data, target) 
if not is_mod(msg) then 
return "`??┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـماركـــــدون`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_markdown"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـماركـــــدون`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_markdown(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـماركـــــدون`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـماركـــــدون`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل الصفحات------------------- 
local function lock_webpage(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــصفحات`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_webpage"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـصفحات`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_webpage(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــصفحات`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــصفحات`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل التثبيتات------------------- 
local function lock_pin(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل التـــثبـيـــت`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_pin"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل التـــثبـيـــت`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unlock_pin(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح التـــثبـيـــت`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["settings"]["lock_pin"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح التـــثبـيـــت`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

function group_settings(msg, target) 	
if not is_mod(msg) then
 	return "`📮┋انـــت لســـت ادمـــن ⚠`"
end
local data = load_data(_config.moderation.data)
local settings = data[tostring(target)]["settings"] 
text = "*🔓 تعني مفتوح \n🔒 تعني مقفول :*\n\n_التعديل 🚩:_ *"..settings.lock_edit.."*\n_الروابط 🚩:_ *"..settings.lock_link.."*\n_التاك 🚩 :_ *"..settings.lock_tag.."*\n_الدخول 🚩:_ *"..settings.lock_join.."*\n_التكرار 🚩:_ *"..settings.flood.."*\n_الكلايش 🚩 :_ *"..settings.lock_spam.."*\n_المنشن 🚩:_ *"..settings.lock_mention.."*\n_العربيه 🚩 :_ *"..settings.lock_arabic.."*\n_الصفحات 🚩 :_ *"..settings.lock_webpage.."*\n_الماركدون 🚩 :_ *"..settings.lock_markdown.."*\n_الترحيب 🚩:_ *"..settings.welcome.."*\n_التثبيت 🚩:_ *"..settings.lock_pin.."*\n_البوتات 🚩 :_ *"..settings.lock_bots.."*\n_عدد التكرار🚩:_ *"..settings.num_msg_max.."*\n_عدد الاحرف 🚩:_ *"..settings.set_char.."*\nزمن التكرار 🚩 :_ *"..settings.time_check.."*\n*🌟🌟🌟🌟*\n*C H B O T*: @DEV_NOVAR"
text = string.gsub(text, 'yes', '🔒')
text = string.gsub(text, 'no', '🔓')
text = string.gsub(text, '0', '0')
text = string.gsub(text, '1', '1')
text = string.gsub(text, '2', '2️')
text = string.gsub(text, '3', '3️')
text = string.gsub(text, '4', '4️')
text = string.gsub(text, '5', '5️')
text = string.gsub(text, '6', '6️')
text = string.gsub(text, '7', '7️')
text = string.gsub(text, '8', '8️')
text = string.gsub(text, '9', '9️')
return text
end

--------قفل الكل -----------
local function mute_all(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــكـــل`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــكـــل`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_all(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــكـــل`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_all"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــكـــل`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

---------------قفل المتحركه------------------- 
local function mute_gif(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل المـــتحركـــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل المـــتحركـــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_gif(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح المـــتحركـــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح المـــتحركـــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل الدردشه------------------- 
local function mute_text(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــدردشـــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــدردشـــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_text(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــدردشـــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`??￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_text"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــدردشـــه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل الصور------------------- 
local function mute_photo(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــصـــور`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــصـــور`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_photo(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــصـــور`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــصـــور`\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل الفيديو------------------- 
local function mute_video(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الفـــيديـــو `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الفـــيديـــو `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_video(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الفـــيديـــو `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_video"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الفـــيديـــو `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل الصوت------------------- 
local function mute_audio(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الصـــوت `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الصـــوت `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_audio(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الصـــوت `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الصـــوت `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل الاغاني------------------- 
local function mute_voice(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الاغـــانـــي `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الاغـــانـــي `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_voice(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الاغـــانـــي `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الاغـــانـــي `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل الملصقات------------------- 
local function mute_sticker(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــملصـــقـات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــملصـــقـات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_sticker(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــملصـــقـات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــملصـــقـات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل الجهات------------------- 
local function mute_contact(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــجهـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــجهـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_contact(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــجهـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــجهـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل التوجيه ------------------- 
local function mute_forward(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــتوجـــيه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الـــتوجـــيه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end
end 

local function unmute_forward(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـــتوجـــيه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـــتوجـــيه `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل المواقع------------------- 
local function mute_location(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الـــمواقع `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل المواقع `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_location(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الـمواقع `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_location"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الـمواقع `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل الملفات------------------- 
local function mute_document(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل المـــلفـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل المـــلفـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_document(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح المـــلفـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_document"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح المـــلفـــات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
---------------قفل الاشعارات------------------- 
local function mute_tgservice(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then 
return "`👁‍🗨￤بـالفـعـل تــم قفــــل الاشـــعارات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
return "`👁‍🗨￤تــــــم قفـــــــل الاشـــعارات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 

local function unmute_tgservice(msg, data, target) 
if not is_mod(msg) then 
return "`📮┋انـــت لســـت ادمـــن ⚠`"
end 
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "no" then 
return "`📮￤بـالفـعـل تـــم فتـــح الاشـــعارات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no" 
save_data(_config.moderation.data, data) 
return "`📮￤تــــــم فتـــح الاشـــعارات `\n\n`🚸----- ᶰᵉᵏᵒˡ ------ 🚸`\n`⚠️￤بواســطة ::` @"..msg.from.username.."\n`🌀￤ايـــدي ::` "..msg.from.id
end 
end 
----------اعدادات المجموعه---------
local function mutes(msg, target) 	
if not is_mod(msg) then
 	return "`📮┋انـــت لســـت ادمـــن ⚠`"
end
local data = load_data(_config.moderation.data)
local mutes = data[tostring(target)]["mutes"] 
 text = "*\n الكل 🌟"..mutes.mute_all.."*\nالمتحركه 🎃:_ *"..mutes.mute_gif.."*\nالدردشه 💭:_ *"..mutes.mute_text.."*\nالصور 📛:_ *"..mutes.mute_photo.."*\nالفيديو 👁‍🗨:_ *"..mutes.mute_video.."*\n_الصوت 🌞 :_ *"..mutes.mute_audio.."*\n_الاغاني ☑ :_ *"..mutes.mute_voice.."*\n_الملسقات 🐰 :_ *"..mutes.mute_sticker.."*\n_الجهات 📱 :_ *"..mutes.mute_contact.."*\n_التوجيه ♻ :_ *"..mutes.mute_forward.."*\n_المواقع 🌏 :_ *"..mutes.mute_location.."*\n_الملفات 📃 :_ *"..mutes.mute_document.."*\n_الاشعارات 🎶 :_ *"..mutes.mute_tgservice.."*\n*🌟🌟🌟🌟*\n*CH B O T *: @DEV_NOVAR"
text = string.gsub(text, 'yes', 'مقفول')
text = string.gsub(text, 'no', 'مفتوح')
 return text
end

local function taha(msg, matches)
local data = load_data(_config.moderation.data)
local target = msg.to.id
----------------التفعيلات--------------
if matches[1] == "تفعيل" and is_sudo(msg) then
return modadd(msg)
   end
if matches[1] == "تعطيل" and is_sudo(msg) then
return modrem(msg)
   end
if matches[1] == "الادمنيه" and is_mod(msg) then
return ownerlist(msg)
   end
if matches[1] == "قائمه المنع" and is_mod(msg) then
return filter_list(msg)
   end
if matches[1] == "المدراء" and is_mod(msg) then
return modlist(msg)
   end
if matches[1] == "قائمه المميزين" and is_mod(msg) then
return whitelist(msg.to.id)
   end
if matches[1] == "معلومات" and matches[2] and (matches[2]:match('^%d+') or matches[2]:match('-%d+')) and is_mod(msg) then
		local usr_name, fst_name, lst_name, biotxt = '', '', '', ''
		local user = getUser(matches[2])
		if not user.result then
			return "`⚠￤الــمستــخدم لا يـــوجـــد`"
		end
		user = user.information
		if user.username then
			usr_name = '@'..check_markdown(user.username)
		else
			usr_name = '---'

		end
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		if user.firstname then
			fst_name = escape_markdown(user.firstname)
		else
			fst_name = '---'
		end
		if user.bio then
			biotxt = escape_markdown(user.bio)
		else
			biotxt = '---'
		end
		local text = 'المعرف ✏: '..usr_name..' \nالاسم الاول 📝: '..fst_name..' \nالاسم الثاني 💭: '..lst_name..' \nمعلوماتك: '..biotxt
		return text
end
if matches[1] == "استجواب" and matches[2] and not matches[2]:match('^%d+') and is_mod(msg) then
		local usr_name, fst_name, lst_name, biotxt, UID = '', '', '', '', ''
		local user = resolve_username(matches[2])
		if not user.result then
			return "`⚠￤الــمستــخدم لا يـــوجـــد`"
		end
		user = user.information
		if user.username then
			usr_name = '@'..check_markdown(user.username)
		else
			usr_name = "`⚠￤الــمستــخدم لا يـــوجـــد`"
			return usr_name
		end
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		if user.firstname then
			fst_name = escape_markdown(user.firstname)
		else
			fst_name = '---'
		end
		if user.id then
			UID = user.id
		else
			UID = '---'
		end
		if user.bio then
			biotxt = escape_markdown(user.bio)
		else
			biotxt = '---'
		end
		local text = 'Username: '..usr_name..' \nUser ID: '..UID..'\nFirstName: '..fst_name..' \nLastName: '..lst_name..' \nBio: '..biotxt
		return text
end
if matches[1] == '  ' then
return _config.info_text
end
if matches[1] == "ايدي" then
   if not matches[2] and not msg.reply_to_message then
local status = getUserProfilePhotos(msg.from.id, 0, 0)
 local rank
if is_sudo(msg) then
rank = 'الـــمطـور 📮'
elseif is_owner(msg) then
rank = 'الـــمديــر 💎'
elseif is_mod(msg) then
rank = 'الادمـــن 💠'
else
rank = 'الـــعضـو 👤'
end
if msg.from.username then
userxn = "@"..(msg.from.username or "---")
else
userxn = "لا يتوفر"
end
local msgs = tonumber(redis:get('msgs:'..msg.from.id..':'..msg.to.id) or 0)
if status.result.total_count ~= 0 then
	sendPhotoById(msg.to.id, status.result.photos[1][1].file_id, msg.id,'👁‍🗨┊ ايديك  : '..msg.from.id..'\n⚜┊ موقعك : '..rank.."\n🚸┊ معرفك : @"..(msg.from.username or "")..'\n??┊ اسمك  : '..msg.from.first_name)
	else
   return "📫┊ ليس لديك صوره لحسابك \n `📇┊المجموعه`"..tostring(msg.to.id).."`\n`👁‍🗨┊ ايديك  :` "..tostring(msg.from.id).."`"
   end
   elseif msg.reply_to_message and not msg.reply.fwd_from and is_mod(msg) then
     return "`"..msg.reply.id.."`"
   elseif not string.match(matches[2], '^%d+$') and matches[2] ~= "from" and is_mod(msg) then
    local status = resolve_username(matches[2])
		if not status.result then
			return 'المستخدم👤 غير موجود'
		end
     return "`"..status.information.id.."`"
   elseif matches[2] == "``" and msg.reply_to_message and msg.reply.fwd_from then
     return "`"..msg.reply.fwd_from.id.."`"
   end
end
if matches[1] == "تثبيت" and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "`🗯┊تـــم تثبـــيت الرســـالــه`"
elseif not is_owner(msg) then
   return "`📮┋انـــت لســـت ادمـــن ⚠`"
 end
 elseif lock_pin == 'no' then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "`🗯┊تـــم تثبـــيت الرســـالــه`"
end
end
if matches[1] == 'الغاء التثبيت' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
unpinChatMessage(msg.to.id)
return "`🗯┊تـــم الغـــاء تثبـــيت الرســـالــه`"
elseif not is_owner(msg) then
   return "`📮┋انـــت لســـت ادمـــن ⚠`"
 end
 elseif lock_pin == 'no' then
unpinChatMessage(msg.to.id)
return "`🗯┊تـــم الغـــاء تثبـــيت الرســـالــه`"
end
end

if matches[1] == 'الحمايه' then
return group_settings(msg, target)
end
if matches[1] == "رفع مدير" and is_owner(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "`📮￤آلـــعضو :` "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."\n`♦️￤تـمت ترقيـتـه مـديـر مـسـبقـا`"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :` "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."\n`♦️￤تــم ترقيـتـه مـديـر الـكـروب`"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "`📮￤آلـــعضو :` "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."\n`♦️￤تـمت ترقيـتـه مـديـر مـسـبقـا`"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :` "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."\n`♦️￤تــم ترقيـتـه مـديـر الـكـروب`"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['mods'][tostring(user_id)] then
    return "`📮￤آلـــعضو :` "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."\n`♦️￤تـمت ترقيـتـه مـديـر مـسـبقـا`"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :` "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."\n`♦️￤تــم ترقيـتـه مـديـر الـكـروب`"
   end
end
end
   if matches[1] == "تنزيل مدير" and is_owner(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "`📮￤آلـــعضو :` "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."\n`♦️￤بـالفـعـل تـم تـنزيـلـه مـن الاداره`"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :` "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."\n`♦️￤تــم تـنـزيلـه مـن الاداره`"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."\n`♦️￤بـالفـعـل تـم تـنزيـلـه مـن الاداره`"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."\n`♦️￤تــم تـنـزيلـه مـن الاداره `"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['mods'][tostring(status.id)] then
    return "`📮￤آلـــعضو :`  "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."\n`♦️￤بـالفـعـل تـم تـنزيـلـه مـن الاداره`"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."\n`♦️￤تــم تـنـزيلـه مـن الاداره` "
      end
end
end
if matches[1] == "رفع ادمن" and is_owner(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "`📮￤آلـــعضو :`  "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."\n`♦️￤تـمت ترقيـتـه ادمــن مـسـبقـا`"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."\n`♦️￤تــم ترقيـتـه ادمـن`"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."\n`♦️￤تـمت ترقيـتـه ادمــن مـسـبقـا`"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."\n`♦️￤تــم ترقيـتـه ادمـن`"
   end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['mods'][tostring(user_id)] then
    return "`📮￤آلـــعضو :` "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."`\n`♦️￤تـمت ترقيـتـه ادمــن مـسـبقـا`"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :` "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."\n`♦️￤تــم ترقيـتـه ادمـن`"
   end
end
end
if matches[1] == "تنزيل ادمن" and is_owner(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "`📮￤آلـــعضو :`  "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."\n`♦️￤بـالفـعـل تـم تـنزيـلـه مـن ادمنيـه`"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."\n`♦️￤تــم تـنـزيلـه مـن الادمـنيـه`"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."\n`♦️￤بـالفـعـل تـم تـنزيـلـه مـن ادمنيـه`"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."\n`♦️￤تــم تـنـزيلـه مـن الادمـنيـه`"
      end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['mods'][tostring(status.id)] then
    return "`📮￤آلـــعضو :` "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."\n`♦️￤بـالفـعـل تـم تـنزيـلـه مـن ادمنيـه`"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :` "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."\n`♦️￤تــم تـنـزيلـه مـن الادمـنيـه`"
      end
end
end
if matches[1] == "رفع عضو مميز"  and is_mod(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "`📮￤آلـــعضو :`  "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."``"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."``"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['whitelist'][tostring(matches[2])] then
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."`"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."``"
   end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "`📮￤آلـــعضو :` "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."\n``"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :` "..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."``"
   end
end
end
if matches[1] == "تنزيل عضو مميز" and is_mod(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "`📮￤آلـــعضو :`  "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."``"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..username.."\n`👁‍🗨￤الايـــدي :`"..msg.reply.id.."``"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['whitelist'][tostring(matches[2])] then
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."``"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  "..user_name.."\n`👁‍🗨￤الايـــدي :`"..matches[2].."``"
      end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "`⚠￤الــمستــخدم لا يـــوجـــد`"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "`📮￤آلـــعضو :`  @"..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."``"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "`📮￤آلـــعضو :`  @"..check_markdown(status.username).."\n`👁‍🗨￤الايـــدي :`"..status.id.."``"
      end
end
end
if matches[1]:lower() == "قفل" and is_mod(msg) then
if matches[2] == "الروابط" then
return lock_link(msg, data, target)
end
if matches[2] == "التاك" then
return lock_tag(msg, data, target)
end
if matches[2] == "المنشن" then
return lock_mention(msg, data, target)
end
if matches[2] == "العربيه" then
return lock_arabic(msg, data, target)
end
if matches[2] == "التعديل" then
return lock_edit(msg, data, target)
end
if matches[2] == "الكلايش" then
return lock_spam(msg, data, target)
end
if matches[2] == "التكرار" then
return lock_flood(msg, data, target)
end
if matches[2] == "البوتات" then
return lock_bots(msg, data, target)
end
if matches[2] == "الماركداون" then
return lock_markdown(msg, data, target)
end
if matches[2] == "الصفحات" then
return lock_webpage(msg, data, target)
end
if matches[2] == "التثبيت" and is_owner(msg) then
return lock_pin(msg, data, target)
end
if matches[2] == "الدخول" then
return lock_join(msg, data, target)
end
end
if matches[1]:lower() == "فتح" and is_mod(msg) then
if matches[2] == "الروابط" then
return unlock_link(msg, data, target)
end
if matches[2] == "التاك" then
return unlock_tag(msg, data, target)
end
if matches[2] == "المنشن" then
return unlock_mention(msg, data, target)
end
if matches[2] == "العربيه" then
return unlock_arabic(msg, data, target)
end
if matches[2] == "التعديل" then
return unlock_edit(msg, data, target)
end
if matches[2] == "الكلايش" then
return unlock_spam(msg, data, target)
end
if matches[2] == "التكرار" then
return unlock_flood(msg, data, target)
end
if matches[2] == "البوتات" then
return unlock_bots(msg, data, target)
end
if matches[2] == "الماركداون" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "الصفحات" then
return unlock_webpage(msg, data, target)
end
if matches[2] == "التثبيت" and is_owner(msg) then
return unlock_pin(msg, data, target)
end
if matches[2] == "الدخول" then
return unlock_join(msg, data, target)
end
end
if matches[1]:lower() == "قفل" and is_mod(msg) then
if matches[2] == "المتحركه" then
return mute_gif(msg, data, target)
end
if matches[2] == "الدردشه" then
return mute_text(msg ,data, target)
end
if matches[2] == "الصور" then
return mute_photo(msg ,data, target)
end
if matches[2] == "الفيديو" then
return mute_video(msg ,data, target)
end
if matches[2] == "الصوت" then
return mute_audio(msg ,data, target)
end
if matches[2] == "الاغاني" then
return mute_voice(msg ,data, target)
end
if matches[2] == "الملصقات" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "الجهات" then
return mute_contact(msg ,data, target)
end
if matches[2] == "التوجيه" then
return mute_forward(msg ,data, target)
end
if matches[2] == "المواقع" then
return mute_location(msg ,data, target)
end
if matches[2] == "الملفات" then
return mute_document(msg ,data, target)
end
if matches[2] == "الاشعارات" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == 'الكل' then
return mute_all(msg ,data, target)
end
end
if matches[1]:lower() == "فتح" and is_mod(msg) then
if matches[2] == "المتحركه" then
return unmute_gif(msg, data, target)
end
if matches[2] == "الدردشه" then
return unmute_text(msg, data, target)
end
if matches[2] == "الصور" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "الفيديو" then
return unmute_video(msg ,data, target)
end
if matches[2] == "الصوت" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "الاغاني" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "الملصقات" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "الجهات" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "التوجيه" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "المواقع" then
return unmute_location(msg ,data, target)
end
if matches[2] == "الملفات" then
return unmute_document(msg ,data, target)
end
if matches[2] == "الاشعارات" then
return unmute_tgservice(msg ,data, target)
end
 if matches[2] == 'الكل' then
return unmute_all(msg ,data, target)
end
end
  if matches[1] == 'منع' and matches[2] and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'الغاء منع' and matches[2] and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
  if matches[1] == 'تغير الرابط' and is_mod(msg) then
  local administration = load_data(_config.moderation.data)
  local link = exportChatInviteLink(msg.to.id)
	if not link then
		return "`📮┊ رجـــا ارســـل الرابـــط الان `"
	else
		administration[tostring(msg.to.id)]['settings']['linkgp'] = link.result
		save_data(_config.moderation.data, administration)
		return "`📮┊تــم تغيــر رابـــط المجموعــه`"
	end
   end
		if matches[1] == 'ضع رابط' and is_owner(msg) then
		data[tostring(target)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
			return "`📮┊ رجـــائا ارســـل الرابـــط الان `"
	   end
		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(target)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(target)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
				return "`📮┊تــم تغيــر رابـــط المجموعــه`"
       end
		end
    if matches[1] == 'الرابط' and is_mod(msg) then
      local linkgp = data[tostring(target)]['settings']['linkgp']
      if not linkgp then
        return "`📮┊ قــم بارسـال { ضع رابط } ليتــم وضع الرابــط`"
      end
       text = "\n `📮┊ رابط المجموعه`\n `⚜ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~⚜` \n { "..linkgp.." }"
        return text
     end
  if matches[1] == "ضع قوانين" and matches[2] and is_mod(msg) then
    data[tostring(target)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
    return "`تم حفض القوانين ┊📮`"
  end
  if matches[1] == "القوانين" then
 if not data[tostring(target)]['rules'] then
     rules = "`📮┊ واللــه انتــو مو جهـــال`\n تابع : @DEA_NOVAR"
        else
     rules = "\n `📮┊قوانين المجموعه "..data[tostring(target)]['rules']
      end
    return rules
  end
		if matches[1]:lower() == 'setchar' then
			if not is_mod(msg) then
				return
			end
			local chars_max = matches[2]
			data[tostring(msg.to.id)]['settings']['set_char'] = chars_max
			save_data(_config.moderation.data, data)
     return "*Character sensitivity* _has been set to :_ *[ "..matches[2].." ]*"
  end
  if matches[1]:lower() == 'ضع تكرار' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "`📮┊ تــستطيــع وضــع عـــدد التكـــرار مـن ` *|[-1 الـى 50-]|*"
      end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "`📮┊تم وضـع عــدد التكـرار` \n`📇┊العدد ::` *{ "..matches[2].." }*"
       end
  if matches[1]:lower() == 'زمن التكرار' and is_mod(msg) then
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 10 then
				return "`📮┊ تستطــيع وضـع زمن تكــرار لرقم 10> فقـــط`"
      end
			local time_max = matches[2]
			data[tostring(msg.to.id)]['settings']['time_check'] = time_max
			save_data(_config.moderation.data, data)
    return "_Group_ *flood* _check time has been set to :_ *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'مسح' and is_owner(msg) then
			if matches[2] == 'المدراء' then
				if next(data[tostring(msg.to.id)]['mods']) == nil then
					return "`📮┊ لا يوجـــد مــدراء في المجموعــه`"
            end
				for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
					data[tostring(msg.to.id)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "`📮┊ تــم مســـح الــمدراء"
         end
			if matches[2] == 'قائمه المنع' then
				if next(data[tostring(msg.to.id)]['filterlist']) == nil then
					return "`📮┊قائــمه المنــع فارغــه`"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['filterlist']) do
					data[tostring(msg.to.id)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "`📮┊تــم مســح قائـمه المنـع`"
			end
			if matches[2] == 'القوانين' then
				if not data[tostring(msg.to.id)]['rules'] then
					return "`📮┊لا يوجــد قوانـين في المجموعــه`"
				end
					data[tostring(msg.to.id)]['rules'] = nil
					save_data(_config.moderation.data, data)
				return "`📮┊تــم مسـح القــوانيـن`"
       end
			if matches[2] == 'الترحيب' then
				if not data[tostring(msg.to.id)]['setwelcome'] then
					return "`📮┊ لا يوجـــد ترحـــيب في المجموعــه`"
				end
					data[tostring(msg.to.id)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
				return "`📮┊ تــم مســح الترحـــيب`"
       end
			if matches[2] == 'الوصف' then
        if msg.to.type == "group" then
				if not data[tostring(msg.to.id)]['about'] then
					return "`📮┊ لا يوجـد وصــف فــي المجموعـــه`"
				end
					data[tostring(msg.to.id)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, "")
             end
				return "`📮┊تــم مسـح الوصـف`"
		   	end
        end
		if matches[1]:lower() == 'مسح' and is_admin(msg) then
			if matches[2] == 'الادمنيه' then
				if next(data[tostring(msg.to.id)]['owners']) == nil then
					return "`📮┊لا يوجــد ادمنــيه ليتــم مسحهــم`"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
					data[tostring(msg.to.id)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "`📮┊ تـم مســح جميــع الادمنـيه`"
			end
     end
if matches[1] == "ضع اسم" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
setChatTitle(msg.to.id, gp_name)
end
if matches[1] == 'ضع صوره' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
     if not msg.caption and not msg.reply_to_message then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '`📮┊رجــائا ارسـل الصـوره الان`'
     elseif not msg.caption and msg.reply_to_message then
if msg.reply_to_message.photo then
if msg.reply_to_message.photo[3] then
fileid = msg.reply_to_message.photo[3].file_id
elseif msg.reply_to_message.photo[2] then
fileid = msg.reply_to_message.photo[2].file_id
   else
fileid = msg.reply_to_message.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "`📮┊تــم حفــظ الصـوره`"
     elseif msg.caption and not msg.reply_to_message then
if msg.photo then
if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "`📮┊تــم حفــظ الصـوره`"
		end
  end
if matches[1] == "حذف الصوره" and is_mod(msg) then
deleteChatPhoto(msg.to.id)
  return "`📮┊ تــم حــذف الصـوره `"
end
  if matches[1] == "ضع وصف" and matches[2] and is_mod(msg) then
     if msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, matches[2])
    elseif msg.to.type == "group" then
    data[tostring(msg.to.id)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
    return "`📮┊ تم وضع وصف للمجموعه ⚪`"
  end
  if matches[1] == "الوصف" and msg.to.type == "group" then
 if not data[tostring(msg.to.id)]['about'] then
     about = "`📮┊ لا يوجد وصف في المجموعه`"
        else
     about = "\n `📮┊ وصف المجموعه 📝`\n`💎 • • • • • • • 💎`\n\n"..data[tostring(chat)]['about']
      end
    return about
  end
if matches[1] == "حذف" and is_mod(msg) then
del_msg(msg.to.id, msg.reply_id)
del_msg(msg.to.id, msg.id)
   end
if matches[1] == "رفع الكل" and is_owner(msg) then
local status = getChatAdministrators(msg.to.id).result
for k,v in pairs(status) do
if v.status == "administrator" then
if v.user.username then
admins_id = v.user.id
user_name = '@'..check_markdown(v.user.username)
else
user_name = escape_markdown(v.user.first_name)
      end
  data[tostring(msg.to.id)]['mods'][tostring(admins_id)] = user_name
    save_data(_config.moderation.data, data)
    end
  end
    return "`📮┊ تم ترقيتهم ادمنيه في البوت \n`⚪ • • • • • • • •⚪`\n`📍￤بواســطة ::` @"..msg.from.username.."\n`🔖￤ايـــدي ::` "..msg.from.id
end
if matches[1] == 'تنظيف' and matches[2] and is_owner(msg) then
local num = matches[2]
if 100 < tonumber(num) then
return "`📮┊تستطيع مسح 100> رساله فقط \n\n`⚪ • • • • • • • •⚪`\n`📍￤بواســطة ::` @"..msg.from.username.."\n`🔖￤ايـــدي ::` "..msg.from.id
end
print(num)
for i=1,tonumber(num) do
del_msg(msg.to.id,msg.id - i)
end
end
--------------------- الترحيب-----------------------
if matches[1] == "الترحيب" and is_mod(msg) then
		if matches[2] == "تفعيل" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "yes" then
				return "`📮┊بالفعل تم تفعيل الترحيب`"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				return "`📮┊تم تفعيل الترحيب`"
			end
		end
		
		if matches[2] == "تعطيل" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "no" then
				return "`📮┊بالفعل تم تعطيل الترحيب`"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				return "`📮┊تم تعطيل الترحيب`"
			end
		end
	end
	   if matches[1] == "ضع ترحيب" and matches[2] and is_mod(msg) then
		data[tostring(msg.to.id)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
		return "`📣┊تــــم وضـــع الترحــــيب `\n`📮┊ الــــكلمه ::` {"..matches[2].."  }\n`💎 • • • • • • • 💎`\n\n`⚪┊تستطيع ايضا وضع ⏬`\n_{ gpname } \n🔹 اسم المجموعه 📇_\n_{ rules } \n🔹 اضهار القوانين📑 _\n_{ time } \n🔹  عرض الوقت ⏰ _\n_{ date } \n🔹 عرض التاريخ 📆 _\n_{ name } \n🔹 اسم الشخص👤_\n_{ username } \n🔹 معرف الشخص👤_"
	end
if matches[1] == "الترحيب"  and is_mod(msg) then
		if data[tostring(msg.to.id)]['setwelcome']  then
	    return data[tostring(msg.to.id)]['setwelcome']  
	    else
		return "📛┊نورت المجموعه عزيزي \n [💻┊اضغط هنا للدخول](https://telegram.me/DEV_NOVAR)"
	end
	end
	---------ردود------------
	if matches[1]=="نيكول" and is_sudo(msg) then 
return  "`بــعد روحــي انــت اامــرنــي 👨💙`" 
elseif matches[1]=="رابط الحذف" then 
return "يول { "..msg.from.first_name.." }\nليش تحذف خلينا متونسين \n 🔴┊هاذا رابط الحذف \n { https://my.telegram.org }"
elseif matches[1]=="طه" then 
return  "تاج راسكم هاذا مطوري 😻😹" 
elseif matches[1]=="صوفي" then 
return  "فديت ربه مطور مال اني مح 👨😻" 
elseif matches[1]=="" then 
return  " " 
else 
return  "" 
end 
if matches[1]=="me" and is_sudo(msg) then 
return "\n🖲┊اسم المجموعه :> \n"..msg.to.title.. "\n\n💳┊ايدي المجموعه :> \n\n"..msg.to.id.. "\n\n🗯┊رسائلك :> "..tonumber(redis:get('msgs:'..msg.from.id..':'..msg.to.id) or 0).. "\n\n👁‍🗨┊معرفك :> @"..(msg.from.username or "لايوجد").. "\n\n♦️┊اسمك :> "..(check_markdown(msg.from.first_name or "----")).."\n\n ⚜┊ايديك :> "..user.."\n\n 🔗| موقعك:: 》 المطور🎐"
elseif matches[1]=="me" and is_admin(msg) then 
return  "\n🖲┊اسم المجموعه :> \n"..msg.to.title.. "\n\n💳┊ايدي المجموعه :> \n\n"..msg.to.id.. "\n\n🗯┊رسائلك :> "..tonumber(redis:get('msgs:'..msg.from.id..':'..msg.to.id) or 0).. "\n\n👁‍🗨┊معرفك :> @"..(msg.from.username or "لايوجد").. "\n\n♦️┊اسمك :> "..(check_markdown(msg.from.first_name or "----")).."\n\n ⚜┊ايديك :> "..user.."_\n\n *🔗| موقعك::* 》 الاداري 📮"
elseif matches[1]=="me" and is_owner(msg) then 
return  "\n🖲┊اسم المجموعه :> \n"..msg.to.title.. "\n\n💳┊ايدي المجموعه :> \n\n"..msg.to.id.. "\n\n🗯┊رسائلك :> "..tonumber(redis:get('msgs:'..msg.from.id..':'..msg.to.id) or 0).. "\n\n👁‍🗨┊معرفك :> @"..(msg.from.username or "لايوجد").. "\n\n♦️┊اسمك :> "..(check_markdown(msg.from.first_name or "----")).."\n\n ⚜┊ايديك :> "..user.."_\n\n *🔗| موقعك::* 》 المدير 📌"
elseif matches[1]=="me" and is_mod(msg) then 
return  "\n🖲┊اسم المجموعه :> \n"..msg.to.title.. "\n\n💳┊ايدي المجموعه :> \n\n"..msg.to.id.. "\n\n🗯┊رسائلك :> "..tonumber(redis:get('msgs:'..msg.from.id..':'..msg.to.id) or 0).. "\n\n👁‍🗨┊معرفك :> @"..(msg.from.username or "لايوجد").. "\n\n♦️┊اسمك :> "..(check_markdown(msg.from.first_name or "----")).."\n\n ⚜┊ايديك :> "..user.."_\n\n *🔗| موقعك::* 》 الادمن 🔱"
elseif matches[1]=="me" then 
return  "\n🖲┊اسم المجموعه :> \n"..msg.to.title.. "\n\n💳┊ايدي المجموعه :> \n\n"..msg.to.id.. "\n\n🗯┊رسائلك :> "..tonumber(redis:get('msgs:'..msg.from.id..':'..msg.to.id) or 0).. "\n\n👁‍🗨┊معرفك :> @"..(msg.from.username or "لايوجد").. "\n\n♦️┊اسمك :> "..(check_markdown(msg.from.first_name or "----")).."\n\n ⚜┊ايديك :> "..user.."_\n\n *🔗| موقعك::* 》 عضو 👥"
end
	------------المطور---------
	 if matches[1] == "المطور" or matches[1] == "مطور" and is_mod(msg) then
    local text = [[
🕵‍♀Developers Iraq🕵‍♀
〰〰〰〰〰〰〰〰〰〰
✞┇DEV: ⲚＯＶᗩＲ*
🎌

us - @N0VAR

id - 321050917

➖➖➖➖

✞┇DEV: ﺧ̝̚ــہـڵـہـۑج̶ــہـۑےڝـٱڪ
🚩

us - @TAHAJ20

id - 373906612

~~~~~~~~~

✞┇@KM11Qbot تواصل المطورين

〰〰〰〰〰〰〰〰〰〰
    ]]
    return text
  end
-------------Help-------------
  if matches[1] == "الاصدار" or matches[1] == "السورس"  or matches[1] == "سورس" and is_mod(msg) then
    local text = [[
اصدار ســورس «نيكول» ┇✞
〰〰〰〰〰〰〰〰〰〰〰
تم انــشاء الســورس 🎌

الاربعاء/2017/30 📛

علئ ايــدي 🔨🔧

المطورين 🎐
 ↓↓

✞┇@N0VAR

✞┇@TAHAJ20


〰〰〰〰〰〰〰〰〰〰〰
   
]]
    return text
  end

----------------End Msg Matches--------------
end
local function pre_process(msg)
-- print(serpent.block(msg, {comment=false}))
local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
    if msg.photo then
  if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
     end
		send_msg(msg.to.id, "*'📮┊تم حفظ الصوره'*", msg.id, "md")
  end
	local url , res = http.request('http://api.beyond-dev.ir/time/')
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
		local data = load_data(_config.moderation.data)
 if msg.newuser then
	if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] then
		wlc = data[tostring(msg.to.id)]['settings']['welcome']
		if wlc == "yes" and tonumber(msg.newuser.id) ~= tonumber(bot.id) then
    if data[tostring(msg.to.id)]['setwelcome'] then
     welcome = data[tostring(msg.to.id)]['setwelcome']
      else
     welcome = "`📮┊اهلا وسهلا عزيزي في المجموعه 💚 `\n`➖➖📍➖➖📍➖➖`\n `C H :` @DEV_NOVAR"
     end
 if data[tostring(msg.to.id)]['rules'] then
rules = data[tostring(msg.to.id)]['rules']
else
      rules = "` قوانين المجموعه 💛:`\n`التزم بقوانين المجموعه فضلا وليس امرا 🎃💭.`\n`عدم عمل تكرار في المجموعه 👁‍🗨.`\n` لا تنشر روابك والتزم بقوانين المجموعه.`\n`ميعحبك الكروب الله وياك ممجبور.`\n` تزحف تنهان بنعال 🙈😸.`\n` احترم تحترم.`\n`Č H ::` @DEV_NOVAR"
end
if msg.newuser.username then
user_name = "@"..check_markdown(msg.newuser.username)
else
user_name = ""
end
		welcome = welcome:gsub("{rules}", rules)
		welcome = welcome:gsub("{name}", escape_markdown(msg.newuser.print_name))
		welcome = welcome:gsub("{username}", user_name)
		welcome = welcome:gsub("{time}", jdat.ENtime)
		welcome = welcome:gsub("{date}", jdat.ENdate)
		welcome = welcome:gsub("{timefa}", jdat.FAtime)
		welcome = welcome:gsub("{datefa}", jdat.FAdate)
		welcome = welcome:gsub("{gpname}", msg.to.title)
		send_msg(msg.to.id, welcome, msg.id, "md")
        end
		end
	end
 if msg.newuser then
 if msg.newuser.id == bot.id and is_admin(msg) then
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
   modadd(msg)
   send_msg(msg.to.id, '`📬┊الــمجموعــه `\n📌┊{ `'..msg.to.title..' ` }\n☑┊تــم حفظها ضــمن مجموعـات الـبوت\n`⚠ - - - - - - - - - - ⚠`\n`📮┊بواسطة :` { @'..msg.from.username..' }\n', msg.id, "md")
      end
    end
  end
end
return {
  patterns = {
 "^(me)$",
 "^(صوفي)$",
 "^(طه)$",
 "^(نيكول)$",
 "^(رابط الحذف)$",
 "^(نيكول)$",
 "^(سورس)$",
 "^(السورس)$",
 "^(الاصدار)$",
 "^(يا سورس)$",
 "^(تفعيل)$",
 "^(تعطيل)$",
 "^(رفع الكل)$",
 "^(رفع ادمن)$",
 "^(تنزيل ادمن)$",
 "^(رفع ادمن) (.*)$",
 "^(تنزيل ادمن) (.*)$",
 "^(رفع مدير)$",
 "^(تنزيل مدير)$",
 "^(رفع مدير) (.*)$",
	"^(تنزيل مدير) (.*)$",
	"^(مميز) ([+-])$",
	"^(مميز) ([+-]) (.*)$",
	"^(المميزون)$",
	"^(قفل) (.*)$",
	"^(فتح) (.*)$",
	"^(قفل) (.*)$",
	"^(فتح) (.*)$",
	"^(اعدادات)$",
	"^(الاعدادات)$",
	"^(منع) (.*)$",
	"^(الغاء منع) (.*)$",
 "^(قائمه المنع)$",
 "^(الادمنيه)$",
 "^(المدراء)$",
 "^(مسح)$",
	"^(ضع قوانين) (.*)$",
 "^(القوانين)$",
 "^(ضع رابط)$",
 "^(الرابط)$",
 "^(ضع صوره)$",
 "^(حذف الصوره)$",
 "^(ايدي)$",
 "^(ايدي) (.*)$",
	"^(هلو)$",
	"^(مسح) (.*)$",
	"^(مسح) (.*)$",
	"^(ضع اسم) (.*)$",
	"^(الترحيب) (.*)$",
	"^(ضع ترحيب) (.*)$",
	"^(تثبيت)$",
 "^(الغاء تثبيت)$",
 "^(الوصف)$",
	"^(ضع وصف) (.*)$",
 "^(عدد الاحرف) (%d+)$",
 "^(ضع تكرار) (%d+)$",
 "^(زمن التكرار) (%d+)$",
 "^(معلومات) (%d+)$",
 "^(تنظيف) (%d+)$",
	"^([https?://w]*.?telegram.me/joinchat/%S+)$",
	"^([https?://w]*.?t.me/joinchat/%S+)$"
    },
  run = taha,
  pre_process = pre_process
}
