---@meta _

---@class ELib
local ELib = {}

---@class ELibBaseMethods
local ELibBaseMethods = {}

---@generic self
---@param self self
---@param point FramePoint
---@param relativeFrame ScriptRegion|string
---@param relativePoint FramePoint
---@param x number
---@param y number
---@return self
function ELibBaseMethods:Point(point, relativeFrame, relativePoint, x, y) end

---@generic self
---@param self self
---@param point FramePoint
---@param relativeFrame ScriptRegion|string
---@param x number
---@param y number
---@return self
function ELibBaseMethods:Point(point, relativeFrame, x, y) end

---@generic self
---@param self self
---@param point FramePoint
---@param relativeFrame ScriptRegion|string
---@param relativePoint FramePoint
---@return self
function ELibBaseMethods:Point(point, relativeFrame, relativePoint) end

---@generic self
---@param self self
---@param point FramePoint
---@param x number
---@param y number
---@return self
function ELibBaseMethods:Point(point, x, y) end

---@generic self
---@param self self
---@param point FramePoint
---@param relativeFrame ScriptRegion|string
---@return self
function ELibBaseMethods:Point(point, relativeFrame) end

---@generic self
---@param self self
---@param point FramePoint
---@return self
function ELibBaseMethods:Point(point) end

---@generic self
---@param self self
---@param x number
---@param y number
---@return self
function ELibBaseMethods:Point(x, y) end

---@generic self
---@param self self
---@param point FramePoint
---@param relativeFrame ScriptRegion|string
---@param relativePoint FramePoint
---@param x number
---@param y number
---@return self
function ELibBaseMethods:NewPoint(point, relativeFrame, relativePoint, x, y) end

---@generic self
---@param self self
---@param point FramePoint
---@param relativeFrame ScriptRegion|string
---@param x number
---@param y number
---@return self
function ELibBaseMethods:NewPoint(point, relativeFrame, x, y) end

---@generic self
---@param self self
---@param point FramePoint
---@param relativeFrame ScriptRegion|string
---@param relativePoint FramePoint
---@return self
function ELibBaseMethods:NewPoint(point, relativeFrame, relativePoint) end

---@generic self
---@param self self
---@param point FramePoint
---@param x number
---@param y number
---@return self
function ELibBaseMethods:NewPoint(point, x, y) end

---@generic self
---@param self self
---@param point FramePoint
---@param relativeFrame ScriptRegion|string
---@return self
function ELibBaseMethods:NewPoint(point, relativeFrame) end

---@generic self
---@param self self
---@param point FramePoint
---@return self
function ELibBaseMethods:NewPoint(point) end

---@generic self
---@param self self
---@param x number
---@param y number
---@return self
function ELibBaseMethods:NewPoint(x, y) end

---@generic self
---@param self self
---@param width number
---@param height number
---@return self
function ELibBaseMethods:Size(width,height) end

---@generic self
---@param self self
---@param scale number
---@return self
function ELibBaseMethods:Scale(scale) end

---@generic self
---@param self self
---@param func function
---@return self
function ELibBaseMethods:OnClick(func) end

---@generic self
---@param self self
---@param func function
---@param disableFirstRun boolean?
---@return self
function ELibBaseMethods:OnShow(func, disableFirstRun) end

---@generic self
---@param self self
---@param func function
---@param ... any # vararg will be passed to the function
---@return self
function ELibBaseMethods:Run(func, ...) end

---@generic self
---@param self self
---@param bool boolean
---@return self
function ELibBaseMethods:Shown(bool) end

---@generic self
---@param self self
---@param func function
---@return self
function ELibBaseMethods:OnEnter(func) end

---@generic self
---@param self self
---@param func function
---@return self
function ELibBaseMethods:OnLeave(func) end

---@generic self
---@param self self
---@param func function
---@return self
function ELibBaseMethods:OnUpdate(func) end

function ELib.ModObjFuncs(self, ...) end

---@class ELibBorder : Frame
local Border = {}

--- Create a border around a parent frame
---@param parent Frame|Texture The parent frame to which the border will be added or texture which parent will be used
---@param size number The size (thickness) of the border
---@param colorR number? The red component of the border color (0-1)
---@param colorG number? The green component of the border color (0-1)
---@param colorB number? The blue component of the border color (0-1)
---@param colorA number? The alpha (transparency) component of the border color (0-1)
---@param outside number? Whether the border should be outside the parent frame
---@param layerCounter number? The layer counter for the border
---@return ELibText
function ELib:Border(parent, size, colorR, colorG, colorB, colorA, outside, layerCounter) end



