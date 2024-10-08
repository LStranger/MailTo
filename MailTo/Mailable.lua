-- Mailable Frame handlers
Mailable_GridPixelSize = 300
Mailable_GridMaxSize = 10
Mailable_GridSize = 10
Mailable_OpenFrame = ""
Mailable_LastUpdate = 0
Mailable_LastOnUpdate = 0
Mailable_LastClick = 0
Mailable_UpdateInterval = 0.5
Mailable_CurrentPage = 0
numButton = 0

--
Mailable_FilterList = {}

local function mailto_print(msg)
    SELECTED_CHAT_FRAME:AddMessage("MT: "..msg, 0.0, 0.9, 0.9)
end
   
-- Event handler
function Mailable_Event(frame, event, arg)
	if event=="MAIL_SHOW" and not MailTo_Option.noclick then
		--CheckInbox()
		Mailable_OpenFrame = "Mail"
		Mailable_CurrentPage = 1
		Mailable_Finditems( "MailTo_MailableFrame", false, true )
		frame:RegisterEvent("BAG_UPDATE")
		Mailable_UpdateHint("MailTo_MailableFrame")
		ShowUIPanel(MailTo_MailableFrame)
		
		--if GetInboxNumItems() == 0 then
		--	MailFrameTab2:Click()
		--end
	elseif event=="TRADE_SHOW" and not MailTo_Option.notrade then
		Mailable_OpenFrame = "Trade"
		Mailable_CurrentPage = 1
		Mailable_Finditems( "MailTo_TradableFrame", true, false )
		frame:RegisterEvent("BAG_UPDATE")
		Mailable_UpdateHint("MailTo_TradableFrame")
		ShowUIPanel(MailTo_TradableFrame)
	elseif event=="AUCTION_HOUSE_SHOW" and not MailTo_Option.noauction then
		Mailable_OpenFrame = "Auction"
		Mailable_CurrentPage = 1
		Mailable_Finditems( "MailTo_AuctionableFrame", false, false )
		frame:RegisterEvent("BAG_UPDATE")
		Mailable_UpdateHint("MailTo_AuctionableFrame")
		ShowUIPanel(MailTo_AuctionableFrame)
	-- we will do update/close events even if option is disabled, just in case it was disabled while it was open
	elseif event=="BAG_UPDATE" then
		--DEFAULT_CHAT_FRAME:AddMessage("BAG_UPDATE")
		Mailable_Update(frame)
	elseif event=="MAIL_CLOSED" or (event=="PLAYER_INTERACTION_MANAGER_FRAME_HIDE" and arg==17) then
		Mailable_OpenFrame = ""
		Mailable_CurrentPage = 0
		frame:UnregisterEvent("BAG_UPDATE")
		HideUIPanel(MailTo_MailableFrame)
	elseif event=="TRADE_CLOSED" then
		Mailable_OpenFrame = ""
		Mailable_CurrentPage = 0
		frame:UnregisterEvent("BAG_UPDATE")
		HideUIPanel(MailTo_TradableFrame)
	elseif event=="AUCTION_HOUSE_CLOSED" or (event=="PLAYER_INTERACTION_MANAGER_FRAME_HIDE" and arg==21) then
		Mailable_OpenFrame = ""
		Mailable_CurrentPage = 0
		frame:UnregisterEvent("BAG_UPDATE")
		HideUIPanel(MailTo_AuctionableFrame)
	elseif event=="ITEM_LOCK_CHANGED" then
		--DEFAULT_CHAT_FRAME:AddMessage("ITEM_LOCK_CHANGED")
		if Mailable_OpenFrame == "Mail" then
			Mailable_Finditems( "MailTo_MailableFrame", false, true )
		elseif Mailable_OpenFrame == "Trade" then
			Mailable_Finditems( "MailTo_TradableFrame", true, false )
		elseif Mailable_OpenFrame == "Auction" then
			Mailable_Finditems( "MailTo_AuctionableFrame", false, false )
		end
	end
end

