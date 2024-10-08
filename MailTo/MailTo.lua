--[[ MailTo Again: Mailbox management system,
    Written by LStranger (Copyright (C) 2015)

    version history:
    1.8.0	Dropped OpenBackpack() supression, original functionality is good since 5.0 patch.
        	Updated TOC to WoW 6.2.
--]]

--[[ MailTo Next: Mailbox management system,
    Written by Jyin of Silverhand, (copyright (c) 2005-2007)
    
    version history:
    1.7.0	Re-worked the soul-bind item scan for extra window.
    		Dropped support for keychain
    1.6.9	Added back in the ability to loot all items from mail (alt key)
    		Thank you Immoliate for pointing out the API.
    1.6.8	More sanity checks for tooltop, checks subject for nil
    1.6.7	Replaced inbox item list with item links, to support item quality colors.
    1.6.6	Fixed the error in /inbox when mail is saved for multiple server.
    1.6.5	The filter command now accepts item link.
    		Two new sub-commands for /mailto, listfilter and clearfilter
    1.6.4	Fix the 7th slot inbox, yeah, I can count.. really....
    1.6.3	Fixed more global paramter issues in inbox
    		Fixed more global paramter issues in some slash commands
    		Fixed message timer. This should reslove problem of expiering/arriving mail notification
    1.6.2	Updated to work with 4.0.1
    1.6.1	Updated to work with new ChatFrameEditBox
    1.6.0	Updated Filter to handle 'Heroic' Drops
    		Fixed passing of parameters, thx Dargen for fix
    1.5.9	Added sanity check to Count_Cash() to make sure from is not nil
    		Added redundunt check to MailTo_InboxItem_OnClick() to make sure it does not still have items.
    		Fixed Help string
    1.5.8	Updated Bindings with new function name
    1.5.7	Changed the function name to avoid potential conflict
    		Fixed Inbox data getting wiped for a character when inbox was never checked
    			And player mouse over the mail icon on the minimap.
    			*** BLIZ WHY fire MAIL_INBOX_UPDATE event? ***
    1.5.6	Fixed totaling gold when mailbox is closed for read mails
    		Fixed Autionable Items for 3.1
    1.5.5	Fixed totaling gold when mailbox is closed
    1.5.4	Fixed Ghosting the mailable items window when the number of items decreases
    1.5.3	Added support tooltip to display multiple items in mailbox
    		Added support of item icons in tooltip
    		Added /inbox reset
    1.5.2	Added locked item support
    1.5.1	Fixed mini-inventory frame
    1.5.0	Fixed Adding recipient
    		Fixed off-line inbox
    1.4.9	Fixed Inbox
    1.4.8	Now compatible with WoW 3.0
    1.4.7	Off-line inbox is now closable by Esc key
    1.4.6	Added support for items in the key-ring
    1.4.5	Tooltip on the inbox now record attachment
    1.4.4	Fixed another initialization error. Took out code that was attempting to fill the sendee list automatically
    1.4.3	Fixed the error of fresh install
    1.4.2	The sendee list is now faction specific. *** WARNING the lists will be EMPTYED ***
    1.4.1	Invoking /inbox command now will check the log and nofity delivered items.
    1.4		Changed the way timer works now support timing mailing to inter/intra account mail.
    1.32	Bug Fix for /mtl
    1.31	Bug Fix for inbox, due to change in WoW 2.1
    1.3		Added /mt grid command to configure the number of items displayed
    		Suppress OpenBackpack() when MailFrame is opened (can be opend manually)
    		Cleaned up the update code a bit, removed some redundant error checking
    		
    1.2		Updated ToC
    		Added /mt filter <type>
    		Supported <type> are:
    			Armor, Consumable, Container, Key, Miscellaneous, Reagent,
    			Recipe, Projectile, Quest, Quiver, Trade Goods, Weapon
    		<type> is CASE SENSITIVE
    
    1.11	Fixed to work with new ChatEdit_InsertLink behavior
    		Once again, you can split stack while the auction house is open
    		Fixed Hints not updating in Auction House and Trade
    		Auto Tab Switching while in Auction House and Mailbox
    		
    1.1		Fixed issues with Tradable Window not updating
    		Added Shift Click on items to Link, Split, Pick up items
    		
    1.011	Fixed (hopefully for the last time) SendMailNameEditBox getting disabled if no names were entered

    1.010	Added hint text
    
    1.09	Added scale command. (/mt scale X.X)
    		Fixed item filtering for non-English systems
    		
    1.08	Hooked ChatFrame_OnHyperlinkShow Securely
    
    1.07	Removed ChatFrame_OnHyperlinkShow hook to prevent taint
    
    1.06	Fixed sorting bug, now recipient names should be sorted
    
    1.05	Removed some debugging code left from 1.0.4 (oops)
    
    1.04	Added Close button on the item windows
    		Fixed (again) SendMailNameEditBox so it will now remember the last sendee
    		
    1.03	Fixed Auctionable Items window not updating
    
    1.02	Fixed SendMailNameEditBox getting disabled if no names were entered, 
    		nor was added to menu before mailbox was closed
    		
    1.01	Fixed minor issues with stack count not updating correctly
    
    1.0 	added mailable frame, variation of same frame used in trade/auction
    		removed right click support from inventory
    		renamed the option "shift" into "right"
    		click option will now enable/disable mailable frame
    		right option will now enable/disable right-click function of mailable frame
    	
    	when mailbox is open,
    		left click in the mailable item to attach it to mail
    		right click in the mailable item to mail it to current recipient
    	when trade is open,
    		left click in the tradable item to add it to trade
    		right click in the tradable item to accept trade
    	when auction house is open,
    		left click in the auctionable item to enter the name into auction search
    		right click in the auctionable item to create auction
--]]

--[[ MailTo: Mailbox management system,
    Written by Vincent of Blackhand, (copyright (c) 2005-2006 by D.A.Down)

    Version history:
    1.13.1 - added pairs() to sorted_index returned value.
    1.13 - WoW 2.0 update.
    1.12.2 - Updated 'for' loops for Lua 5.1
    1.12.1 - Fixed compatability issue with item use checking.
    1.12 - WoW 1.12 update.
    1.11.9 - CharacterProfiler replaces CharactersViewer for '/mtl'.
    1.11.8 - Returned items are recorded in the inbox.
    1.11.7 - Added '/inbox return' command.
    1.11.6 - Fixed received date for COD and GM items.
    1.11.5 - Changed 'Expires' to 'Returned' or 'Deleted'.
    1.11.4 - Added stack size to mail item tooltips.
    1.11.3 - Added mail received date (unread only).
    1.11.2 - Slight improvement to mailbox right-clicks.
    1.11.1 - Fixed nil error if CmdHelp isn't loaded.
    1.11 - Added chat command help system (CmdHelp).
    1.10.2 - Updated German localization.
    1.10.1 - Fixed SetChecked() arguments.
    1.10 - WoW 1.11 update.
    1.9.7 - Added money counting to open mail window.
    1.9.6 - Fixed mailbox close on walk-away bug.
    1.9.5 - Updated French localization (from Assutourix).
    1.9.4 - Fixed '/mtl' searches that included a '-'.
    1.9.3 - Fixed problem with sendee name getting erased.
    1.9.2 - Added 'coin' option for including g/s/c in money.
    1.9.1 - Split received cash into sales and refunds
    1.9 - Added recieved item/money logging option (per char).
    1.8.8 - Added '/mtn' to check for newly delivered mail.
    1.8.7 - Fixed duplicate money counting.
    1.8.6 - Added configurable expiration times.
    1.8.5 - Makes sure New Mail icon is hidden when empty.
    1.8.4 - Added color-coded item count to Inbox menu names.
    1.8.3 - Converted Inbox server menu to 2 levels.
    1.8.2 - Added "(possible new mail)" expiration
    1.8.1 - Fixed right-click on chat playername problem.
    1.8 - WoW 1.10 update.
    1.7.5 - Auction shift right-click now sells 1 from stack.
    1.7.4 - Added remove character to inbox list.
    1.7.3 - auto-add of new character to sendee list.
    1.7.2 - Always selects the sendee name.
    1.7.1 - Added shading to color-code inbox items.
    1.7 - Added /mtn command to list new inbox items.
    1.6.3 - Shift right-click on empty inv. does AH recipe search.
    1.6.2 - Fixed chat click reference.
    1.6.1 - Added link support to locate command.
    1.6 - WoW 1.9 update.
    1.5.1 - Added auction search for chat right-click.
    1.5 - Added locate command for inbox and CV items.
    1.4.4 - Added total cash received on mailboc close.
    1.4.3 - Fix for dynamic auction loading in WoW 1.8
    1.4.2 - Added check for missing log field.
    1.4.1 - Fixed error on sender being deleted.
    1.4 - Added right-click support for Trade window.
    1.3.1 - Fixed notification bug for non-alt. sendee.
    1.3 - Added 'From' and 'Expires' to MT inbox tooltip.
    1.2.2 - Right-click fix, delivery updates empty inbox.
    1.2.1 - WoW 1.7 update.
    1.2 - Delivered alt. mail is added to MailTo inbox.
    1.1.3 - Added server option to MailTo inbox.
    1.1.2 - Added options to disable right-click features.
    1.1.1 - Added server name to log entries.
    1.1 - Added support for AIOI, enhanced auction right-click.
    1.0.1 - Cleaned up inbox tooltip and right-click.
    1.0 - Added mail Inbox summary window, key bindings.
    0.8.8 - Added /mailfrom command, formatted money.
    0.8.7 - RightClick on inbox item to retrieve or delete empty.
    0.8.6 - Shift-RightClick on item sends to current sendee.
    0.8.5 - Added options for button position and no 'ding'.
    0.8.4 - Enhanced inbox tooltip of attachment or message.
    0.8.3 - (1600), uses current chat window, auction right-click.
    0.8.2 - Login expiration check, Chinese localizaion.
    0.8.1 - French localization bug-fix.
    0.8 - Inbox package expiration.
    0.7 - Package tracking, limited MailMod support.
    0.6 - French localization, send item right-click.
    0.5.1 - German localization.
    0.5 - Initial public release.
--]]