---@class ELibText : FontString, ELibBaseMethods
local Text = {}

--- Create a text frame
---@param parent Frame The parent frame to which the text will be added
---@param text string The text to display
---@param size number The size of the text
---@param template string? The template to use for the text
---@return ELibText
function ELib:Text(parent, text, size, template) end

--- Set the font of the text
---@generic self
---@param self self
---@param ... any The font parameters
---@return self
function Text:Font(...) end

--- Set the color of the text, white if all args are ommited
---@generic self
---@param self self
---@param r number? The red component of the color
---@param g number? The green component of the color
---@param b number? The blue component of the color
---@return self
function Text:Color(r, g, b) end

--- Add or remove shadow from the text
---@generic self
---@param self self
---@param bool boolean Whether to remove the shadow
---@return self
function Text:Shadow(bool) end

--- Add or remove outline from the text
---@generic self
---@param self self
---@param bool boolean Whether to remove the outline
---@return self
function Text:Outline(bool) end

--- Set the text justification to left
---@generic self
---@param self self
---@return self
function Text:Left() end

--- Set the text justification to center
---@generic self
---@param self self
---@return self
function Text:Center() end

--- Set the text justification to right
---@generic self
---@param self self
---@return self
function Text:Right() end

--- Set the text vertical alignment to top
---@generic self
---@param self self
---@return self
function Text:Top() end

--- Set the text vertical alignment to middle
---@generic self
---@param self self
---@return self
function Text:Middle() end

--- Set the text vertical alignment to bottom
---@generic self
---@param self self
---@return self
function Text:Bottom() end

--- Set the font size of the text
---@generic self
---@param self self
---@param size number The size of the font
---@return self
function Text:FontSize(size) end

--- Add a tooltip if the text is cropped
---@generic self
---@param self self
---@param anchor string The anchor point for the tooltip
---@param isBut boolean Whether the text is a button
---@return self
function Text:Tooltip(anchor, isBut) end

---@generic self
---@param self self
---@param num number
---@return self
function Text:MaxLines(num) end



---@class ELibButton : Button, ELibBaseMethods
---@field GetTextObj fun(self : ELibButton): FontString
---@field FontSize fun(self : ELibButton, size: number): self
---@field SetVertical fun(self : ELibButton): self
local Button = {}

--- Create a button
---@param parent Frame The parent frame to which the button will be added
---@param text string The text to display on the button
---@param template string|number? The template to use for the button
---@return ELibButton
function ELib:Button(parent, text, template) end

--- -> [add tooltip]
---@generic self
---@param self self
---@param str string
---@return self
function Button:Tooltip(str) end

---@generic self
---@param self self
---@param textFunc fun(self) : string?
---@return self
function Button:Tooltip(textFunc) end

---@class Check : CheckButton, ELibBaseMethods
local Check = {}

--- Create a check button
---@param parent Frame The parent frame to which the check button will be added
---@param text string The text to display next to the check button
---@param state boolean? The initial state of the check button (checked or unchecked)
---@param template string? The template to use for the check button
---@return Check
function ELib:Check(parent, text, state, template) end

--- Add a tooltip to the check button
---@generic self
---@param self self
---@param str string The tooltip text
---@return self
function Check:Tooltip(str) end

--- Move the text to the left side of the check button
---@generic self
---@param self self
---@param relativeX number The relative X position for the text (default is 2)
---@return self
function Check:Left(relativeX) end

--- Set the text size of the check button
---@generic self
---@param self self
---@param size number The size of the text
---@return self
function Check:TextSize(size) end

---@generic self
---@param self self
---@param isBorderInsteadText boolean
---@return self
function Check:ColorState(isBorderInsteadText) end

--- Add red/green colors for text or borders based on the state
---@generic self
---@param self self
---@param isBorderInsteadText boolean Whether to color the borders instead of the text
---@return self
function Check:AddColorState(isBorderInsteadText) end

--- Set the text to be clickable
---@generic self
---@param self self
---@return self
function Check:TextButton() end



---@class ELibDropDown : Frame, ELibBaseMethods
---@field Enable fun(self : ELibDropDown): self
---@field Disable fun(self : ELibDropDown): self
---@field SetWidth fun(self : ELibDropDown, width : number): self
---@field _SetWidth fun(self : ELibDropDown, width)
---@field List table
local DropDown = {}

--- Create a dropdown menu
---@param parent Frame The parent frame to which the dropdown menu will be added
---@param width number The width of the dropdown menu
---@param lines number? The amount of lines to display in the dropdown menu -1 will display all lines
---@param template string? The template to use for the dropdown menu
---@return ELibDropDown
function ELib:DropDown(parent, width, lines, template) end