function Mailable_Finditems( frame, trade, mail )
	-- Scan invendory for mailable items
	-- "Soulbound" or "Quest Item" in their 2nd line in tooltip will be excluded
	-- if trade is false, "Conjured Items" will also be excluded
	local row, col
	local b, s
	
	Mailable_GridSize = 10
	if MailTo_Option.grid then
		Mailable_GridSize = MailTo_Option.grid
	end
	local Mailable_ButtonSize = Mailable_GridPixelSize / Mailable_GridSize

	for row = 1, Mailable_GridMaxSize, 1 do
		b = getglobal(frame.."GridRow"..row)
		b:SetHeight(Mailable_ButtonSize)
		
		for col = 1, Mailable_GridMaxSize, 1 do
			--DEFAULT_CHAT_FRAME:AddMessage("Clearing "..frame.."GridRow"..row.."Item"..col)
			b = getglobal(frame.."GridRow"..row.."Item"..col)
			if (row > Mailable_GridSize) or (col > Mailable_GridSize) then
				b:Disable()
				b:Hide()
			else
				-- using nil for texture does not work anymore
				--local tex = b:CreateTexture(nil, nil, "UIPanelButtonUpTexture")
				--b:SetNormalTexture(tex)
				SetItemButtonTexture(b, nil)
				SetItemButtonDesaturated(b, false)
	
				s = getglobal(frame.."GridRow"..row.."Item"..col.."CountString")
				s:SetText( "" )
				
				b:SetAttribute("itemCount", nil)
				b:SetAttribute("container", nil)
				b:SetAttribute("slot", nil)
				b:SetWidth(Mailable_ButtonSize)
				b:SetHeight(Mailable_ButtonSize)
				
				--s = getglobal(frame.."GridRow"..row.."Item"..col.."NormalTexture")
				--s:SetWidth(Mailable_ButtonSize)
				--s:SetHeight(Mailable_ButtonSize)
				
				b:Enable()
				b:Show()
			end
		end
	end
	
	numButton = 0
	for container = 0, NUM_TOTAL_EQUIPPED_BAG_SLOTS, 1 do
		for slot = 1, C_Container.GetContainerNumSlots(container), 1 do
			local info = C_Container.GetContainerItemInfo(container, slot)
			local skipThisItem = false
			if info and info.iconFileID then
				local tooltip = C_TooltipInfo.GetBagItem(container, slot)
				if tooltip then
					for i,v in ipairs(tooltip.lines) do
							local theLineTxt = v.leftText
							local bound = v.bonding
							if bound == 3 then -- BoP
								skipThisItem = true
								-- print("MT: "..info.hyperlink.." is soulbound")
								-- DEFAULT_CHAT_FRAME:AddMessage("is soulbound")
							elseif bound == 2 and not mail then -- BoA
								skipThisItem = true
							elseif bound == 0 then -- Quest
								skipThisItem = true
								-- print("MT: "..info.hyperlink.." is a quest item")
								-- DEFAULT_CHAT_FRAME:AddMessage("is quest item")
							-- any BoP in bag cannot be not soulbound already
							-- therefore we don't check for ITEM_BIND_ON_PICKUP here
							elseif theLineTxt == ITEM_CONJURED and not trade then
								skipThisItem = true
								-- print("MT: "..info.hyperlink.." is conjured")
								-- DEFAULT_CHAT_FRAME:AddMessage("is conjured")
							end
					end
				end

				if not skipThisItem then
					-- mailto_print( gsub(sLink, "\124", "\124\124") )
					if not (Mailable_FilterList[ sType ] or Mailable_FilterList[ sLink ]) then
						numButton = numButton + 1
						-- DEFAULT_CHAT_FRAME:AddMessage("numButton = "..numButton)
						if ((Mailable_CurrentPage - 1) * Mailable_GridSize * Mailable_GridSize < numButton) and
						    (numButton <= Mailable_CurrentPage * Mailable_GridSize * Mailable_GridSize) then
							local pageButton = numButton - (Mailable_CurrentPage - 1) * Mailable_GridSize * Mailable_GridSize
							_,_,row = string.find(tostring((pageButton + Mailable_GridSize - 1) / Mailable_GridSize), "^(%d+)")
							col = tostring((pageButton + Mailable_GridSize - 1) % Mailable_GridSize + 1)
							-- DEFAULT_CHAT_FRAME:AddMessage("Item "..the1stLineTxt.." at "..container..", "..slot.." is "..the2ndLineTxt)
							-- DEFAULT_CHAT_FRAME:AddMessage("Button "..row..", "..col)
							
							b = getglobal(frame.."GridRow"..row.."Item"..col)
							SetItemButtonTexture(b, info.iconFileID)
							SetItemButtonDesaturated(b, info.isLocked)

							s = getglobal(frame.."GridRow"..row.."Item"..col.."CountString")
							if info.stackCount > 1 then
								s:SetText( tostring(info.stackCount) )
								b:SetAttribute("itemCount", info.stackCount)
							else
								s:SetText( "" )
								b:SetAttribute("itemCount", nil)
							end

							b:SetAttribute("container", container)
							b:SetAttribute("slot", slot)
						end
					end
				end



			end
		end
	end