-- Local
local FCr = "|cffff4040" -- Red
local FCy = "|cffffff10" -- Yellow
local FCo = "|cffff8040" -- Orange
local FCg = "|cff50c050" -- Green
local FCs = "|cffe0e0e0" -- silver
local FCw = "|cffffffff" -- White
local FCe = "|r" -- End
local TCr = {r=0.85, g=0.25, b=0.25}
local TCy = {r=0.85, g=0.85, b=0.25}
local TCg = {r=0.25, g=0.85, b=0.25}
local TCw = {r=1.00, g=1.00, b=1.00}
local MailTo_Selected, MailTo_Name, MailTo_SavedName
local Server,Player,Mail,Mail_server,Mail_name,Cash, Faction
-- local Startup,OpenTime,Last_Click = true,false,0,0
-- local MailCount
local DELAY = 61*60 -- item delivery delay
local DAY = 24*60*60
local MAIL_DAYS = 30
local MAIL_EXP = MAIL_DAYS*DAY
local COD_EXP = 3*DAY
local defIcon = "Interface\\Icons\\INV_Misc_Note_01.blp"
local QmkIcon = "Interface\\Icons\\INV_Misc_QuestionMark"
local function EXP(code) return DAY*(MailTo_Option[code] or MAILTO_DAYS[code]) end
-- GetTime rollover ~ 4.5 days

-- Global
MailTo_Sendee = {}
MailTo_Inbox = {}
MailTo_List = {}
MailTo_Mail = {}
MailTo_Log = {}
MailTo_Option = {}
MailTo_Time = 0

local function mailto_print(msg)
    SELECTED_CHAT_FRAME:AddMessage("MT: "..msg, 0.0, 0.9, 0.9)
end

local function sorted_index(table)
    local index = {}
    for key in pairs(table) do tinsert(index,key) end
    sort(index)
    return pairs(index)
end

-- Convert money to gold/silver/copper
local function add2d(str,fc,n,c)
    if MailTo_Option.nocoin then c = ''
    elseif n==0 and str~='' then return str end
    if n==0 and not str then return end
    if not str or str=='' then return fc..tostring(n)..c end
    return format("%s%s%02d%s",str,fc,n,c)
end

local function gsc(n)
    local str = add2d(nil,FCy,floor(n/10000),'g')
    str = add2d(str,FCs,mod(floor(n/100),100),'s')
    str = add2d(str or '',FCo,mod(n,100),'c')
    return str..FCe
end

function MailTo_Init()
    if MailTo_Option.nologin then Startup = false else Startup = true end
    MailTo_Timer(8)
    UIPanelWindows["MailTo_InFrame"] = {area="left", pushable=9}
    -- add our chat command
    SlashCmdList["MAILTO"] = MailTo_command
    SLASH_MAILTO1 = "/mailto"
    SLASH_MAILTO2 = "/mt"
    SlashCmdList["MAILTOEX"] = MailTo_expire
    SLASH_MAILTOEX1 = "/mtex"
    SlashCmdList["MAILTOLOC"] = MailTo_locate
    SLASH_MAILTOLOC1 = "/mtl"
    SlashCmdList["MAILTONEW"] = MailTo_new
    SLASH_MAILTONEW1 = "/mtn"
    SlashCmdList["MAILFROM"] = MailFrom_command
    SLASH_MAILFROM1 = "/mailfrom"
    SLASH_MAILFROM2 = "/mf"
    SlashCmdList["INBOX"] = MailTo_inbox_command
    SLASH_INBOX1 = "/inbox"
    Player = UnitName("player")
    Server = GetRealmName()
    Faction, _ = UnitFactionGroup("player")
--    if MailTo_Inbox[Server] then
--      if not MailTo_Inbox[Server][Player] and not MailTo_InList(Player) then
--        MailTo_ListAdd(Player)
--      end
--    else MailTo_Inbox[Server]={} end
    if not MailTo_Inbox[Server] then MailTo_Inbox[Server]={} end
    if not MailTo_List[Server] then MailTo_List[Server]={} end
    if not MailTo_List[Server][Faction] then MailTo_List[Server][Faction]={} end
    if not MailTo_Mail[Server] then MailTo_Mail[Server]={} end
    local ix = next(MailTo_Mail)
    if next(MailTo_Mail,ix) then
      MailTo_InFrameServerButton:Show()
      MailTo_InFrameServerButton:SetChecked(MailTo_Option.server)
    end
--    Mail = MailTo_Mail[Server]
    MailTo_SavedName = MailTo_Sendee[Server]
    MailTo_InFrame_DropDown.displayMode = "MENU"
    MailToDropDownMenu.displayMode = "MENU"
-- 	hook inventory item use
-- 	hooksecurefunc("UseContainerItem", MailTo_InvUse)
-- 	MailTo_InvUse_Save = UseContainerItem
-- 	UseContainerItem = MailTo_InvUse
-- 	MailTo_InvUse_Save = ContainerFrameItemButton:GetScript("OnClick")
-- 	ContainerFrameItemButton:SetScript("OnClick",MailTo_InvUse)
    -- hook send mail name select
    MailTo_SendName_Save = SendMailNameEditBox:GetScript('OnEditFocusGained')
    SendMailNameEditBox:SetScript('OnEditFocusGained',MailTo_SendName)
    -- hook send mail
    MailTo_SendMail_Save = SendMailFrame_SendMail
    SendMailFrame_SendMail = MailTo_SendMail
    -- hook Inbox mouseover
    MailTo_InboxItem_Save = InboxFrameItem_OnEnter
    InboxFrameItem_OnEnter = MailTo_InboxItem
    -- hook Inbox click
    MailTo_InboxItem_OnClick_Save = InboxFrame_OnClick
    -- InboxFrame_OnClick = MailTo_InboxItem_OnClick
    for slot = 1,7 do
    	_G["MailItem"..slot.."Button"]:SetScript("OnClick", MailTo_InboxItem_OnClick)
    end
    
    -- hook Inbox money click
    MailTo_InboxMoney_OnClick_Save = OpenMailMoneyButton:GetScript('OnClick')
    OpenMailMoneyButton:SetScript('OnClick',MailTo_InboxMoney_OnClick)
    -- hook Inbox return item
    MailTo_ReturnInboxItem_Save = ReturnInboxItem
    ReturnInboxItem = MailTo_ReturnInboxItem
    -- hook Chat OnCLick
    hooksecurefunc("ChatFrame_OnHyperlinkShow", MailTo_ChatOnClick)
    -- MailTo_ChatOnClick_Save = ChatFrame_OnHyperlinkShow
    -- ChatFrame_OnHyperlinkShow = MailTo_ChatOnClick
    -- hook MailMod
    MailTo_MailMod_Save = MailFrameTab_OnClick
    MailFrameTab_OnClick = MailTo_MailMod
    -- hook OpenBackpack
    -- MailTo_OpenBackpack_Save = OpenBackpack
    -- OpenBackpack = MailTo_OpenBackpack
    -- Window position of MailTo button
    if GetLocale()=="frFR" or GetLocale()=='deDE' or MailTo_Option.pos then
      local pos = MailTo_Option.pos and MailTo_Option.pos or -12
      MailToDropDownMenu:SetPoint("RIGHT","SendMailNameEditBox","RIGHT",pos,0)
    end
	if MailTo_Option.scale then
		MailTo_MailableFrame:SetScale(MailTo_Option.scale)
		MailTo_TradableFrame:SetScale(MailTo_Option.scale)
		MailTo_AuctionableFrame:SetScale(MailTo_Option.scale)
	end
    	
    -- CmdHelp loaded check
    if not CmdHelp then CmdHelp = function () end
    else CmdHelp(MT_Help,'mt') end
end

-- Add to tooltip if money is involved-- English text strings