--- Set the text of the dropdown menu
---@generic self
---@param self self
---@param str string The text to set
---@return self
function DropDown:SetText(str) end

--- Add a tooltip to the dropdown menu
---@generic self
---@param self self
---@param str string The tooltip text
---@return self
function DropDown:Tooltip(str) end

--- Add text to the left side of the dropdown menu
---@generic self
---@param self self
---@param text string The text to add
---@return self
function DropDown:AddText(text) end

---@generic self
---@param self self
---@param text string
---@param size number?
---@param extra_func fun(self:ELibText)
---@return self
function DropDown:TextInside(text,size,extra_func) end

--- Set the width of the dropdown menu
---@generic self
---@param self self
---@param width number The width to set
---@return self
function DropDown:Size(width) end

--- -> Set colors for the border; [true: red; false: default]
---@generic self
---@param self self
---@param bool boolean
---@return self
function DropDown:ColorBorder(bool) end

---@generic self
---@param self self
---@param cR number
---@param cG number
---@param cB number
---@param cA number
---@return self
function DropDown:ColorBorder(cR, cG, cB, cA) end

--- calls PreUpdate if it exists and scans .List for the value
---@param value any
---@param key any defaults to "arg1"
---@param includeSubMenus boolean?
function DropDown:AutoText(value, key, includeSubMenus) end



---@class ELibDropDownButton : ELibButton, ELibBaseMethods
local DropDownButton = {}

--- Create a dropdown button
---@param parent Frame The parent frame to which the dropdown button will be added
---@param defText string The default text to display on the dropdown button
---@param dropDownWidth number The width of the dropdown menu
---@param lines number? The lines (options) to display in the dropdown menu
---@param template string? The template to use for the dropdown button
---@return ELibDropDownButton
function ELib:DropDownButton(parent, defText, dropDownWidth, lines, template) end



---@class ELibEdit : EditBox, ELibBaseMethods
local Edit = {}

--- Create an edit box
---@param parent Frame The parent frame to which the edit box will be added
---@param maxLetters number? The maximum number of letters allowed in the edit box
---@param onlyNum boolean? Whether the edit box should only accept numeric input
---@param template string? The template to use for the edit box
---@return ELibEdit
function ELib:Edit(parent, maxLetters, onlyNum, template) end

--- -> SetText(str)
---@generic self
---@param self self
---@param str string
---@return self
function Edit:Text(str) end

--- -> [add tooltip]
---@generic self
---@param self self
---@param str string|fun(self) : string?
---@return self
function Edit:Tooltip(str) end

--- -> SetScript("OnTextChanged",func)
---@generic self
---@param self self
---@param func fun(self : ELibEdit, isUser: boolean)
---@return self
function Edit:OnChange(func) end

--- -> SetScript("OnFocusGained",gained) SetScript("OnEditFocusLost",lost)
---@generic self
---@param self self
---@param gained function
---@param lost function
---@return self
function Edit:OnFocus(gained, lost) end

--- -> Add an icon inside the edit box
---@generic self
---@param self self
---@param texture string|number
---@param size number [optional]
---@param offset number [optional]
---@return self
function Edit:InsideIcon(texture, size, offset) end

--- -> Add a search icon inside the edit box
---@generic self
---@param self self
---@param size number?
---@return self
function Edit:AddSearchIcon(size) end

--- -> Add text at the left of the edit box
---@generic self
---@param self self
---@param text string
---@param size number?
---@return self
function Edit:LeftText(text, size) end

--- -> Add text at the right of the edit box
---@generic self
---@param self self
--- @param text string
--- @param size number?
--- @return self
function Edit:RightText(text, size) end

--- -> Add text at the top left of the edit box, conflicts with :LeftText
---@generic self
---@param self self
---@param text string
---@param size number?
function Edit:TopText(text, size) end

--- -> Add text inside the edit box while not in focus
---@generic self
---@param self self
---@param text string
---@return self
function Edit:BackgroundText(text) end

--- -> Set colors for the border; [true: red; false: default]
---@generic self
---@param self self
---@param bool boolean
---@return self
function Edit:ColorBorder(bool) end

---@generic self
---@param self self
---@param cR number
---@param cG number
---@param cB number
---@param cA number
---@return self
function Edit:ColorBorder(cR, cG, cB, cA) end

---@return number highlightStart
---@return number highlightEnd
function Edit:GetTextHighlight() end

--- -> Add text background after the main text
---@generic self
---@param self self
---@param text string
---@return self
function Edit:ExtraText(text) end