--[[
	--DEFAULT_CHAT_FRAME:AddMessage("Negative ID")
	--- support of keyring (and other bags that has negative id)
	for container = KEYRING_CONTAINER, KEYRING_CONTAINER, -1 do
		for slot = 1, GetContainerNumSlots(container), 1 do
		--for slot = 1, 5, 1 do
			local ItemLink = GetContainerItemLink(container, slot)
			if ItemLink then 
				--DEFAULT_CHAT_FRAME:AddMessage("Checking "..container..", "..slot)
				--DEFAULT_CHAT_FRAME:AddMessage("ItemLink = "..ItemLink)
			
				MailTo_MailableHiddenTooltip:ClearLines()
				MailTo_MailableHiddenTooltip:SetOwner( WorldFrame, "ANCHOR_NONE" );
				--MailTo_MailableHiddenTooltip:SetBagItem(container, slot)
				MailTo_MailableHiddenTooltip:SetHyperlink(ItemLink)
				
				--local ttnumlines = MailTo_MailableHiddenTooltip:NumLines()
				--DEFAULT_CHAT_FRAME:AddMessage("ttnumlines = "..ttnumlines)
				local the1stLineObj = getglobal("MailTo_MailableHiddenTooltipTextLeft1")
				local the1stLineTxt = the1stLineObj:GetText()
				local the2ndLineObj = getglobal("MailTo_MailableHiddenTooltipTextLeft2")
				local the2ndLineTxt = the2ndLineObj:GetText()
				--if the1stLineTxt then DEFAULT_CHAT_FRAME:AddMessage("the1stLineTxt = "..the1stLineTxt) end
				--if the2ndLineTxt then DEFAULT_CHAT_FRAME:AddMessage("the2ndLineTxt = "..the2ndLineTxt) end
				if the1stLineTxt then
					if not the2ndLineTxt then the2ndLineTxt = "" end
					if 	(the2ndLineTxt ~= ITEM_SOULBOUND) and 
						(the2ndLineTxt ~= ITEM_BIND_QUEST) and 
						(the2ndLineTxt ~= ITEM_BIND_ON_PICKUP) and 
						((the2ndLineTxt ~= ITEM_CONJURED) or trade) then
						
						local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(GetContainerItemLink(container, slot))
						if not (Mailable_FilterList[ sType ] and Mailable_FilterList[ sLink ]) then	
							numButton = numButton + 1
							--DEFAULT_CHAT_FRAME:AddMessage("numButton = "..numButton)
							if 	((Mailable_CurrentPage - 1) * Mailable_GridSize * Mailable_GridSize < numButton) and  
								(numButton <= Mailable_CurrentPage * Mailable_GridSize * Mailable_GridSize) then
								
								local texture, itemCount, locked, quality, readable = GetContainerItemInfo(container, slot)
								local pageButton = numButton - (Mailable_CurrentPage - 1) * Mailable_GridSize * Mailable_GridSize
								_,_,row = string.find(tostring((pageButton + Mailable_GridSize - 1) / Mailable_GridSize), "^(%d+)")
								col = tostring((pageButton + Mailable_GridSize - 1) % Mailable_GridSize + 1)
								--DEFAULT_CHAT_FRAME:AddMessage("Item "..the1stLineTxt.." at "..container..", "..slot.." is "..the2ndLineTxt)
								--DEFAULT_CHAT_FRAME:AddMessage("Button "..row..", "..col)
								
								b = getglobal(frame.."GridRow"..row.."Item"..col)
								--b:SetNormalTexture( texture )
								SetItemButtonTexture(b, texture)
								SetItemButtonDesaturated(b, locked)
			
								s = getglobal(frame.."GridRow"..row.."Item"..col.."CountString")
								if itemCount > 1 then
									s:SetText( tostring(itemCount) )
									b:SetAttribute("itemCount", itemCount)
								else
									s:SetText( "" )
									b:SetAttribute("itemCount", nil)
								end
								
								b:SetAttribute("container", container)
								b:SetAttribute("slot", slot)
							end
						end
					end
				end
			end
		end
	end
]]--
	b = getglobal(frame.."PrevPageButton")
	if Mailable_CurrentPage > 1 then
		b:Enable()
	else
		b:Disable()
	end
	
	b = getglobal(frame.."NextPageButton")
	if numButton > Mailable_CurrentPage * Mailable_GridSize * Mailable_GridSize then
		b:Enable()
	else
		b:Disable()
	end