-- Binding Configuration
BINDING_HEADER_MAILTO   = "MailTo"
BINDING_NAME_MAILTOLOG  = "Display MailTo log"
BINDING_NAME_MAILTOEX   = "Display Inbox expirations"
BINDING_NAME_MAILTOMAIL = "Toggle MailTo Inbox window"

-- MailTo option list with text
MAILTO_OPTION = { alert=  {flag='noalert', name="Delivery alert"},
                  auction={flag='noauction', name="Auction click"},
                  chat=   {flag='nochat',  name="Chat click"},
                  coin=   {flag='nocoin',  name="Coin letters"},
                  ding=   {flag='noding',  name="Ding sound"},
                  click=  {flag='noclick', name="Inventory"},
                  login=  {flag='nologin', name="Login notice"},
                  right=  {flag='noshift', name="Right-click"},
                  trade=  {flag='notrade', name="Trade click"},
                }
MAILTO_DAYS = {icon=28, long=3, new=7, short=1, soon=3, warn=2}

-- Message text
MAILTO_ON =         "%s has been turned on."
MAILTO_OFF =        "%s has been turned off."
MAILTO_TIME =       "The time for '%s' expiration has been set to %s"
MAILTO_TOOLTIP =    "Click to select recipient."
MAILTO_CLEARED =    "The MailTo list has been cleared!"
MAILTO_LISTEMPTY =  "Empty list."
MAILTO_LISTFULL =   "Warning: List is full!"
MAILTO_ADDED =      " added to MailTo list."
MAILTO_REMOVED =    " removed from MailTo list."
MAILTO_F_ADD =      "(Add %s)"
MAILTO_F_REMOVE =   "(Remove %s)"
MAILTO_YOU =        "you"
MAILTO_DELIVERED =  "delivered."
MAILTO_DUE =        "due in %d min."
MAILTO_SENT =       "%s sent to %s by %s is %s"
MAILTO_RETURNLIST = "Returnable inbox items:"
MAILTO_RETURN =     "|cffffffff%s|r sent to %s"
MAILTO_NORETURN =   "No returnable items found."
MAILTO_NEW =        "%s%s from %s delivered to %s"
MAILTO_NONEW =      "No new mail items found."
MAILTO_NEWMAIL =    "(possible new mail)"
MAILTO_LOGEMPTY =   "The mail log is empty."
MAILTO_NODATA =     "No inbox data."
MAILTO_NOITEMS =    "No items in inbox."
MAILTO_NOTFOUND =   "No items found."
MAILTO_INBOX =      "#%d, %s, from %s"
MAILTO_EXPIRES =    " expires in "
MAILTO_EXPIRED =    " has expired!"
MAILTO_UNDEFINED =  "Undefined command, "
MAILTO_RECEIVED =   "Received %s from %s, %s"
MAILTO_SALE =       "%s bought %s for %s (net=%s)."
MAILTO_WON =        "You bought %s from %s for %s."
MAILTO_NONAME =     "Missing name."
MAILTO_NODESC =     "Missing description."
MAILTO_MAILOPEN =   "Mailbox is open."
MAILTO_MAILCHECK =  "Mailbox not checked."
MAILTO_TITLE =      "MailTo  Inbox"
MAILTO_STACK =		"(Stack of %d)"
MAILTO_DATE =       "Date Rcvd: "
MAILTO_SELECT =     "Select:"
MAILTO_SERVER =     "Server"
MAILTO_SERVERTIP =  "Check to select characters on other servers"
MAILTO_FROM =       "From: "
MAILTO_EXPIRES2 =   "Expires in "
MAILTO_RETURNED =   "Returned in "
MAILTO_DELETED =    "Deleted in "
MAILTO_EXPIRED2 =   "Has expired!"
MAILTO_RETURNED2 =  "Has been returned!"
MAILTO_DELETED2 =   "Has been deleted!"
MAILTO_LOCATE =     "Locating items matching '%s':"
MAILTO_REMOVE2 =    "Removed %s of %s."
MAILTO_BACKPACK =   "No empty backpack slot for split."
MAILTO_EMPTYNEW =   "You may have new mail..."
MAILTO_MAIL =       "Mail"
MAILTO_INV =        "Inv"
MAILTO_BANK =       "Bank"
MAILTO_SOLD =       "Auction successful"
MAILTO_OUTBID =     "Outbid"
MAILTO_CANCEL =     "Auction cancelled"
MAILTO_CASH =       "Received cash: Total=%s, Sales=%s, Refunds=%s, Other=%s"
MAILTO_MAILABLE = 	"Mailable Items"
MAILTO_TRADABLE = 	"Tradable Items"
MAILTO_AUCTIONABLE = 	"Auctionable Items"
MAILTO_MAILABLE_L = 	"Left - Attach Item"
MAILTO_TRADABLE_L = 	"Left - Trade Item"
MAILTO_AUCTIONABLE_L = 	"Left - Search"
MAILTO_MAILABLE_R = 	"Right - Mail Item"
MAILTO_TRADABLE_R = 	"Right - Accept"
MAILTO_AUCTIONABLE_R = 	"Right - Auction Item"
MAILTO_SHIFT_CHAT_L = 	"Left - Paste Item Link"
MAILTO_SHIFT_L = 		"Left - Split Item"
MAILTO_SHIFT_R = 		"Right - Pickup Item"

-- Help text
MT_Help = { ['?'] = 'MailTo';
	inbox = { ['?'] = "Manage your inbox window",
		  [''] = "Toggle the inbox viewer window",
		  ['return'] = "List returnable sent items",
		  ['<name>'] = "View the inbox for <name>", };
	mf = { ['?'] = "Add a mail log item",
		  ['<name> <item>'] = "Add a mail log entry for an item being sent to you", };
	mailto = { ['?'] = "The main chat command",
		  [''] = "List mail log entries for the current character",
		  alert = "Toggles whether delivery messages are sent immediately",
		  auction = "Toggles auctionable item window feature",
		  chat = "Toggles whether the chat link right-click is ignored",
		  clear = "Clears the Send Mail menu list",
		  click = "Toggles mailable item window feature",
		  coin = "Toggles whether the money display includes the coin letter",
		  ding = "Toggles the delivered mail sound on or off",
		  list = "List the Send Mail menu names",
		  login = "Toggles whether expiring and pending items will be listed at login",
		  pos = "Moves the Send Mail menu position",
		  scale = "Set scale of mailable item window",
		  right = "Toggles special function in mailable/tradable/auctionable window",
		  trade = "Toggles tradable item window feature", 
		  filter = "Filter item type, or itemLink", 
		  listfilter = "Prints all the currently filtered items",
		  clearfilter = "Remove ALl Filters",
		  grid = "Set grid size (4-10)", };
	mtex = { ['?'] = "Manage exiring messages",
		  [''] = "List the next inbox item to expire for the current character",
		  active = "List the next inbox item to expire for all non-empty mailboxes",
		  all = "List the next inbox item to expire for all non-empty mailboxes",
		  active = "List the next inbox item to expire for all characters",
		  icon = "Set exp. days for inbox potential mail icon (def=28)",
		  long = "Set days for long exp. color of yellow (def=7)",
		  new = "Set days for potential new mail exp. listing (def=3)",
		  short = "Set days for short exp. color of red (def=1)",
		  server = "List the next inbox item to expire for all characters on this server",
		  soon = "List the inbox items to expire soon, normally in 3 days",
		  warn = "Set exp. days for login warning message (def=2)", };
	mtl = { ['?'] = "Locate inbox items",
		  ['<name>'] = "Locate all inbox and CharactersViewer items matching <name>", };
	mtn = { ['?'] = "Display newly delivered items",
		  [''] = "Display newly delivered items on this server ",
		  all = "Display newly delivered items on all servers", };
	}
local function tip_money(money)
    if money>0 then
      GameTooltip:AddLine(ENCLOSED_MONEY)
      SetTooltipMoney(GameTooltip,money)
    elseif money<0 then
      GameTooltip:AddLine(COD_AMOUNT,1,0.3,0.3)
      SetTooltipMoney(GameTooltip,-money)
    end
end