---@generic self
---@param self self
---@param size number
---@return self
function Edit:FontSize(size) end



---@class ELibFrame : Frame, ELibBaseMethods
local Frame = {}

--- Create a frame
---@generic T
---@param parent? any The parent frame, defaults to UIParent
---@param template? `T` | Template The template to use for the frame
---@return ELibFrame|T frame
function ELib:Frame(parent, template) end

--- Create and/or set a texture
---@generic self
---@param self self
---@param texture string The texture to set
---@param layer DrawLayer The layer to set the texture on
---@return self
function Frame:Texture(texture, layer) end

--- Create and/or set a texture with color
---@generic self
---@param self self
---@param cR number The red component of the color
---@param cG number The green component of the color
---@param cB number The blue component of the color
---@param cA number The alpha component of the color
---@param layer DrawLayer The layer to set the texture on
---@return self
function Frame:Texture(cR, cG, cB, cA, layer) end

--- Add a point to the texture
---@generic self
---@param self self
---@param ... any The points to add to the texture
---@return self
function Frame:TexturePoint(...) end

--- Set the size of the texture
---@generic self
---@param self self
---@param width number
---@param height number
---@return self
function Frame:TextureSize(width, height) end



---@class ELibIcon : Frame, ELibBaseMethods
---@field Tooltip fun(self,text): self
local Icon = {}

--- Create an icon
---@param parent Frame The parent frame to which the icon will be added
---@param textureIcon string The texture to use for the icon
---@param size number The size of the icon
---@param isButton boolean Whether the icon should behave as a button
---@return ELibIcon
function ELib:Icon(parent, textureIcon, size, isButton) end

--- Set the texture of the icon
---@generic self
---@param self self
---@param texture string|number
---@return self
function Icon:Icon(texture) end

---@generic self
---@param self self
---@param cR number
---@param cG number
---@param cB number
---@param cA number
---@return self
function Icon:Icon(cR, cG, cB, cA) end



---@class ELibListButton : Frame, ELibBaseMethods
local ListButton = {}

--- Create a list button
---@param parent Frame The parent frame to which the list button will be added
---@param text string The text to display on the button
---@param width number The width of the button
---@param lines number The number of lines to display
---@param template string? The template to use for the button
---@return ELibListButton
function ELib:ListButton(parent, text, width, lines, template) end

--- Move text to the left side
---@generic self
---@param self self
---@return self
function ListButton:Left() end



---@class ELibMultiEdit : ELibScrollFrame, ELibBaseMethods
---@field EditBox ELibEdit
---@field HideScrollOnNoScroll fun(self): self
local MultiEdit = {}

--- Create a multi-line edit box
---@param parent Frame The parent frame to which the multi-edit box will be added
---@return ELibMultiEdit
function ELib:MultiEdit(parent) end

--- Set the script for the "OnTextChanged" event
---@generic self
---@param self self
---@param func function The function to call when the text changes
---@return self
function MultiEdit:OnChange(func) end

--- Set the font for the multi-edit box
---@generic self
---@param self self
---@param ... any The font parameters to set
---@return self
function MultiEdit:Font(...) end

--- Enable hyperlinks in the text (spells, items, etc.)
---@generic self
---@param self self
---@return self
function MultiEdit:Hyperlinks() end

--- Set the scroll value to the minimum (scroll to top)
---@generic self
---@param self self
---@return self
function MultiEdit:ToTop() end

--- Get the highlight positions in the text
---@return number highlightStart
---@return number highlightEnd
function MultiEdit:GetTextHighlight() end

--- Add colored text syntax
---@generic self
---@param self self
---@param syntax "lua" | string | nil
---@return self
function MultiEdit:SetSyntax(syntax) end

--- Add an indicator at the bottom right that shows current line number:current column number
---@generic self
---@param self self
---@return self
function MultiEdit:AddPosText() end

---@generic self
---@param self self
---@param func function
---@return self
function MultiEdit:OnCursorChanged(func) end

---@generic self
---@param self self
---@param text string|number
---@return self
function MultiEdit:SetText(text) end

---@class ELibOneTab : Frame, ELibBaseMethods
local OneTab = {}

--- Create a tab
---@param parent Frame The parent frame to which the tab will be added
---@param text string The text to display on the tab
---@param isOld boolean Whether the tab is an old version
---@return ELibOneTab
function ELib:OneTab(parent, text, isOld) end



---@class ELibPopup : Frame, ELibBaseMethods
---@field title FontString
---@field Close Button
local Popup = {}

--- Create a popup
---@param title string The title of the popup
---@param template string? The template to use for the popup
---@return ELibPopup
function ELib:Popup(title, template) end