end

-- UI handler
function Mailable_PrevPage(b, click)
	if Mailable_CurrentPage > 1 then
		Mailable_CurrentPage = Mailable_CurrentPage - 1
	end
	--DEFAULT_CHAT_FRAME:AddMessage("Mailable_CurrentPage = "..Mailable_CurrentPage)
	Mailable_Update(b:GetParent())
end

function Mailable_NextPage(b, click)
	if numButton > Mailable_CurrentPage * Mailable_GridSize * Mailable_GridSize then
		Mailable_CurrentPage = Mailable_CurrentPage + 1
	end
	--DEFAULT_CHAT_FRAME:AddMessage("Mailable_CurrentPage = "..Mailable_CurrentPage)
	Mailable_Update(b:GetParent())
end

function Mailable_Update(frame)
	if GetTime() - Mailable_LastUpdate > Mailable_UpdateInterval then
		Mailable_LastUpdate = GetTime()
		--DEFAULT_CHAT_FRAME:AddMessage("BAG_UPDATE")
		--DEFAULT_CHAT_FRAME:AddMessage("name = "..MailTo_MailableFrame:GetName())
		
		if Mailable_OpenFrame == "Mail" then
			Mailable_Finditems( "MailTo_MailableFrame", false, true )
		elseif Mailable_OpenFrame == "Trade" then
			Mailable_Finditems( "MailTo_TradableFrame", true, false )
		elseif Mailable_OpenFrame == "Auction" then
			Mailable_Finditems( "MailTo_AuctionableFrame", false, false )
		end
	end
end

function Mailable_OnUpdate(frame, arg)
	if GetTime() - Mailable_LastOnUpdate > Mailable_UpdateInterval then
		Mailable_LastOnUpdate = GetTime()
		--DEFAULT_CHAT_FRAME:AddMessage("UPDATE Mailable_OpenFrame = "..Mailable_OpenFrame)
		
		if Mailable_OpenFrame == "Mail" then
			Mailable_UpdateHint( "MailTo_MailableFrame" )
		elseif Mailable_OpenFrame == "Trade" then
			Mailable_UpdateHint( "MailTo_TradableFrame" )
		elseif Mailable_OpenFrame == "Auction" then
			Mailable_UpdateHint( "MailTo_AuctionableFrame", true )
		end
	end
end

function Mailable_UpdateHint(frame)
	--DEFAULT_CHAT_FRAME:AddMessage("Hint UPDATE")
	local hint_left = getglobal(frame.."HintTextL")
	local hint_right = getglobal(frame.."HintTextR")
	
	if IsShiftKeyDown() then
		-- if ChatFrameEditBox:IsShown() then
		local activeWindow = ChatEdit_GetActiveWindow(); 
		if ( activeWindow ) then 
			hint_left:SetText( MAILTO_SHIFT_CHAT_L )
		else
			hint_left:SetText( MAILTO_SHIFT_L )
		end		
		hint_right:SetText( MAILTO_SHIFT_R )
	else
		if frame == "MailTo_MailableFrame" then
			hint_left:SetText( MAILTO_MAILABLE_L )
			hint_right:SetText( MAILTO_MAILABLE_R )
		elseif frame == "MailTo_TradableFrame" then
			hint_left:SetText( MAILTO_TRADABLE_L )
			hint_right:SetText( MAILTO_TRADABLE_R )
		elseif frame == "MailTo_AuctionableFrame" then
			hint_left:SetText( MAILTO_AUCTIONABLE_L )
			hint_right:SetText( MAILTO_AUCTIONABLE_R )
		end
		
		if MailTo_Option.noshift then 
			hint_right:SetText( "" )
		end
	end
end

function Mailable_OnEnter(b)
	local container = b:GetAttribute("container")
	local slot = b:GetAttribute("slot")
	local itemCount = b:GetAttribute("itemCount")
	if container and slot then
		--DEFAULT_CHAT_FRAME:AddMessage("Hover Button "..container..", "..slot)
		MailTo_MailableTooltip:SetOwner(b, ANCHOR_NONE)
		if container < 0 then
			local ItemLink = C_Container.GetContainerItemLink(container, slot)
			MailTo_MailableTooltip:SetHyperlink(ItemLink)
		else
			MailTo_MailableTooltip:SetBagItem(container, slot)
		end
		if itemCount then
			MailTo_MailableTooltip:AddLine("x"..itemCount)
		end
		MailTo_MailableTooltip:Show()
	end
