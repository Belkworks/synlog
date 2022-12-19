-- Compiled with roblox-ts v2.0.4
local TS = _G[script]
local _helper = TS.import(script, script.Parent.Parent, "helper")
local Colors = _helper.Colors
local Fonts = _helper.Fonts
-- A block of drawn text
local TextBlock
do
	TextBlock = setmetatable({}, {
		__tostring = function()
			return "TextBlock"
		end,
	})
	TextBlock.__index = TextBlock
	function TextBlock.new(...)
		local self = setmetatable({}, TextBlock)
		return self:constructor(...) or self
	end
	function TextBlock:constructor(token)
		self.token = token
		self.height = 0
		self.width = 0
	end
	function TextBlock:createObject()
		local obj = self.object
		if obj == nil then
			obj = TextDynamic.new()
			self.object = obj
		end
		return obj
	end
	function TextBlock:create()
		local text = self:createObject()
		text.XAlignment = XAlignment.Right
		text.YAlignment = YAlignment.Bottom
		text.Size = 21
		text.Outlined = true
		text.OutlineColor = Colors.Black
		text.Visible = true
		self:update()
	end
	function TextBlock:update()
		local object = self.object
		if not object then
			return nil
		end
		local token = self.token
		object.Font = token.font or Fonts.Regular
		object.Color = token.color
		object.Text = token.text
		self.height = object.TextBounds.Y
		self.width = object.TextBounds.X
	end
	function TextBlock:move(vec)
		if not self.object then
			return nil
		end
		self.object.Position = Point2D.new(vec)
	end
	function TextBlock:destroy()
		if self.object then
			self.object.Visible = false
		end
		self.object = nil
	end
end
return {
	TextBlock = TextBlock,
}