---@return self
function Popup:AddScroll() end



---@class ELibRadio : Frame, ELibBaseMethods
local Radio = {}

--- Create a radio button
---@param parent Frame The parent frame to which the radio button will be added
---@param text string The text to display next to the radio button
---@param checked boolean Whether the radio button is initially checked
---@param template string? The template to use for the radio button
---@return ELibRadio
function ELib:Radio(parent, text, checked, template) end

--- makes text clickable
---@generic self
---@param self self
---@return self
function Radio:AddButton() end

---@generic self
---@param self self
---@param str string
---@return self
function Radio:Tooltip(str) end



---@class ELibScrollBar : Frame, ELibBaseMethods
---@field slider Slider
---@field bg Texture
---@field thumb Texture
---@field buttonUP Button
---@field buttonDown Button
---@field clickRange number
---@field isOld boolean
local ScrollBar = {}

--- Create a scroll bar
---@param parent Frame The parent frame to which the scroll bar will be added
---@param isOld boolean Whether the scroll bar is an old version
---@return ELibScrollBar
function ELib:ScrollBar(parent, isOld) end

--- Set the minimum and maximum values of the scroll bar
---@generic self
---@param self self
---@param min number The minimum value
---@param max number The maximum value
---@return self
function ScrollBar:Range(min, max) end

--- Set the scroll bar to a specific value
---@generic self
---@param self self
---@param value number The value to set the scroll bar to
---@return self
function ScrollBar:SetValue(value) end

--- Set the scroll bar to a specific value
---@generic self
---@param self self
---@param value number The value to set the scroll bar to
---@return self
function ScrollBar:SetTo(value) end

---@return number value The current value of the scroll bar
function ScrollBar:GetValue() end

---@return number min, number max The minimum and maximum values of the scroll bar
function ScrollBar:GetMinMaxValues() end

---@generic self
---@param self self
---@return self
function ScrollBar:SetMinMaxValues(...) end

---sets script on the slider
---@generic self
---@param self self
---@param ... any
---@return self
function ScrollBar:SetScript(...) end

--- Set a function to be called when the scroll bar value changes
---@generic self
---@param self self
---@param func function The function to call on value change
---@return self
function ScrollBar:OnChange(func) end

--- Update the states of the up and down buttons
---@generic self
---@param self self
---@return self
function ScrollBar:UpdateButtons() end

--- Set the value range for clicks on the buttons
---@generic self
---@param self self
---@param i number The value range for clicks
---@return self
function ScrollBar:ClickRange(i) end

---@generic self
---@param self self
---@return self
function ScrollBar:SetHorizontal() end

--- self.slider:SetObeyStepOnDrag(bool)
---@generic self
---@param self self
---@param bool boolean?
---@return self
function ScrollBar:SetObey(bool) end


---@generic self
---@param self self
---@return self
function ScrollBar:Minimal() end



---@class ELibScrollList : Frame, ELibBaseMethods
---@field Frame ELibScrollFrame
---@field linesPerPage number
---@field List table
---@field L table
local ScrollList = {}

--- Create a scroll list
---@param parent Frame The parent frame to which the scroll list will be added
---@param list table? The list of items to display in the scroll list
---@return ELibScrollList
function ELib:ScrollList(parent, list) end

--- Update the scroll list
---@generic self
---@param self self
---@return self
function ScrollList:Update() end

--- Set the font size of the scroll list
---@generic self
---@param self self
---@param size number The font size to set
---@return self
function ScrollList:FontSize(size) end

---@generic self
---@param self self
---@param fontName string
---@param fontSize number
---@return self
function ScrollList:Font(fontName, fontSize) end

---@generic self
---@param self self
---@param height number
---@return self
function ScrollList:LineHeight(height) end

--- makes lines draggable
---@generic self
---@param self self
---@return self
function ScrollList:AddDrag() end

---@generic self
---@param self self
---@return self
function ScrollList:HideBorders() end

--- emulates a line click?
---@generic self
---@param self self
---@return self
function ScrollList:SetTo(value) end

---@alias buttonClick
---|"LeftButton"
---|"RightButton"
---|"MiddleButton"
---|"Button4"
---|"Button5"

--- Fires on line click, after SetListValue
---@param line Frame|Button
---@param button buttonClick?
---@param isDown boolean?
function ScrollList.AdditionalLineClick(line, button, isDown) end

--- Fires on line click, before AdditionalLineClick
---@param index number corresponding to the self.L[index]
---@param button buttonClick?
---@param isDown boolean?
function ScrollList:SetListValue(index, button, isDown) end