-- Handle Inbox mouseover
function MailTo_InboxItem(self)
    MailTo_InboxItem_Save(self)
    
    local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned, textCreated, canReply, isGM = GetInboxHeaderInfo(self.index)
	-- local item,icon,from,sub,money,cod,dl,hi,read,rt,tc,cr,b = GetInboxHeaderInfo(this.index)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	
	if IsControlKeyDown() or wasRead and not (packageIcon and canReply) then
		GameTooltip:SetText(subject)
		local text = GetInboxText(self.index)
		if text then 
			GameTooltip:AddLine(text,1,1,1,1) 
		end
		--local iType,item,name,bid,bo,dep,cut = GetInboxInvoiceInfo(this.index)
		local invoiceType, itemName, playerName, bid, buyout, deposit, consignment = GetInboxInvoiceInfo(self.index)
		if invoiceType=='seller' then
			GameTooltip:AddLine(format(MAILTO_SALE,playerName or AUCTION_HOUSE_MAIL_MULTIPLE_BUYERS,itemName,gsc(bid),gsc(bid-consignment)),1,1,1)
		elseif invoiceType=='buyer' then
			GameTooltip:AddLine(format(MAILTO_WON,itemName,playerName or AUCTION_HOUSE_MAIL_MULTIPLE_SELLERS,gsc(bid)),1,1,1)
		end
	elseif item then 
		GameTooltip:SetInboxItem(self.index)
	elseif subject then
		GameTooltip:SetText(subject) 
	end
	
	if packageIcon then
      	for j = 1, ATTACHMENTS_MAX_RECEIVE do
        	local name, ID, itemTexture, count, quality, canUse = GetInboxItem(self.index, j)
        	if name then
	        	--mailto_print( name )
				if count > 1 then 
	        		GameTooltip:AddDoubleLine("|T"..itemTexture..":0|t "..name, count, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
				else
	        		GameTooltip:AddLine("|T"..itemTexture..":0|t "..name, 1.0, 1.0, 1.0) 
	        	end
	        end
        end
	end

	if money > 0 then 
		tip_money( money )
	elseif CODAmount > 0 then 
		tip_money( -CODAmount ) 
	end
	
	if not wasRead then
		local exp = CODAmount > 0 and COD_EXP or isGM and MAIL_EXP * 3 or MAIL_EXP
		local rcv = date('%m/%d %H:%M', OpenTime - exp + daysLeft * DAY)
		GameTooltip:AddLine(MAILTO_DATE..rcv)
	end
	GameTooltip:Show()
end

-- Handle Inbox click
local function Count_Cash(from,sub,money)
	Cash.total = Cash.total+money
	if strfind(sub,MAILTO_OUTBID) or strfind(sub,MAILTO_CANCEL) then
	  Cash.refund = Cash.refund+money
	elseif strfind(sub,MAILTO_SOLD) then
	  Cash.sales = Cash.sales+money
	else Cash.other = Cash.other+money end
	
	if not from then from = 'Unknown' end
	
	mailto_print(format(MAILTO_RECEIVED,gsc(money),from,sub))
end

function MailTo_InboxItem_OnClick(self, button, down)
	ix = self.index
	-- DEFAULT_CHAT_FRAME:AddMessage("MailTo_InboxItem_OnClick "..ix.." "..self:GetName().." "..button)
	if button=="RightButton" then
		local item,icon,from,sub,money,cod,dl,hi,read,rt,tc,cr = GetInboxHeaderInfo(ix)
		if not from then from = '?'; end
		local delete = InboxItemCanDelete(ix)
		local single = not IsAltKeyDown()
		local skip
		if money>0 then
			GetInboxText(ix) -- force read to access invoice
			-- CheckInbox()
			-- if not read then Count_Cash(from,sub,money) end
			Count_Cash(from,sub,money)
			local iType,item,name,bid,bo,dep,cut = GetInboxInvoiceInfo(ix)
			if iType=='seller' then
				mailto_print(format(MAILTO_SALE,name or AUCTION_HOUSE_MAIL_MULTIPLE_BUYERS,item,gsc(bid),gsc(bid-cut)))
			end
			TakeInboxMoney(ix)
			if single then skip = true end
		elseif hi and not cr then
			GetInboxText(ix) -- force read to access invoice
			local iType,item,name,bid,bo = GetInboxInvoiceInfo(ix)
			if iType=='buyer' then
				mailto_print(format(MAILTO_WON,item,name or AUCTION_HOUSE_MAIL_MULTIPLE_SELLERS,gsc(bid)))
			end
		end
		if item and not skip then
			local itemIndex = 0
			if single then 
				item = GetInboxItem(ix, itemIndex)
				mailto_print(format(MAILTO_RECEIVED,item,from,sub))
				TakeInboxItem(ix, itemIndex)
				skip = true
			else
				for itemIndex = ATTACHMENTS_MAX_RECEIVE, 1, -1 do
					item = GetInboxItem(ix, itemIndex)
					if item then
						mailto_print(format(MAILTO_RECEIVED,item,from,sub))
					end
				end
				AutoLootMailItem( ix )
			end

			if delete then GetInboxText(ix) end
		end
		local text,str,flag = GetInboxText(ix);
		
		if not skip and (read or not flag) then 
			local _,_,_,_,hasMoney,_,_,hasItem,_,_,_,_,_ = GetInboxHeaderInfo(ix)
			if not (hasMoney and hasItem) then
				DeleteInboxItem(ix) 
			end
		end
		
		if read or not MailTo_ReceivedLog then return end
		if money==0 and not item or strfind(from,' ') then return end
		local log = format("%s,%d,%s,%d,%s",from,money,item or '',dl,sub)
		mailto_print('MailTo_ReceivedLog: '..log)
		MailTo_ReceivedLog[time()] = log
	else 
		MailTo_InboxItem_OnClick_Save(self, ix) 
	end
end

function MailTo_InboxMoney_OnClick(...)
	if OpenMailFrame.money then
      local item,icon,from,sub,money = GetInboxHeaderInfo(InboxFrame.openMailID)
	  Count_Cash(from,sub,money)
	end
	MailTo_InboxMoney_OnClick_Save(...)
end

function MailTo_ReturnInboxItem(itemID)
    local item,icon,from,sub,money = GetInboxHeaderInfo(itemID)
	if MailTo_Mail[Server][from] then
	  local nr,_
	  if item then _,_,icon,nr = GetInboxItem(itemID, 1) end
	  local exp = time() + MAIL_EXP
	  local mail = {tex=icon; name=sub; from=Player; mon=money; exp=exp; nr=nr; new=1}
	  tinsert(MailTo_Mail[Server][from],1,mail)
	  if(MailTo_Inbox[Server][from].pkg==0) then
		MailTo_Inbox[Server][from] = {pkg=1; from=Player; desc=sub; mon=money; exp=exp}
	  end
	end
	MailTo_ReturnInboxItem_Save(itemID)
end

-- Handle auction browse searching
function AuctionSearch(link)
    if MailTo_Option.noauction then return end
    if not AuctionHouseFrame.SearchBar or not AuctionHouseFrame.SearchBar:IsVisible() then return end
    if link and not strfind(link,"item:") then return end
    AuctionHouseFrame.SearchBar.FilterButton:Reset()
    local name,ilk,ir,il,iml,class,sub
    if link then
      local i,j,name = strfind(link,"%[(.+)%]")
      AuctionHouseFrame.SearchBar:SetSearchText(name)
      --IsUsableCheckButton:SetChecked(false)
      if MailTo_Option.noshift or IsShiftKeyDown() then return 1 end
      --AuctionHouseFrame.SearchBar.FilterButton.LevelRangeFrame.MinRange:SetText()
      --AuctionHouseFrame.SearchBar.FilterButton.LevelRangeFrame.MaxRange:SetText()
--      local i,j,item = strfind(link,"(item:%d+:%d+:%d+:%d+)")
--      name,ilk,ir,il,iml,class,sub = GetItemInfo(item)
    else
      AuctionHouseFrame:SetSearchText('')
      --IsUsableCheckButton:SetChecked(true)
      if MailTo_Option.noshift or IsShiftKeyDown() then return 1 end
      --class = 'Recipe'; sub = class
    end
    -- TODO: AuctionHouseCategoriesList
--    AuctionFrameBrowse.selectedClass = class
--    for ix,name in pairs(CLASS_FILTERS) do
--      if name==class then
--        AuctionFrameBrowse.selectedClassIndex = ix
--        i = ix
--        break
--      end
--    end
--    if class~=sub then
--      AuctionFrameBrowse.selectedSubclass = HIGHLIGHT_FONT_COLOR_CODE..sub..FONT_COLOR_CODE_CLOSE
--      for ix,name in pairs({GetAuctionItemSubClasses(i)}) do
--        if name==sub then
--          AuctionFrameBrowse.selectedSubclassIndex = ix
--          break
--        end
--      end
--    else
--      AuctionFrameBrowse.selectedSubclass = nil
--      AuctionFrameBrowse.selectedSubclassIndex = nil
--    end
--    AuctionFrameBrowse.selectedInvtype = nil
--    AuctionFrameBrowse.selectedInvtypeIndex = nil
--    AuctionFrameFilters_Update()
    AuctionHouseFrame.SearchBar:StartSearch()
    return 1
end

-- Handle Chat OnClick events
function MailTo_ChatOnClick(item,link,button)
	--DEFAULT_CHAT_FRAME:AddMessage("MailTo_ChatOnClick")
    if button=="RightButton" and not IsControlKeyDown() and not IsAltKeyDown() then
      if AuctionSearch(link) then return end
    end
    --MailTo_ChatOnClick_Save(item,link,button)
end

-- Handle Inventory Use events
--[[
function MailTo_InvUse(ParentID,ItemID)
	if not CursorHasItem() and not SpellIsTargeting() and not IsControlKeyDown() and not IsAltKeyDown() and not MailTo_Option.noclick and GetTime()-Last_Click>0.5 then
		Last_Click = GetTime()
		local doshift = IsShiftKeyDown() and not MailTo_Option.noshift
		if SendMailFrame:IsVisible() then
			PickupContainerItem(ParentID,ItemID)
			ClickSendMailItemButton()
			if doshift then
				SendMailMailButton:Click()
				this:Enable()
			end
			return
		end
		if TradeFrame:IsVisible()and not MailTo_Option.notrade then
			PickupContainerItem(ParentID,ItemID)
			local slot = TradeFrame_GetAvailableSlot()
			if slot then ClickTradeButton(slot) end
			return
		end
		if (AuctionFrameAuctions and AuctionFrameAuctions:IsVisible()) and not MailTo_Option.noauction then
		if doshift then
			for slot = 1,16 do
				if not GetContainerItemInfo(0,slot) then
					SplitContainerItem(ParentID,ItemID,1)
					PickupContainerItem(0,slot)
					MailTo_Slot = slot
					return
				end
			end
			mailto_print(MAILTO_BACKPACK)
			return
		end
		PickupContainerItem(ParentID,ItemID)
		ClickAuctionSellItemButton()
		return
	end
	if AuctionSearch(GetContainerItemLink(ParentID,ItemID)) then return end
	end
--    MailTo_InvUse_Save(ParentID,ItemID)
end
--]]

function MailTo_SendName(...)
	--DEFAULT_CHAT_FRAME:AddMessage("MailTo_SendName")
	local sendee = SendMailNameEditBox:GetText()
	--DEFAULT_CHAT_FRAME:AddMessage("sendee = "..sendee)
	if MailTo_SendName_Save then MailTo_SendName_Save(...) end
	if MailTo_SavedName and MailTo_SavedName ~= "" and ((not sendee) or (sendee == "")) then
		--DEFAULT_CHAT_FRAME:AddMessage("MailTo_SavedName = "..MailTo_SavedName)
		SendMailNameEditBox:SetText(MailTo_SavedName)
		SendMailNameEditBox:HighlightText(0,-1)
		SendMailNameEditBox:ClearFocus()
		return
	end
	SendMailNameEditBox:HighlightText(0,-1)
	MailTo_SavedName = sendee
end

-- Handle clicks on the Send button
function MailTo_SendMail()
		MailTo_SavedName = SendMailNameEditBox:GetText()
		local name,id,tex,nr,qlty = GetSendMailItem(1)
		local copper = MoneyInputFrame_GetCopper(SendMailMoney)
		if name then
		-- Item take time to reach non-alts
			--local log = {to=MailTo_SavedName,from=Player,sv=Server,item=name,date=date(),due=GetTime()+DELAY}
			local log = {to=MailTo_SavedName,from=Player,sv=Server,item=name,date=date()}
			if MailTo_Mail[Server][MailTo_SavedName] then
				log.tex = tex
				log.sub = SendMailSubjectEditBox:GetText()
				log.nr = nr
				--local copper = MoneyInputFrame_GetCopper(SendMailMoney)
				if SendMailCODButton:GetChecked() then copper = -copper; end
				log.mon = copper;
			end
			log.cod = SendMailCODButton:GetChecked()

			-- Check to see if we know the log.to is an known alt
			-- DEFAULT_CHAT_FRAME:AddMessage("Checking "..Server..", "..Player)

			if not MailTo_Inbox[Server][MailTo_SavedName] then
			-- if not a known alt, it takes an hour
				log.due = GetTime()+DELAY
			else
			-- if it's a known alt, we set it due now
				log.due = GetTime()
			end
			
			if MailTo_Time==0 then MailTo_Timer(DELAY) end
			table.insert(MailTo_Log,log)
		elseif copper or copper > 0 then
		-- Money take time to reach non-alts
			--local log = {to=MailTo_SavedName,from=Player,sv=Server,item=name,date=date(),due=GetTime()+DELAY}
			local log = {to=MailTo_SavedName,from=Player,sv=Server,item="",date=date()}
			if MailTo_Mail[Server][MailTo_SavedName] then
				log.tex = tex
				log.sub = SendMailSubjectEditBox:GetText()
				log.nr = nr
				--local copper = MoneyInputFrame_GetCopper(SendMailMoney)
				if SendMailCODButton:GetChecked() then copper = -copper; end
				log.mon = copper;
			end
			log.cod = SendMailCODButton:GetChecked()

			-- Check to see if we know the log.to is an known alt
			if not MailTo_Inbox[Server][MailTo_SavedName] then
			-- if not a known alt, it takes an hour
				log.due = GetTime()+DELAY
			else
			-- if it's a known alt, we set it due now
				log.due = GetTime()
			end
			
			if MailTo_Time==0 then MailTo_Timer(DELAY) end
			table.insert(MailTo_Log,log)


--    elseif MailTo_Mail[Server][MailTo_SavedName] then
--      if SendMailCODButton:GetChecked() then copper = -copper; end
--      name = SendMailSubjectEditBox:GetText()
--      local mail = {mon=copper,from=Player,exp=time()+MAIL_EXP,name=name,new=1}
--      tinsert(MailTo_Mail[Server][MailTo_SavedName],1,mail)
    end
    MailTo_Sendee[Server] = MailTo_SavedName
    SendMailNameEditBox:ClearFocus()
    MailTo_SendMail_Save()
end

function MailTo_MailMod(self, tab)
    if not tab then tab = self:GetID() end
    if tab==3 and CT_MailNameEditBox and MailTo_SavedName then
      CT_MailNameEditBox:SetText(MailTo_SavedName)
      CT_MailNameEditBox:HighlightText(0,-1)
    end
    MailTo_MailMod_Save(self, tab)
end

-- Process events
function MailTo_Event(event)
	if event=="BAG_UPDATE" then
		if MailTo_Slot then
			C_Container.PickupContainerItem(0,MailTo_Slot)
			ClickAuctionSellItemButton()
			MailTo_Slot = nil
		end
		return
	end
	if event=="MAIL_CLOSED" then
		-- mailto_print( "MAIL_CLOSED" )
		-- if( MailCount ) then mailto_print( "MailCount = "..MailCount ) end
		-- if( Cash.total ) then mailto_print( "Cash.total = "..Cash.total ) end
		-- if(MailCount and Cash.total>0) then
		if( Cash.total > 0 ) then
			mailto_print(format(MAILTO_CASH,gsc(Cash.total),gsc(Cash.sales),gsc(Cash.refund),gsc(Cash.other)))
			Cash.total = 0
		end
		-- MailCount = nil
		
		OpenTime = nil
		return
	end
	
	--local nbr = GetInboxNumItems()
	--if event == "MAIL_INBOX_UPDATE" and nbr > 0 then 
	if event == "MAIL_INBOX_UPDATE" then 
		-- mailto_print( "event = "..event )
		if OpenTime then
			MailTo_UpdateInboxRecord()
		end
		return 
	end
	--if event == "MAIL_SHOW" and nbr > 0 then
	if event == "MAIL_SHOW" then
		-- mailto_print( "event = "..event )
		Cash = {total=0,sales=0,refund=0,other=0}
		OpenTime = time()
		HideUIPanel(MailTo_InFrame)
		MailTo_UpdateInboxRecord()
		return
	end
end

function MailTo_UpdateInboxRecord()
	-- mailto_print("MailTo_UpdateInboxRecord")

	-- MailCount = nbr
	local nbr = GetInboxNumItems()
	local days = MAIL_DAYS
	local exp = floor(time()+days*DAY)
	local inbox = {pkg=0,exp=exp}
	local mail = {}
	
	-- mailto_print("MailTo_UpdateInboxRecord with "..nbr.." for "..Server..":"..Player)

	if nbr > 0 then
		local pkg,from,desc,mny,nm,tx,nr,del = 0
		local pi,si,sndr,sub,mon,cod,left,item,rd,rt,tc,cr
		for i = 1, nbr do
			pi,si,sndr,sub,mon,cod,left,item,rd,rt,tc,cr = GetInboxHeaderInfo(i)
			del = mon == 0 and not item or rt or not cr
			if cod > 0 then 
				mon = -cod; 
			end
			if item and left<=days then
				pkg=i; days=left; from=sndr; desc=sub; mny=mon
			end
			if not pi and si~=defIcon then 
				pi = si 
			end
			exp = floor(time()+left*DAY)
			-- mail[i] = {tex=pi; name=sub; from=sndr; mon=mon; nr=nr; exp=exp; del=del}
			mail[i] = {tex=pi; name=sub; from=sndr; mon=mon; exp=exp; del=del}
		
			for j = 1, ATTACHMENTS_MAX_RECEIVE do
				local nm,id,tx,nr,qlty,canUse = GetInboxItem(i, j)
				local ilink = GetInboxItemLink(i, j);
				if nm then
					-- mailto_print( nm.." "..qlty )
					mail[i][j] = {name=nm; count=nr; texture=tx; quality=qlty; item_link=ilink} 
				end
			end
		end
		if pkg > 0 then
			exp = floor(time()+days*DAY)
			inbox = {pkg=pkg; from=from; desc=desc; mon=mny; exp=exp}
		end
	--else 
	-- 	MiniMapMailFrame:Hide() 
	end
	
	MailTo_Mail[Server][Player] = mail
	MailTo_Inbox[Server][Player] = inbox
end

-- Handle our /mailto commands
function MailTo_command(msg)
	msg = strtrim(msg)

    if msg=='' then
      if table.getn(MailTo_Log)==0 then
        mailto_print(MAILTO_LOGEMPTY)
        return
      end
      MailTo_CheckLog(true)
      return
    end
    if CmdHelp(MT_Help,'mailto',msg) then return end
    if MAILTO_OPTION[msg] then
      local option = MAILTO_OPTION[msg]
      MailTo_Option[option.flag] = not MailTo_Option[option.flag]
      mailto_print(format(MailTo_Option[option.flag] and MAILTO_OFF or MAILTO_ON,option.name))
      return
    end
    if msg=="log" then
      MailTo_ReceivedLog = not MailTo_ReceivedLog and {} or nil
      mailto_print(format(MailTo_ReceivedLog and MAILTO_ON or MAILTO_OFF,'MailTo_ReceivedLog'))
      return
    end
    if msg=="clear" then
      MailTo_List[Server][Faction] = {}
      mailto_print(MAILTO_CLEARED)
      return
    end
    local _,_,pos = strfind(msg,"pos (%-?%d+)")
    if pos then
      mailto_print("pos = "..pos)
      MailTo_Option.pos = pos
      MailToDropDownMenu:SetPoint("RIGHT","SendMailNameEditBox","RIGHT",pos,0)
      return
    end
	local _,_,scale = strfind(msg,"scale (%-?[%d%.]+)")
	if scale then
		mailto_print("scale = "..scale)
		MailTo_Option.scale = scale
		MailTo_MailableFrame:SetScale(scale)
		MailTo_TradableFrame:SetScale(scale)
		MailTo_AuctionableFrame:SetScale(scale)
		return
	end
	local _,_,filter = strfind(msg,"filter%s+(.+)%s*")
	if filter then
		mailto_print( filter )
		if Mailable_FilterList[ filter ] then
			mailto_print("removing "..filter.." from filter")
			Mailable_FilterList[ filter ] = nil
		else
			mailto_print("adding "..filter.." to filter")
			Mailable_FilterList[ filter ] = true
		end
		
		if Mailable_OpenFrame == "Mail" then
			Mailable_Finditems( "MailTo_MailableFrame", false, true )
		elseif Mailable_OpenFrame == "Trade" then
			Mailable_Finditems( "MailTo_TradableFrame", true, false )
		elseif Mailable_OpenFrame == "Auction" then
			Mailable_Finditems( "MailTo_AuctionableFrame", false, false )
		end
		return
	end
    if msg=="listfilter" then
    	for filter, b in pairs(Mailable_FilterList) do
    		-- mailto_print(gsub(filter, "\124", "\124\124"))
    		mailto_print(filter)
    	end
      return
    end
	if msg=="clearfilter" then
		mailto_print("all filter removed")
		Mailable_FilterList = {}
		
		if Mailable_OpenFrame == "Mail" then
			Mailable_Finditems( "MailTo_MailableFrame", false, true )
		elseif Mailable_OpenFrame == "Trade" then
			Mailable_Finditems( "MailTo_TradableFrame", true, false )
		elseif Mailable_OpenFrame == "Auction" then
			Mailable_Finditems( "MailTo_AuctionableFrame", false, false )
		end
		return
	end
	local _,_,grid = strfind(msg,"grid (%d+)")
	if grid then
		MailTo_Option.grid = tonumber( grid )
		if MailTo_Option.grid > 10 then
			MailTo_Option.grid =10
		elseif MailTo_Option.grid < 4 then
			MailTo_Option.grid = 4
		end
		mailto_print( "grid = "..MailTo_Option.grid )
		Mailable_Update()
		return
	end
    if msg~="list" then
      mailto_print(FCr..MAILTO_UNDEFINED..msg)
      return
    end
    local list = ''
    for i,name in pairs(MailTo_List[Server][Faction]) do
      if list~='' then list = list..', ' end
      list = list..name
    end
    if list=='' then mailto_print(FCr..MAILTO_LISTEMPTY)
    else mailto_print(list) end
end

-- Handle our /mailfrom commands
function MailFrom_command(msg)
	msg = strtrim(msg)

    if CmdHelp(MT_Help,'mf',msg) then return end
    local i,j,from,desc
    if msg and msg~='' then
      i,j,from = strfind(msg,"^(%a+)$")
      if not from then
        i,j,from,desc = strfind(msg,"^(%a+) (.+)$")
      end
    end
    if not from then mailto_print(FCr..MAILTO_NONAME) return end
    if not desc then mailto_print(FCr..MAILTO_NODESC) return end
    local log = {from=from,to=Player,sv=Server,item=desc,sub=desc,mon=0,date=date(),due=GetTime()+DELAY}
    if MailTo_Time==0 then MailTo_Timer(DELAY) end
    table.insert(MailTo_Log,log)
    MailTo_Format(log)
end

-- Handle our /mtex commands
function MailTo_expire(msg)
	msg = strtrim(msg)

    if msg~='' and CmdHelp(MT_Help,'mtex',msg) then return end
    local _,_,word,days,hr = strfind(msg,"(%l+) (%d+)(h?)")
    if word and MAILTO_DAYS[word] then
      MailTo_Option[word] = days/(hr=='h' and 24 or 1)
      mailto_print(format(MAILTO_TIME,word,SecondsToTime(MailTo_Option[word]*DAY)))
    elseif msg=="all" or msg=="active" or msg=="soon" or msg=="expired" then
      local cnt = 0
      for server,list in pairs(MailTo_Inbox) do
        for player,inbox in pairs(list) do
          if msg=="all" or inbox.pkg>0 and (msg=="active" or
                msg=="soon" and inbox.exp-time()<EXP'soon' or
                msg=="expired" and inbox.exp-time()<1) then
            MailTo_exp_msg(inbox,player,server)
            cnt = cnt+1
          end
        end
      end
      if cnt==0 then mailto_print(MAILTO_NOTFOUND) end
    elseif msg=="server" then
      for player,inbox in pairs(MailTo_Inbox[Server]) do
        MailTo_exp_msg(inbox,player)
      end
    else MailTo_exp_msg(MailTo_Inbox[Server][Player]) end
end

-- Check for soon to expire messages
function MailTo_CheckEx()
    for server,list in pairs(MailTo_Inbox) do
      for player,inbox in pairs(list) do
        if inbox and inbox.pkg>0 and inbox.exp-time()<EXP'warn' then
          MailTo_exp_msg(inbox,player,server)
        end
      end
    end
end

-- Format the expired message
function MailTo_exp_msg(inbox,to,server)
    local msg
    if not inbox then mailto_print(FCr..MAILTO_NODATA) return end
    local exp = inbox.exp and inbox.exp-time() or MAIL_EXP
    if inbox.pkg==0 and exp>EXP'new' then msg = MAILTO_NOITEMS
    else
      local desc = inbox.desc or MAILTO_NEWMAIL
      local from = inbox.from or '?'
      msg = format(MAILTO_INBOX, inbox.pkg, desc, from)
      if exp<EXP'short' then msg = msg..FCr
      elseif exp<EXP'long' then msg = msg..FCy end
      if exp<1 then msg = msg..MAILTO_EXPIRED
      else msg = msg..MAILTO_EXPIRES..SecondsToTime(exp) end
    end
    if to then msg = to..": "..msg end
    if server then msg = server..":"..msg end
    mailto_print(msg)
end

-- Handle /inbox command
function MailTo_inbox_command(msg)
	if table.getn(MailTo_Log) ~= 0 then
		MailTo_CheckLog(true)
	end
	
	local char_name, realm_name
	_,_,char_name = string.find(msg, "^(%a+)")
	_,_,realm_name = string.find(msg, "^%a+ (.*)")
	
	if realm_name==nil then 
		realm_name = Server 
	end
	
	if char_name==nil then
		if MailTo_InFrame:IsVisible() then
			HideUIPanel(MailTo_InFrame)
			return
		else 
			char_name = Player 
		end
	elseif char_name=='return' then
		local found
		mailto_print(MAILTO_RETURNLIST)
		for player,inbox in pairs(Mail) do
			for ix,item in pairs(inbox) do
				if item.from==Player and item.del==false then
					mailto_print(format(MAILTO_RETURN,item.name,player))
					found = true
				end
			end
		end
		if not found then 
			mailto_print(MAILTO_NORETURN) 
		end
		return
	elseif char_name=='reset' then
		MailTo_Inbox[realm_name] = {}
		MailTo_Mail[realm_name] = {}
		return
	elseif CmdHelp(MT_Help,'inbox',char_name) then 
		return 
	end
	
	if MailFrame:IsVisible() then 
		mailto_print(FCr..MAILTO_MAILOPEN)
	elseif not MailTo_Mail[realm_name] then 
		mailto_print(FCr.."Server:"..realm_name.." not found.")
	elseif not MailTo_Mail[realm_name][char_name] then 
		mailto_print(FCr..MAILTO_MAILCHECK..":"..char_name)
	else
		Mail_name,Mail_server = char_name,realm_name
		UIDropDownMenu_SetWidth(MailTo_InFrame_DropDown, 90)
		UIDropDownMenu_Initialize(MailTo_InFrame_DropDown,MailTo_InFrame_Init,nil,1)
		UIDropDownMenu_SetText(MailTo_InFrame_DropDown, Mail_name)
		MailTo_InFrame_Fill()
		-- SetCenterFrame(MailTo_InFrame,true)
		MailTo_InFrame:Show();
	end
end

--[[
function MailTo_inbox(name,server)
	if table.getn(MailTo_Log) ~= 0 then
		MailTo_CheckLog(true)
	end

    if name=='' then
      if MailTo_InFrame:IsVisible() then
        HideUIPanel(MailTo_InFrame)
        return
      else name = Player end
    end
    if name=='return' then
      local found
      mailto_print(MAILTO_RETURNLIST)
      for player,inbox in pairs(Mail) do
        for ix,item in pairs(inbox) do
		  if item.from==Player and item.del==false then
			mailto_print(format(MAILTO_RETURN,item.name,player))
			found = true
		  end
        end
      end
      if not found then mailto_print(MAILTO_NORETURN) end
      return
    end
    if CmdHelp(MT_Help,'inbox',name) then return end
    if server==nil then server = Server end
    if MailFrame:IsVisible() then mailto_print(FCr..MAILTO_MAILOPEN)
    elseif not MailTo_Mail[server] then mailto_print(FCr.."Server:"..server.." not found.")
    elseif not MailTo_Mail[server][name] then mailto_print(FCr..MAILTO_MAILCHECK)
    else
      Mail_name,Mail_server = name,server
      UIDropDownMenu_SetWidth(MailTo_InFrame_DropDown, 90)
      UIDropDownMenu_Initialize(MailTo_InFrame_DropDown,MailTo_InFrame_Init,nil,1)
      UIDropDownMenu_SetText(MailTo_InFrame_DropDown, Mail_name)
      MailTo_InFrame_Fill()
      -- SetCenterFrame(MailTo_InFrame,true)
      MailTo_InFrame:Show();
    end
end
--]]
local function setColor(tex,exp,new)
      local tc
      exp = exp-time()
      if exp<EXP'short' then tc = TCr
      elseif exp<EXP'long' then tc = TCy
      else tc = new and TCg or TCw end
      tex:SetVertexColor(tc.r,tc.g,tc.b)
end

function MailTo_InFrame_Fill()
    local mail = MailTo_Mail[Mail_server][Mail_name]
    local n = getn(mail)
    local cn,rn,button,tex,exp,tc = 1,1
    for i = 1,56 do
      button = getglobal("MailTo_InFrameCol"..cn.."Item"..rn)
      if i<=n then
        button.mail = mail[i]
        tex = mail[i].tex
        if not tex then
          if mail[i].mon and mail[i].mon>0 then tex = GetCoinIcon(mail[i].mon)
          else tex = defIcon end
        end
        SetItemButtonTexture(button,tex)
        tex = getglobal("MailTo_InFrameCol"..cn.."Item"..rn.."IconTexture")
        setColor(tex,mail[i].exp,mail[i].new)
      else
        exp = MailTo_Inbox[Mail_server][Mail_name].exp
        if i==1 and exp and exp-time()<EXP'icon' then
          SetItemButtonTexture(button,QmkIcon)
          button.mail = {name=MAILTO_EMPTYNEW, exp=exp}
          setColor(MailTo_InFrameCol1Item1IconTexture,exp,true)
        else SetItemButtonTexture(button,''); button.mail = nil end
      end
      cn = cn+1
      if cn>7 then cn=1; rn=rn+1 end
    end
end

function AC_Server_OnClick()
    MailTo_Option.server = MailTo_InFrameServerButton:GetChecked()
end

local function InFrame_Select(self)
    HideDropDownMenu(1)
    local value = self.value
    if value then
      if Mail_name==value.n and Mail_server==value.s then return end
      Mail_name,Mail_server = value.n,value.s
      UIDropDownMenu_SetText(MailTo_InFrame_DropDown, Mail_name)
      MailTo_InFrame_Fill()
    end
end

function MailTo_InFrame_Remove(self)
    local name = self.value
    MailTo_Inbox[name.s][name.n] = nil
    if not next(MailTo_Inbox[name.s]) then MailTo_Inbox[name.s] = nil end
    MailTo_Mail[name.s][name.n] = nil
    if not next(MailTo_Mail[name.s]) then MailTo_Mail[name.s] = nil end
    for i,n in pairs(MailTo_List[Server][Faction]) do
      if n==name.n then
        tremove(MailTo_List[Server][Faction],i)
        break
      end
    end
    if(not next(MailTo_List[name.s][Faction])) then MailTo_List[name.s][Faction] = nil; end
    mailto_print(format(MAILTO_REMOVE2,name.n,name.s))
    HideUIPanel(MailTo_InFrame)
end

local function add_names(server,count,level)
    local Mail,Inbox,text,fc,exp = MailTo_Mail[server],MailTo_Inbox[server]
    for ix2,name in sorted_index(Mail) do
      count = count + 1
      if count>UIDROPDOWNMENU_MAXBUTTONS then return end
      fc = ''
      exp = Inbox[name].exp
      if exp then
        exp = exp-time()
        if exp<EXP'short' then fc = FCr
        elseif exp<EXP'long' then fc = FCy
        elseif Inbox[name].pkg>0 then
          if Mail[name][1].new then fc = FCg end
        elseif exp<EXP'icon' then fc = FCg end
      end
      text = name..fc..' ('..getn(Mail[name])..')'
      info = {text=text;value={n=name,s=server};func=InFrame_Select}
      if name==Mail_name and server==Mail_server then info.checked = 1 end
      UIDropDownMenu_AddButton(info,level)
    end
    return count
end

function MailTo_InFrame_Init(frame, level)
	if level>1 then
		-- DEFAULT_CHAT_FRAME:AddMessage("UIDROPDOWNMENU_MENU_VALUE = "..UIDROPDOWNMENU_MENU_VALUE)
		add_names(UIDROPDOWNMENU_MENU_VALUE,0,2)
		return
		end
	local count = 0
	if Server~=Mail_server or Player~=Mail_name then
		local info = {notCheckable=1,func=MailTo_InFrame_Remove}
		info.value = {n=Mail_name,s=Mail_server}
		info.text = string.format(MAILTO_F_REMOVE,Mail_name)
		UIDropDownMenu_AddButton(info)
		count = 1
	end
	if MailTo_Option.server then
		for ix,server in sorted_index(MailTo_Mail) do
			count = count + 1;
			if count>UIDROPDOWNMENU_MAXBUTTONS-1 then return end
			info = {text=server;value=server;notClickable=1;hasArrow=1}
			if server==Mail_server then info.checked = 1 end
			UIDropDownMenu_AddButton(info)
		end
	else add_names(Server,count) end
end

-- Mouseover of MailTo inbox
function MailTo_InFrame_OnEnter(self)
    local mail = self.mail
    if not mail then return end
    local name,money,del,nr = mail.name, mail.mon, mail.del, mail.nr
    if money==0 and not name then return end -- sanity
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
--    if nr and nr>1 and not strfind(name,'%(%d+%)') then
--      name = name..' ('..nr..')'
--    end
	if name then GameTooltip:SetText(name,1,1,1) end
	for j = 1, ATTACHMENTS_MAX_RECEIVE do
		local attached_item = mail[j]
		local item_name
		if attached_item then 
			if attached_item.name then
				-- mailto_print( item_name )
				if attached_item.count > 1 then
					if attached_item.item_link then
						-- local r, g, b, hex = GetItemQualityColor(attached_item.quality)
						-- DEFAULT_CHAT_FRAME:AddMessage("attached_item.quality = "..attached_item.quality)
		        		GameTooltip:AddDoubleLine("|T"..attached_item.texture..":0|t "..attached_item.item_link, attached_item.count, r, g, b, 1.0, 1.0, 1.0)
					else
		        		GameTooltip:AddDoubleLine("|T"..attached_item.texture..":0|t "..attached_item.name, attached_item.count, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
		        	end
				else
					if attached_item.item_link then
						local r, g, b, hex = GetItemQualityColor(attached_item.quality)
						-- DEFAULT_CHAT_FRAME:AddMessage("attached_item.quality = "..attached_item.quality)
	        			GameTooltip:AddLine("|T"..attached_item.texture..":0|t "..attached_item.item_link, r, g, b)
					else
	        			GameTooltip:AddLine("|T"..attached_item.texture..":0|t "..attached_item.name, 1.0, 1.0, 1.0)
		        	end
				end
			end
		end
	end
		
	if mail.from then GameTooltip:AddLine(MAILTO_FROM..mail.from) end
	if money then tip_money(money) end
	if mail.exp then
	  local exp,msg = mail.exp-time()
	  local c = exp<EXP'short' and {1,0,0} or exp<EXP'long' and {1,1,0} or {0,1,0}
	  local msg = exp<1 and (del and MAILTO_DELETED2 or
							del==false and MAILTO_RETURNED2 or MAILTO_EXPIRED2) or
				  (del and MAILTO_DELETED or del==false and MAILTO_RETURNED or
							MAILTO_EXPIRES2)..SecondsToTime(exp)
	  GameTooltip:AddLine(msg,c[1],c[2],c[3])
	end
    GameTooltip:Show()
end

function MailTo_DropDown_OnLoad(self)
    -- self.tooltip = MAILTO_TOOLTIP
    UIDropDownMenu_Initialize(self:GetParent(), MailTo_ToList_Init)
    UIDropDownMenu_SetAnchor(self:GetParent(), 0, 0, "TOPRIGHT", self:GetName(), "BOTTOMRIGHT")
end

function MailTo_ToList_Init()
	local info = {value=0,notCheckable=1}
	MailTo_Name = SendMailNameEditBox:GetText()
	if MailTo_Name~='' then
		MailTo_Selected = MailTo_InList(MailTo_Name)
		if MailTo_Selected then
			info.text = string.format(MAILTO_F_REMOVE,MailTo_Name)
			info.func = MailTo_ListRemove
		elseif table.getn(MailTo_List[Server][Faction]) < UIDROPDOWNMENU_MAXBUTTONS then
			info.text = string.format(MAILTO_F_ADD,MailTo_Name)
			info.func = MailTo_ListAdd
		else
			info = nil
			mailto_print(FCr..MAILTO_LISTFULL)
		end
		if info then UIDropDownMenu_AddButton(info) end
	end
	for key, name in ipairs(MailTo_List[Server][Faction]) do
		info = {text=name,value=key,func=MailTo_ListSelect}
		if key==MailTo_Selected then info.checked = 1 end
		UIDropDownMenu_AddButton(info)
	end
end

function MailTo_ListSelect(self)
    local value = self.value
    if value then
      MailTo_SavedName = MailTo_List[Server][Faction][value]
      SendMailNameEditBox:SetText(MailTo_SavedName)
      SendMailNameEditBox:HighlightText(0,-1)
      SendMailSubjectEditBox:SetFocus()
    end
end

function MailTo_ListAdd(self, name)
    if not name then name = MailTo_Name end
    tinsert(MailTo_List[Server][Faction],name)
    sort(MailTo_List[Server][Faction])
    mailto_print(name..MAILTO_ADDED)
end

function MailTo_ListRemove()
    tremove(MailTo_List[Server][Faction],MailTo_Selected)
    mailto_print(MailTo_Name..MAILTO_REMOVED)
end

function MailTo_InList(MCname)
    local LCname = string.lower(MCname)
    for key,name in pairs(MailTo_List[Server][Faction]) do
      if LCname==string.lower(name) then return key end
    end
end

function MailTo_CheckLog(all,nodn)
    local found,mail,exp = false
    for i = getn(MailTo_Log),1,-1 do
      local now,log = GetTime(),MailTo_Log[i]
      if log.due>now+DELAY then log.due = now end -- Sanity!
      if log.due<now then
        if not nodn then
          found = true
          MailTo_Format(log)
        end
        if(log.sv and log.to and MailTo_Mail[log.sv][log.to]) then
          exp = time() + (log.cod and COD_EXP or MAIL_EXP)
          mail = {tex=log.tex; name=log.sub; from=log.from; mon=log.mon; exp=exp; nr=log.nr; new=1}
          tinsert(MailTo_Mail[log.sv][log.to],1,mail)
          if(MailTo_Inbox[log.sv][log.to].pkg==0) then
            MailTo_Inbox[log.sv][log.to] = {pkg=1; from=log.from; desc=log.sub; mon=log.mon; exp=exp}
          end
        end
        tremove(MailTo_Log,i)
      elseif(all or Startup and log.sv==Server and (log.to==Player or log.from==Player)) then
        MailTo_Format(MailTo_Log[i])
      end
    end
    if Startup then MailTo_CheckEx() end
    Startup = false
    return found
end

function MailTo_Timer(secs)
    MailTo_Time = secs
    MailTo_Frame:Show() -- Start the timer
end

function MailTo_OnUpdate(self, elapsed)
    MailTo_Time = MailTo_Time-elapsed
    if MailTo_Time>0 then return end
    if MailTo_CheckLog(nil,MailTo_Option.alert) and not MailTo_Option.noding then
      PlaySound(5274)
    end
    local log = MailTo_Log[1]
    if log then
      MailTo_Timer(log.due-GetTime())
    else
      MailTo_Frame:Hide() -- Stop the timer
      MailTo_Time = 0
    end
end

function MailTo_Format(log)
    local ss = log.sv==nil or log.sv==Server
    local to = ss and log.to==Player and FCy..MAILTO_YOU..FCe or log.to
    local from = ss and log.from==Player and FCy..MAILTO_YOU..FCe or log.from
    local now,due = GetTime()
    if log.due>now then
      local min = math.ceil((log.due-now)/60)
      due = format(MAILTO_DUE,min)
    else due = FCg..MAILTO_DELIVERED; end
    local item = FCw..log.item..FCe
    if log.sv and log.sv~=Server then
      item = '('..log.sv..') '..item
    end
    mailto_print(format(MAILTO_SENT,item,to,from,due))
end

local lcs

local function LocList(player,loc,list)
    local txt = ''
    for name,nr in pairs(list) do
      if txt~='' then txt = txt..', ' end
      txt = txt..name..'='..nr
    end
    if txt~='' then mailto_print(format("%s(%s%s%s): %s",player,FCy,loc,FCe,txt)) end
end

local function BagList(bag,cnt,list)
    local name,nr
    for i = 1,cnt do
      if bag[i] and bag[i].Name then
        name = bag[i].Name
        if name and strfind(strlower(name),lcs,1,true) then
          nr = bag[i].Quantity or 1
          if list[name] then nr = nr+list[name] end
          list[name] = nr
        end
      end
    end
    return list
end

function MailTo_locate(str)
    if str=='' then mailto_print(MAILTO_NONAME) return end
    if CmdHelp(MT_Help,'mtl',str) then return end
    local i,j,id,name = strfind(str,"item:(%d+):.+%[(.+)%]")
    if name then str = name end
    lcs = strlower(str)
    local list,s,e,name,txt,nr,CP,data,inbox
    if myProfile then CP = myProfile[Server].Character end
    mailto_print(FCw..format(MAILTO_LOCATE,lcs))
    for x,player in sorted_index(MailTo_Inbox[Server]) do
      inbox = MailTo_Mail[Server][player]
      list = {}
      for ix,data in pairs(inbox) do
        name = data.name
        s,e,txt,nr = strfind(name,"^(.+) %((%d+)%)$")
        if s then name = txt end
        if data.nr then nr = data.nr end
        if nr then
          if strfind(strlower(name),lcs,1,true) then
            if list[name] then nr = nr+list[name] end
            list[name] = tonumber(nr)
          end
        end
      end
      LocList(player,MAILTO_MAIL,list)
      if CP and CP[player] then
        data = CP[player]
        list = {}
        for ix,bag in pairs(data.Inventory) do
          list = BagList(bag.Contents,bag.Slots,list)
        end
        LocList(player,MAILTO_INV,list)
        if data.Bank then
          list = {}
          for ix,bag in pairs(data.Bank) do
            if ix=='Contents' then list = BagList(bag,24,list)
            else list = BagList(bag.Contents,bag.Slots,list) end
          end
        end
        LocList(player,MAILTO_BANK,list)
      end
    end
end

-- Check for new mail
local function print_new(mail,server)
    local nr = 0
    local svr = server and '('..server..') ' or ''
    for name,inbox in pairs(mail) do
      for i,item in pairs(inbox) do
        if item.new then
          mailto_print(format(MAILTO_NEW,svr,item.name,item.from,name))
          nr = nr+1
        end
      end
    end
    return nr
end

function MailTo_new(msg)
    if msg~='' and CmdHelp(MT_Help,'mtn',msg) then return end
    local nr = 0
    if msg=='all' then
      for server,mail in pairs(MailTo_Mail) do
        nr = nr+mailto_print(mail,server)
      end
    else nr = print_new(MailTo_Mail[Server], Server) end
    if nr==0 then mailto_print(MAILTO_NONEW) end
end


--

--[[ function MailTo_OpenBackpack()
	-- DEFAULT_CHAT_FRAME:AddMessage("Mailable_OpenFrame = "..Mailable_OpenFrame)
	if not MailFrame:IsShown() or Mailable_OpenFrame ~= "" or MailTo_Option.noclick then
		MailTo_OpenBackpack_Save()
	end
end --]]