end

function Mailable_OnClick(b, click, down)
	local container = b:GetAttribute("container")
	local slot = b:GetAttribute("slot")
	if container and slot then
		--DEFAULT_CHAT_FRAME:AddMessage(click.." "..container..", "..slot)
		if CursorHasItem() then 
			C_Container.PickupContainerItem(container, slot)
			ClearCursor() 
			return
		end
	
		if IsShiftKeyDown() then
			--DEFAULT_CHAT_FRAME:AddMessage("IsShiftKeyDown() = true")
			if click == "RightButton" then
				C_Container.PickupContainerItem(container, slot)
			else
				local ItemLink = C_Container.GetContainerItemLink(container, slot)
				
				-- if ChatFrameEditBox:IsShown() then
				-- 	ChatEdit_InsertLink(ItemLink)
				local activeWindow = ChatEdit_GetActiveWindow(); 
				if ( activeWindow ) then 
					activeWindow:Insert(ItemLink); 
				else
					local info = C_Container.GetContainerItemInfo(container, slot)
					if ( info and not info.isLocked ) then
						self.SplitStack = function(button, split)
							SplitContainerItem(button:GetAttribute("container"), button:GetAttribute("slot"), split)
						end
						OpenStackSplitFrame(item.stackCount, self, "BOTTOMRIGHT", "TOPRIGHT")
					end
				end
			end
		else
			--DEFAULT_CHAT_FRAME:AddMessage("IsShiftKeyDown() = false")
			if not SpellIsTargeting() and GetTime() - Mailable_LastClick > Mailable_UpdateInterval then
				Mailable_LastClick = GetTime()
				
				if Mailable_OpenFrame == "Mail" then
					MailFrameTab_OnClick(nil, 2)
					C_Container.PickupContainerItem(container, slot)
					ClickSendMailItemButton()
					if click == "RightButton" and not MailTo_Option.noshift then
						SendMailMailButton:Click()
					end
				elseif Mailable_OpenFrame == "Trade" then
					if click == "RightButton" and not MailTo_Option.noshift then
						TradeFrameTradeButton:Click()
					else
						C_Container.PickupContainerItem(container, slot)
						local slot = TradeFrame_GetAvailableSlot()
						if slot then ClickTradeButton(slot) end
					end
				elseif Mailable_OpenFrame == "Auction" then
					if click == "RightButton" and not MailTo_Option.noshift then
						if AuctionatorTabs_Selling ~= nil then
							-- support for Auctionatr addon
							AuctionatorTabs_Selling:Click()
							C_Container.PickupContainerItem(container,slot)
							AuctionHouseFrame.AuctionatorSellingFrame.SaleItemFrame.Icon:OnReceiveDrag()
						else
							-- use standard Sell tab
							AuctionHouseFrame.SellTab:OnClick()
							C_Container.PickupContainerItem(container,slot)
							AuctionHouseFrame.ItemSellFrame:OnOverlayClick()
						end
					else
						AuctionHouseFrame.BuyTab:OnClick()
						AuctionSearch(C_Container.GetContainerItemLink(container, slot))
					end
				end
			end
			if CursorHasItem() then ClearCursor() end
		end
	else
		if CursorHasItem() then 
			container, slot = FindEmptySlot()
			if container and slot then
				C_Container.PickupContainerItem(container, slot)
				ClearCursor() 
				return
			else
				ClearCursor() 
			end
		end
	end
end

function FindEmptySlot()
	for container = 0, 4, 1 do
		for slot = 1, C_Container.GetContainerNumSlots(container), 1 do
			--DEFAULT_CHAT_FRAME:AddMessage("Checking "..container..", "..slot)
			local info = C_Container.GetContainerItemInfo(container, slot)
			if info and not info.iconFileID then
				return container, slot
			end
		end
	end
end
--[[
function Mailable_Test(container, slot)
	MailTo_MailableHiddenTooltip:ClearLines()
	MailTo_MailableHiddenTooltip:SetBagItem(container, slot)
	for i=1,MailTo_MailableHiddenTooltip:NumLines() do 
		local mytext=getglobal("MailTo_MailableHiddenTooltipTextLeft"..i); 
		local text=mytext:GetText(); 
		DEFAULT_CHAT_FRAME:AddMessage(text); 
		
		--mytext=getglobal("GameTooltipTextRight"..i); 
		--text=mytext:GetText(); 
		--DEFAULT_CHAT_FRAME:AddMessage(text); 
	end
end
]]--