---@class ELibScrollCheckList : ELibScrollList, ELibBaseMethods
local ScrollCheckList = {}

--- Create a scroll check list
---@param parent Frame The parent frame to which the scroll check list will be added
---@param list table The list of items to display in the scroll check list
---@return ELibScrollCheckList
function ELib:ScrollCheckList(parent, list) end



---@class ELibScrollFrame : ScrollFrame, ELibBaseMethods
---@field SetNewHeight fun(self,height): self
---@field Height fun(self,height): self
---@field AddHorizontal fun(self, outside): self
---@field HideScrollOnNoScroll fun(self): self
---@field content Frame
---@field C Frame # alias for .content
---@field scrollChild Frame
---@field isModern boolean
---@field ScrollBar ELibScrollBar
local ScrollFrame = {}

--- Create a scroll frame
---@param parent Frame The parent frame to which the scroll frame will be added
---@param isOld boolean? Whether the scroll frame is an old version
---@return ELibScrollFrame
function ELib:ScrollFrame(parent, isOld) end

--- Set the height of the scroll frame
---@generic self
---@param self self
---@param px number The height in pixels
---@return self
function ScrollFrame:Height(px) end



---@class ELibScrollTableList : ELibScrollFrame, ELibBaseMethods
---@field T table
local ScrollTableList = {}

--- Create a scroll table list
---@param parent Frame The parent frame to which the scroll table list will be added
---@vararg number The widths of the columns, one of which must be 0
---@return ELibScrollTableList
function ELib:ScrollTableList(parent, ...) end



---@class ScrollTabsFrame : Frame, ELibBaseMethods
---@field list ELibScrollList
local ScrollTabsFrame = {}

--- Create a scroll tabs frame
---@param parent Frame The parent frame to which the scroll tabs frame will be added
---@vararg number The widths of the tabs, one of which must be 0
---@return ScrollTabsFrame
function ELib:ScrollTabsFrame(parent, ...) end



---@class ELibScrollButtonsList : ELibScrollFrame, ELibBaseMethods
---@field Update fun(self,forceUpdate): self
---@field ResetScroll fun(self): self
local ScrollButtonsList = {}

--- Create a scroll buttons list
---@param parent Frame The parent frame to which the scroll buttons list will be added
---@return ELibScrollButtonsList
function ELib:ScrollButtonsList(parent) end



---@class ELibSlider : Slider, ELibBaseMethods
local Slider = {}

--- Create a slider
---@param parent Frame The parent frame to which the slider will be added
---@param text string The text label for the slider
---@param isVertical boolean Whether the slider is vertical
---@param template string? The template to use for the slider
---@return ELibSlider
function ELib:Slider(parent, text, isVertical, template) end

--- Set the range of the slider
---@generic self
---@param self self
---@param min number The minimum value of the slider
---@param max number The maximum value of the slider
---@return self
function Slider:Range(min, max) end

--- Set the slider to a specific value
---@generic self
---@param self self
---@param value number The value to set the slider to
---@return self
function Slider:SetTo(value) end

--- Set the function to call when the slider value changes
---@generic self
---@param self self
---@param func function The function to call on value change
---@return self
function Slider:OnChange(func) end

--- Set the width of the slider
---@generic self
---@param self self
---@param width number The width to set
---@return self
function Slider:Size(width) end

--- Set whether the slider obeys step on drag
---@generic self
---@param self self
---@param bool boolean Whether to obey step on drag
---@return self
function Slider:SetObey(bool) end

---@generic self
---@param self self
---@param str string
---@return self
function Slider:Tooltip(str) end



---@class ELibSliderBox : Frame, ELibBaseMethods
local SliderBox = {}

--- Create a slider box
---@param parent Frame The parent frame to which the slider box will be added
---@param list table The list of values for the slider box
---@return ELibSliderBox
function ELib:SliderBox(parent, list) end

--- Set the slider box to a specific value from the list
---@generic self
---@param self self
---@param value any The value to set the slider box to
---@return self
function SliderBox:SetTo(value) end



---@class ELibShadow : Frame
local Shadow = {}

--- Create a shadow frame
---@param parent Frame The parent frame to which the shadow will be added
---@param size number The size of the shadow
---@param edgeSize number The edge size of the shadow
---@return ELibShadow
function ELib:Shadow(parent, size, edgeSize) end



--- Create a shadow inside frame, no return
---@param parent Frame The parent frame to which the shadow inside will be added
---@param enableBorder boolean Whether to enable the border
---@param enableLine boolean Whether to enable the line
function ELib:ShadowInside(parent, enableBorder, enableLine) end



---@class ELibTabs : Frame, ELibBaseMethods
local Tabs = {}

--- Create a tabs frame
---@param parent Frame The parent frame to which the tabs will be added
---@param template string|number? The template to use for the tabs
---@param ... string Tab names
---@return ELibTabs
function ELib:Tabs(parent, template, ...) end

--- Set the tabs to a specific page
---@generic self
---@param self self
---@param page number The page to set the tabs to
---@return self
function Tabs:SetTo(page) end



---@class ELibTexture : Texture, ELibBaseMethods
local Texture = {}

--- Create a texture
---@param parent Frame The parent frame to which the texture will be added
---@param texture string|nil The texture file path
---@param layer DrawLayer? The layer of the texture
---@return ELibTexture
function ELib:Texture(parent, texture, layer) end

--- Create a colored texture
---@param parent Frame The parent frame to which the texture will be added
---@param cR number The red component of the color
---@param cG number The green component of the color
---@param cB number The blue component of the color
---@param cA number The alpha component of the color
---@param layer DrawLayer? The layer of the texture
---@return ELibTexture
function ELib:Texture(parent, cR, cG, cB, cA, layer) end

--- Set the vertex color of the texture
---@generic self
---@param self self
---@param r number The red component of the color
---@param g number The green component of the color
---@param b number The blue component of the color
---@param a number The alpha component of the color
---@return self
function Texture:Color(r, g, b, a) end

--- Set the texture coordinates
---@generic self
---@param self self
---@param ... any The texture coordinates
---@return self
function Texture:TexCoord(...) end

---@generic self
---@param self self
---@return self
function Texture:BlendMode(...) end

--- Set the gradient alpha of the texture
---@generic self
---@param self self
---@param ... any The gradient alpha parameters
---@return self
function Texture:Gradient(...) end

---@generic self
---@param self self
---@param texture string|number|nil
---@return self
function Texture:Texture(texture) end


---@generic self
---@param self self
---@param cR number
---@param cG number
---@param cB number
---@param cA number
---@return self
function Texture:Texture(cR, cG, cB, cA) end
function Texture:Texture(...) end

--- Set the atlas of the texture
---@generic self
---@param self self
---@param ... any The atlas parameters
---@return self
function Texture:Atlas(...) end

---@generic self
---@param self self
---@param layer DrawLayer
---@return self
function Texture:Layer(layer) end



---@class DecorationLine : Texture, ELibBaseMethods
local DecorationLine = {}

--- Create a decoration line
---@param parent Frame The parent frame to which the decoration line will be added
---@param isGradient boolean Whether the decoration line is a gradient
---@param layer DrawLayer The layer of the decoration line
---@param layerCounter number The layer counter of the decoration line
---@return DecorationLine
function ELib:DecorationLine(parent,isGradient,layer,layerCounter) end



--- Hides the tooltip.
function ELib.Tooltip:Hide() end

--- Displays a standard tooltip based on self.tooltipText, anchored to anchorUser.
---@param anchorUser any
function ELib.Tooltip:Std(anchorUser) end

--- Displays a tooltip for hyperlinks, such as "item:9999" or "spell:774".
---@param data string
---@vararg any
function ELib.Tooltip:Link(data, ...) end

--- Shows a tooltip with a title and additional lines of text, anchored to anchorUser.
---@param anchorUser any
---@param title string
---@vararg any
function ELib.Tooltip:Show(anchorUser, title, ...) end

--- Displays a tooltip for links in edit boxes or simple HTML elements.
---@param linkData any
---@param link string
function ELib.Tooltip:Edit_Show(linkData, link) end

--- Handles clicks on links in edit boxes or simple HTML elements.
---@param linkData any
---@param link string
---@param button any
function ELib.Tooltip:Edit_Click(linkData, link, button) end

--- Adds additional tooltips; data is a table parameter.
---@param link string
---@param data table
---@param enableMultiline boolean
---@param disableTitle boolean
function ELib.Tooltip:Add(link, data, enableMultiline, disableTitle) end

--- Hides all additional tooltips.
function ELib.Tooltip:HideAdd() end

function ELib.DropDownClose() end

---@alias TemplateName string
---| "ExRTFontNormal"
---| "ExRTFontGrayTemplate"
---| "ExRTUIChatDownButtonTemplate"
---| "ExRTTranslucentFrameTemplate"
---| "ExRTDropDownMenuButtonTemplate"
---| "ExRTDropDownListTemplate"
---| "ExRTDropDownListModernTemplate"
---| "ExRTButtonTransparentTemplate"
---| "ExRTButtonModernTemplate"
---| "ExRTBWInterfaceFrame"
---| "ExRTTabButtonTransparentTemplate"
---| "ExRTTabButtonTemplate"
---| "ExRTDialogTemplate"
---| "ExRTDialogModernTemplate"
---| "ExRTDropDownMenuTemplate"
---| "ExRTDropDownMenuModernTemplate"
---| "ExRTInputBoxTemplate"
---| "ExRTInputBoxModernTemplate"
---| "ExRTSliderTemplate"
---| "ExRTSliderModernTemplate"
---| "ExRTSliderModernVerticalTemplate"
---| "ExRTTrackingButtonModernTemplate"
---| "ExRTCheckButtonModernTemplate"
---| "ExRTButtonDownModernTemplate"
---| "ExRTButtonUpModernTemplate"
---| "ExRTUIChatDownButtonModernTemplate"
---| "ExRTRadioButtonModernTemplate"

---@class ExRTFontNormal : Font
---@class ExRTFontGrayTemplate : Font
---@class ExRTUIChatDownButtonTemplate : Button
---@class ExRTTranslucentFrameTemplate : Frame
---@class ExRTDropDownMenuButtonTemplate : Button
---@class ExRTDropDownListTemplate : Frame
---@class ExRTDropDownListModernTemplate : Button
---@class ExRTButtonTransparentTemplate : Button
---@class ExRTButtonModernTemplate : ExRTButtonTransparentTemplate
---@class ExRTBWInterfaceFrame : Frame
---@class ExRTTabButtonTransparentTemplate : Button
---@class ExRTTabButtonTemplate : ExRTTabButtonTransparentTemplate
---@class ExRTDialogTemplate : Frame
---@class ExRTDialogModernTemplate : Frame
---@class ExRTDropDownMenuTemplate : Frame
---@class ExRTDropDownMenuModernTemplate : Frame
---@class ExRTInputBoxTemplate : EditBox
---@class ExRTInputBoxModernTemplate : EditBox
---@class ExRTSliderTemplate : Slider
---@class ExRTSliderModernTemplate : Slider
---@class ExRTSliderModernVerticalTemplate : Slider
---@class ExRTTrackingButtonModernTemplate : Frame
---@class ExRTCheckButtonModernTemplate : CheckButton
---@class ExRTButtonDownModernTemplate : ExRTButtonModernTemplate
---@class ExRTButtonUpModernTemplate : ExRTButtonModernTemplate
---@class ExRTUIChatDownButtonModernTemplate : ExRTButtonModernTemplate
---@class ExRTRadioButtonModernTemplate : CheckButton

---@alias MRTTemplate
---| ExRTFontNormal
---| ExRTFontGrayTemplate
---| ExRTUIChatDownButtonTemplate
---| ExRTTranslucentFrameTemplate
---| ExRTDropDownMenuButtonTemplate
---| ExRTDropDownListTemplate
---| ExRTDropDownListModernTemplate
---| ExRTButtonTransparentTemplate
---| ExRTButtonModernTemplate
---| ExRTBWInterfaceFrame
---| ExRTTabButtonTransparentTemplate
---| ExRTTabButtonTemplate
---| ExRTDialogTemplate
---| ExRTDialogModernTemplate
---| ExRTDropDownMenuTemplate
---| ExRTDropDownMenuModernTemplate
---| ExRTInputBoxTemplate
---| ExRTInputBoxModernTemplate
---| ExRTSliderTemplate
---| ExRTSliderModernTemplate
---| ExRTSliderModernVerticalTemplate
---| ExRTTrackingButtonModernTemplate
---| ExRTCheckButtonModernTemplate
---| ExRTButtonDownModernTemplate
---| ExRTButtonUpModernTemplate
---| ExRTUIChatDownButtonModernTemplate
---| ExRTRadioButtonModernTemplate

--- Create a template
--- @param name TemplateName The name of the template
--- @param parent frame The parent template
--- @return MRTTemplate
function ELib:Template(name,parent) end


---@class MRTmodule
---@field options table?
---@field main table
---@field db table
---@field name string
---@field CLEU table|Frame
---@field Event function
---@field EventProfiling function
---@field HookEvent function
---@field RegisterAddonMessage function
---@field RegisterEvents function
---@field RegisterHideOnPetBattle function
---@field RegisterMiniMapMenu function
---@field RegisterSlash function
---@field RegisterTimer function
---@field RegisterUnitEvent function
---@field UnregisterAddonMessage function
---@field UnregisterEvents function
---@field UnregisterMiniMapMenu function
---@field UnregisterSlash function
---@field UnregisterTimer function
