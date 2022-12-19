-- bundled with tape undefined

local __tape = {
	http = game:GetService('HttpService'),
	import = require,
	chunks = {}, -- string -> function
	cache = {}, -- string -> any
	scripts = {} -- script -> instance -> script
}

local function require(module)
	local import = __tape.import
	if typeof(module) == 'Instance' then
		local name = __tape.scripts[module]
		if name then module = name end
	end

	if typeof(module) ~= 'string' then
		return import(module)
	end

	local fn = __tape.chunks[module]
	if not fn then
		error(('tape: module %s not found'):format(module))
	end

	local cache = __tape.cache[module]
	if cache then
		return cache.value
	end

	local s, e = pcall(fn, __tape.scripts[module])
	if not s then
		error(('tape: error executing %s: %s'):format(module, e))
	end

	__tape.cache[module] = { value = e }
	return e
end

__tape.json = function(str)
	return function()
		return __tape.http:JSONDecode(str)
	end
end

__tape.buildTree = function(str)
	local function recurse(t, parent)
		local pair, children = unpack(t)
		local name, link = unpack(pair)
		local proxy = Instance.new(link and 'ModuleScript' or 'Folder')
		proxy.Parent = parent
		proxy.Name = name
		if link then
			__tape.scripts[proxy] = link
			__tape.scripts[link] = proxy
		end
		for _, v in pairs(children) do recurse(v, proxy) end
		return proxy
	end
	recurse(__tape.http:JSONDecode(str))
end

-- module: init.lua
__tape.chunks["init.lua"] = function(script)
-- Compiled with roblox-ts v2.0.4
local TS = _G[script]
local exports = {}
local DrawingLogger = TS.import(script, script, "class", "logger").DrawingLogger
exports.Line = TS.import(script, script, "class", "line").Line
exports.TextBlock = TS.import(script, script, "class", "block").TextBlock
local _helper = TS.import(script, script, "helper")
exports.Colors = _helper.Colors
exports.Text = _helper.Text
local Synlog = DrawingLogger.new()
exports.Synlog = Synlog
return exports
end

-- module: helper.lua
__tape.chunks["helper.lua"] = function(script)
-- Compiled with roblox-ts v2.0.4
local Colors = {
	Red = Color3.new(1, 0, 0),
	Green = Color3.new(0, 1, 0),
	Blue = Color3.new(0, 0, 1),
	Yellow = Color3.new(1, 1, 0),
	Teal = Color3.new(0, 1, 1),
	Magenta = Color3.new(1, 0, 1),
	Orange = Color3.fromRGB(255, 150, 0),
	BabyBlue = Color3.fromRGB(100, 140, 200),
	InfoBlue = Color3.fromRGB(50, 150, 220),
	Mint = Color3.fromRGB(100, 210, 160),
	LightRed = Color3.fromRGB(255, 63, 63),
	LightGreen = Color3.fromRGB(82, 255, 107),
	LightPurple = Color3.fromRGB(128, 101, 201),
	Black = Color3.new(0, 0, 0),
	White = Color3.fromRGB(255, 255, 255),
	Grey = Color3.fromRGB(176, 176, 176),
	GreyGrey = Color3.fromRGB(105, 105, 105),
}
local Text = {
	color = function(text, color)
		return {
			text = text,
			color = color,
		}
	end,
	white = function(text)
		return {
			text = text,
			color = Colors.White,
		}
	end,
}
local Fonts = {
	Regular = DrawFont.RegisterDefault("SometypeMono_Regular", {}),
	Italic = DrawFont.RegisterDefault("SometypeMono_Italic", {}),
}
return {
	Colors = Colors,
	Text = Text,
	Fonts = Fonts,
}
end

-- module: types.lua
__tape.chunks["types.lua"] = function(script)
-- Compiled with roblox-ts v2.0.4
return nil
end

-- module: class\block.lua
__tape.chunks["class/block.lua"] = function(script)
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
end

-- module: class\line.lua
__tape.chunks["class/line.lua"] = function(script)
-- Compiled with roblox-ts v2.0.4
local TS = _G[script]
local TextBlock = TS.import(script, script.Parent, "block").TextBlock
-- A horizontal list of TextBlocks
local Line
do
	Line = setmetatable({}, {
		__tostring = function()
			return "Line"
		end,
	})
	Line.__index = Line
	function Line.new(...)
		local self = setmetatable({}, Line)
		return self:constructor(...) or self
	end
	function Line:constructor(blocks)
		self.blocks = blocks
		self.height = 0
	end
	function Line:fromBlock(block)
		return Line.new({ block })
	end
	function Line:fromTokens(tokens)
		local _tokens = tokens
		local _arg0 = function(token)
			return TextBlock.new(token)
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#_tokens)
		for _k, _v in _tokens do
			_newValue[_k] = _arg0(_v, _k - 1, _tokens)
		end
		-- ▲ ReadonlyArray.map ▲
		return Line.new(_newValue)
	end
	function Line:fromToken(token)
		return Line:fromTokens({ token })
	end
	function Line:create()
		local _blocks = self.blocks
		local _arg0 = function(block)
			return block:create()
		end
		for _k, _v in _blocks do
			_arg0(_v, _k - 1, _blocks)
		end
		local _blocks_1 = self.blocks
		local _arg0_1 = function(acc, block)
			return math.max(acc, block.height)
		end
		-- ▼ ReadonlyArray.reduce ▼
		local _result = 0
		local _callback = _arg0_1
		for _i = 1, #_blocks_1 do
			_result = _callback(_result, _blocks_1[_i], _i - 1, _blocks_1)
		end
		-- ▲ ReadonlyArray.reduce ▲
		self.height = _result
	end
	function Line:move(position)
		if not self.blocks then
			return nil
		end
		local _blocks = self.blocks
		local _arg0 = function(block)
			block:move(position)
			local _position = position
			local _vector2 = Vector2.new(block.width, 0)
			position = _position + _vector2
		end
		for _k, _v in _blocks do
			_arg0(_v, _k - 1, _blocks)
		end
	end
	function Line:destroy()
		local _blocks = self.blocks
		local _arg0 = function(block)
			return block:destroy()
		end
		for _k, _v in _blocks do
			_arg0(_v, _k - 1, _blocks)
		end
		table.clear(self.blocks)
		self.height = 0
	end
end
return {
	Line = Line,
}
end

-- module: class\logger.lua
__tape.chunks["class/logger.lua"] = function(script)
-- Compiled with roblox-ts v2.0.4
local TS = _G[script]
local Dictionary = TS.import(script, TS.getModule(script, "@rbxts", "llama").out).Dictionary
local LogLevel = TS.import(script, TS.getModule(script, "@rbxts", "log").out).LogLevel
local _message_templates = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out)
local MessageTemplateParser = _message_templates.MessageTemplateParser
local TemplateTokenKind = _message_templates.TemplateTokenKind
local Object = TS.import(script, TS.getModule(script, "@rbxts", "object-utils"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local Workspace = _services.Workspace
local _helper = TS.import(script, script.Parent.Parent, "helper")
local Colors = _helper.Colors
local Fonts = _helper.Fonts
local Text = _helper.Text
local Line = TS.import(script, script.Parent, "line").Line
local logHeaders = {
	[LogLevel.Debugging] = "DEBUG",
	[LogLevel.Information] = "INFO",
	[LogLevel.Warning] = "WARN",
	[LogLevel.Error] = "ERROR",
	[LogLevel.Fatal] = "FATAL",
	[LogLevel.Verbose] = "LOG",
}
local padStart = function(str, len, pad)
	if pad == nil then
		pad = " "
	end
	local _pad = pad
	local _arg0 = len - #str
	return string.rep(_pad, _arg0) .. str
end
local _exp = Object.values(logHeaders)
local _arg0 = function(acc, cur)
	return math.max(acc, #cur)
end
-- ▼ ReadonlyArray.reduce ▼
local _result = 0
local _callback = _arg0
for _i = 1, #_exp do
	_result = _callback(_result, _exp[_i], _i - 1, _exp)
end
-- ▲ ReadonlyArray.reduce ▲
local logHeaderWidth = _result
local logHeadersPadStart = Dictionary.map(logHeaders, function(value)
	return padStart(value, logHeaderWidth)
end)
local Camera = Workspace.CurrentCamera
local DEFAULT_LOG_TIME = 7
local logColors = {
	[LogLevel.Debugging] = Colors.GreyGrey,
	[LogLevel.Information] = Colors.InfoBlue,
	[LogLevel.Warning] = Colors.Orange,
	[LogLevel.Error] = Colors.LightRed,
	[LogLevel.Fatal] = Colors.LightPurple,
	[LogLevel.Verbose] = Colors.White,
}
local DrawingLogger
do
	DrawingLogger = setmetatable({}, {
		__tostring = function()
			return "DrawingLogger"
		end,
	})
	DrawingLogger.__index = DrawingLogger
	function DrawingLogger.new(...)
		local self = setmetatable({}, DrawingLogger)
		return self:constructor(...) or self
	end
	function DrawingLogger:constructor()
		self.lines = {}
		self.queue = {}
		self.behavior = "wait"
		self.offset = Vector2.new(8, 8)
		self.direction = "up"
		self.maxLines = 10
	end
	function DrawingLogger:setMaxBehavior(behavior)
		self.behavior = behavior
		self:update()
		return self
	end
	function DrawingLogger:setOffset(x, y)
		if y == nil then
			y = x
		end
		self.offset = Vector2.new(x, y)
		return self
	end
	function DrawingLogger:addLine(line)
		local id = HttpService:GenerateGUID(false)
		local _queue = self.queue
		local _arg0_1 = {
			id = id,
			line = line,
			entered = tick(),
			visible = false,
		}
		table.insert(_queue, _arg0_1)
		self:update()
		return id
	end
	function DrawingLogger:sink(opts)
		local _labelOpts = opts
		if _labelOpts ~= nil then
			_labelOpts = _labelOpts.label
		end
		local labelOpts = _labelOpts
		local _result_1 = labelOpts
		if _result_1 ~= nil then
			_result_1 = _result_1.italic
		end
		local _condition = _result_1
		if _condition == nil then
			_condition = true
		end
		local labelItalic = _condition
		local _result_2 = labelOpts
		if _result_2 ~= nil then
			_result_2 = _result_2.font
		end
		local _condition_1 = _result_2
		if _condition_1 == nil then
			_condition_1 = (if labelItalic then Fonts.Italic else Fonts.Regular)
		end
		local labelFont = _condition_1
		local _result_3 = labelOpts
		if _result_3 ~= nil then
			_result_3 = _result_3.color
		end
		local _condition_2 = _result_3
		if _condition_2 == nil then
			_condition_2 = true
		end
		local labelColor = _condition_2
		local white = Colors.White
		return function(log)
			local _exp_1 = MessageTemplateParser.GetTokens(log.Template)
			local _arg0_1 = function(token)
				if token.kind == TemplateTokenKind.Text then
					return Text.white(token.text)
				end
				local prop = log[token.propertyName]
				local str = tostring(prop)
				local _exp_2 = typeof(prop)
				repeat
					if _exp_2 == "number" then
						return Text.color(str, Colors.Mint)
					end
					if _exp_2 == "string" then
						return Text.white(str)
					end
					return Text.color(str, Colors.Grey)
				until true
			end
			-- ▼ ReadonlyArray.map ▼
			local _newValue = table.create(#_exp_1)
			for _k, _v in _exp_1 do
				_newValue[_k] = _arg0_1(_v, _k - 1, _exp_1)
			end
			-- ▲ ReadonlyArray.map ▲
			local tokens = _newValue
			local prefix = log.SourceContext
			if prefix ~= nil then
				local _arg0_2 = Text.color("[" .. (prefix .. "] "), Colors.Grey)
				table.insert(tokens, 1, _arg0_2)
			end
			local _arg0_2 = {
				text = logHeadersPadStart[log.Level] .. " ",
				color = if labelColor then logColors[log.Level] else white,
				font = labelFont,
			}
			table.insert(tokens, 1, _arg0_2)
			self:addLine(Line:fromTokens(tokens))
		end
	end
	function DrawingLogger:destroyEntry(entry)
		if not entry.visible then
			return nil
		end
		entry.visible = false
		entry.line:destroy()
	end
	function DrawingLogger:enter(entry)
		entry.visible = true
		entry.entered = tick()
		entry.line:create()
		task.delay(DEFAULT_LOG_TIME, function()
			return self:dismiss(entry.id)
		end)
	end
	function DrawingLogger:removeById(id)
		local _lines = self.lines
		local _arg0_1 = function(entry)
			return entry.id == id
		end
		-- ▼ ReadonlyArray.findIndex ▼
		local _result_1 = -1
		for _i, _v in _lines do
			if _arg0_1(_v, _i - 1, _lines) == true then
				_result_1 = _i - 1
				break
			end
		end
		-- ▲ ReadonlyArray.findIndex ▲
		local i = _result_1
		if i >= 0 then
			self:destroyEntry(self.lines[i + 1])
			table.remove(self.lines, i + 1)
			return true
		end
		return false
	end
	function DrawingLogger:dismiss(id)
		local _queue = self.queue
		local _arg0_1 = function(entry)
			return entry.id == id
		end
		-- ▼ ReadonlyArray.findIndex ▼
		local _result_1 = -1
		for _i, _v in _queue do
			if _arg0_1(_v, _i - 1, _queue) == true then
				_result_1 = _i - 1
				break
			end
		end
		-- ▲ ReadonlyArray.findIndex ▲
		local i = _result_1
		if i >= 0 then
			table.remove(self.queue, i + 1)
			return true
		end
		if self:removeById(id) then
			self:update()
			return true
		end
		return false
	end
	function DrawingLogger:clear()
		local _lines = self.lines
		local _arg0_1 = function(entry)
			return self:destroyEntry(entry)
		end
		for _k, _v in _lines do
			_arg0_1(_v, _k - 1, _lines)
		end
		table.clear(self.lines)
		table.clear(self.queue)
		self:update()
	end
	function DrawingLogger:update()
		if #self.lines > 0 then
			local pos = self.offset
			if self.direction == "up" then
				pos = Vector2.new(pos.X, Camera.ViewportSize.Y - pos.Y)
				do
					local i = #self.lines
					local _shouldIncrement = false
					while true do
						if _shouldIncrement then
							i -= 1
						else
							_shouldIncrement = true
						end
						if not (i > 0) then
							break
						end
						local entry = self.lines[i - 1 + 1]
						local height = entry.line.height
						local _fn = entry.line
						local _pos = pos
						local _vector2 = Vector2.new(0, height)
						_fn:move(_pos - _vector2)
						local _pos_1 = pos
						local _vector2_1 = Vector2.new(0, height)
						pos = _pos_1 - _vector2_1
					end
				end
			else
				for _, entry in self.lines do
					entry.line:move(pos)
					local _pos = pos
					local _vector2 = Vector2.new(0, entry.line.height)
					pos = _pos + _vector2
				end
			end
		end
		if self.behavior == "wait" then
			if #self.lines >= self.maxLines then
				return nil
			end
			local entry = table.remove(self.queue, 1)
			if not entry then
				return nil
			end
			table.insert(self.lines, entry)
			self:enter(entry)
		else
			if #self.queue == 0 then
				return nil
			end
			while #self.queue > 0 do
				local entry = table.remove(self.queue, 1)
				if entry then
					table.insert(self.lines, entry)
				end
			end
			while #self.lines > self.maxLines do
				local entry = table.remove(self.lines, 1)
				if entry then
					self:destroyEntry(entry)
				end
			end
			for _, entry in self.lines do
				if entry.visible then
					continue
				end
				self:enter(entry)
			end
		end
		self:update()
	end
	function DrawingLogger:Destroy()
		self.addLine = function()
			return ""
		end
		local _lines = self.lines
		local _arg0_1 = function(entry)
			return entry.line:destroy()
		end
		for _k, _v in _lines do
			_arg0_1(_v, _k - 1, _lines)
		end
		table.clear(self.lines)
		table.clear(self.queue)
	end
end
return {
	logHeaders = logHeaders,
	logHeaderWidth = logHeaderWidth,
	logHeadersPadStart = logHeadersPadStart,
	DrawingLogger = DrawingLogger,
}
end

-- module: include\node_modules\@rbxts\llama\out\init.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/init.lua"] = function(script)
local Llama = {
	Dictionary = require(script.Dictionary),
	List = require(script.List),
	Set = require(script.Set),

	equalObjects = require(script.equalObjects),
	isEmpty = require(script.isEmpty),

	None = require(script.None),
}

return Llama
end

-- module: include\node_modules\@rbxts\llama\out\equalObjects.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/equalObjects.lua"] = function(script)
local function equalObjects(...)
	local firstObject = select(1, ...)

	for i = 2, select('#', ...) do
		if firstObject ~= select(i, ...) then
			return false
		end
	end

	return true
end

return equalObjects
end

-- module: include\node_modules\@rbxts\llama\out\isEmpty.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/isEmpty.lua"] = function(script)
local Llama = script.Parent
local t = require(Llama.t)

local validate = t.table

local function isEmpty(table)
	assert(validate(table))

	return next(table) == nil
end

return isEmpty
end

-- module: include\node_modules\@rbxts\llama\out\None.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/None.lua"] = function(script)
local None = newproxy(true)

getmetatable(None).__tostring = function()
	return "Llama.None"
end

return None
end

-- module: include\node_modules\@rbxts\llama\out\t.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/t.lua"] = function(script)
-- t: a runtime typechecker for Roblox

local t = {}

function t.type(typeName)
	return function(value)
		local valueType = type(value)
		if valueType == typeName then
			return true
		else
			return false, string.format("%s expected, got %s", typeName, valueType)
		end
	end
end

function t.typeof(typeName)
	return function(value)
		local valueType = typeof(value)
		if valueType == typeName then
			return true
		else
			return false, string.format("%s expected, got %s", typeName, valueType)
		end
	end
end

--[[**
	matches any type except nil

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
function t.any(value)
	if value ~= nil then
		return true
	else
		return false, "any expected, got nil"
	end
end

--Lua primitives

--[[**
	ensures Lua primitive boolean type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.boolean = t.typeof("boolean")

--[[**
	ensures Lua primitive thread type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.thread = t.typeof("thread")

--[[**
	ensures Lua primitive callback type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.callback = t.typeof("function")
t["function"] = t.callback

--[[**
	ensures Lua primitive none type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.none = t.typeof("nil")
t["nil"] = t.none

--[[**
	ensures Lua primitive string type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.string = t.typeof("string")

--[[**
	ensures Lua primitive table type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.table = t.typeof("table")

--[[**
	ensures Lua primitive userdata type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.userdata = t.type("userdata")

--[[**
	ensures value is a number and non-NaN

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
function t.number(value)
	local valueType = typeof(value)
	if valueType == "number" then
		if value == value then
			return true
		else
			return false, "unexpected NaN value"
		end
	else
		return false, string.format("number expected, got %s", valueType)
	end
end

--[[**
	ensures value is NaN

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
function t.nan(value)
	local valueType = typeof(value)
	if valueType == "number" then
		if value ~= value then
			return true
		else
			return false, "unexpected non-NaN value"
		end
	else
		return false, string.format("number expected, got %s", valueType)
	end
end

-- roblox types

--[[**
	ensures Roblox Axes type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Axes = t.typeof("Axes")

--[[**
	ensures Roblox BrickColor type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.BrickColor = t.typeof("BrickColor")

--[[**
	ensures Roblox CatalogSearchParams type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.CatalogSearchParams = t.typeof("CatalogSearchParams")

--[[**
	ensures Roblox CFrame type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.CFrame = t.typeof("CFrame")

--[[**
	ensures Roblox Color3 type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Color3 = t.typeof("Color3")

--[[**
	ensures Roblox ColorSequence type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.ColorSequence = t.typeof("ColorSequence")

--[[**
	ensures Roblox ColorSequenceKeypoint type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.ColorSequenceKeypoint = t.typeof("ColorSequenceKeypoint")

--[[**
	ensures Roblox DateTime type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.DateTime = t.typeof("DateTime")

--[[**
	ensures Roblox DockWidgetPluginGuiInfo type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.DockWidgetPluginGuiInfo = t.typeof("DockWidgetPluginGuiInfo")

--[[**
	ensures Roblox Enum type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Enum = t.typeof("Enum")

--[[**
	ensures Roblox EnumItem type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.EnumItem = t.typeof("EnumItem")

--[[**
	ensures Roblox Enums type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Enums = t.typeof("Enums")

--[[**
	ensures Roblox Faces type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Faces = t.typeof("Faces")

--[[**
	ensures Roblox Instance type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Instance = t.typeof("Instance")

--[[**
	ensures Roblox NumberRange type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.NumberRange = t.typeof("NumberRange")

--[[**
	ensures Roblox NumberSequence type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.NumberSequence = t.typeof("NumberSequence")

--[[**
	ensures Roblox NumberSequenceKeypoint type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.NumberSequenceKeypoint = t.typeof("NumberSequenceKeypoint")

--[[**
	ensures Roblox PathWaypoint type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.PathWaypoint = t.typeof("PathWaypoint")

--[[**
	ensures Roblox PhysicalProperties type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.PhysicalProperties = t.typeof("PhysicalProperties")

--[[**
	ensures Roblox Random type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Random = t.typeof("Random")

--[[**
	ensures Roblox Ray type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Ray = t.typeof("Ray")

--[[**
	ensures Roblox RaycastParams type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.RaycastParams = t.typeof("RaycastParams")

--[[**
	ensures Roblox RaycastResult type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.RaycastResult = t.typeof("RaycastResult")

--[[**
	ensures Roblox RBXScriptConnection type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.RBXScriptConnection = t.typeof("RBXScriptConnection")

--[[**
	ensures Roblox RBXScriptSignal type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.RBXScriptSignal = t.typeof("RBXScriptSignal")

--[[**
	ensures Roblox Rect type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Rect = t.typeof("Rect")

--[[**
	ensures Roblox Region3 type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Region3 = t.typeof("Region3")

--[[**
	ensures Roblox Region3int16 type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Region3int16 = t.typeof("Region3int16")

--[[**
	ensures Roblox TweenInfo type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.TweenInfo = t.typeof("TweenInfo")

--[[**
	ensures Roblox UDim type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.UDim = t.typeof("UDim")

--[[**
	ensures Roblox UDim2 type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.UDim2 = t.typeof("UDim2")

--[[**
	ensures Roblox Vector2 type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Vector2 = t.typeof("Vector2")

--[[**
	ensures Roblox Vector2int16 type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Vector2int16 = t.typeof("Vector2int16")

--[[**
	ensures Roblox Vector3 type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Vector3 = t.typeof("Vector3")

--[[**
	ensures Roblox Vector3int16 type

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
t.Vector3int16 = t.typeof("Vector3int16")

--[[**
	ensures value is a given literal value

	@param literal The literal to use

	@returns A function that will return true iff the condition is passed
**--]]
function t.literal(...)
	local size = select("#", ...)
	if size == 1 then
		local literal = ...
		return function(value)
			if value ~= literal then
				return false, string.format("expected %s, got %s", tostring(literal), tostring(value))
			end

			return true
		end
	else
		local literals = {}
		for i = 1, size do
			local value = select(i, ...)
			literals[i] = t.literal(value)
		end

		return t.union(table.unpack(literals, 1, size))
	end
end

--[[**
	DEPRECATED
	Please use t.literal
**--]]
t.exactly = t.literal

--[[**
	Returns a t.union of each key in the table as a t.literal

	@param keyTable The table to get keys from

	@returns True iff the condition is satisfied, false otherwise
**--]]
function t.keyOf(keyTable)
	local keys = {}
	local length = 0
	for key in pairs(keyTable) do
		length = length + 1
		keys[length] = key
	end

	return t.literal(table.unpack(keys, 1, length))
end

--[[**
	Returns a t.union of each value in the table as a t.literal

	@param valueTable The table to get values from

	@returns True iff the condition is satisfied, false otherwise
**--]]
function t.valueOf(valueTable)
	local values = {}
	local length = 0
	for _, value in pairs(valueTable) do
		length = length + 1
		values[length] = value
	end

	return t.literal(table.unpack(values, 1, length))
end

--[[**
	ensures value is an integer

	@param value The value to check against

	@returns True iff the condition is satisfied, false otherwise
**--]]
function t.integer(value)
	local success, errMsg = t.number(value)
	if not success then
		return false, errMsg or ""
	end

	if value % 1 == 0 then
		return true
	else
		return false, string.format("integer expected, got %s", value)
	end
end

--[[**
	ensures value is a number where min <= value

	@param min The minimum to use

	@returns A function that will return true iff the condition is passed
**--]]
function t.numberMin(min)
	return function(value)
		local success, errMsg = t.number(value)
		if not success then
			return false, errMsg or ""
		end

		if value >= min then
			return true
		else
			return false, string.format("number >= %s expected, got %s", min, value)
		end
	end
end

--[[**
	ensures value is a number where value <= max

	@param max The maximum to use

	@returns A function that will return true iff the condition is passed
**--]]
function t.numberMax(max)
	return function(value)
		local success, errMsg = t.number(value)
		if not success then
			return false, errMsg
		end

		if value <= max then
			return true
		else
			return false, string.format("number <= %s expected, got %s", max, value)
		end
	end
end

--[[**
	ensures value is a number where min < value

	@param min The minimum to use

	@returns A function that will return true iff the condition is passed
**--]]
function t.numberMinExclusive(min)
	return function(value)
		local success, errMsg = t.number(value)
		if not success then
			return false, errMsg or ""
		end

		if min < value then
			return true
		else
			return false, string.format("number > %s expected, got %s", min, value)
		end
	end
end

--[[**
	ensures value is a number where value < max

	@param max The maximum to use

	@returns A function that will return true iff the condition is passed
**--]]
function t.numberMaxExclusive(max)
	return function(value)
		local success, errMsg = t.number(value)
		if not success then
			return false, errMsg or ""
		end

		if value < max then
			return true
		else
			return false, string.format("number < %s expected, got %s", max, value)
		end
	end
end

--[[**
	ensures value is a number where value > 0

	@returns A function that will return true iff the condition is passed
**--]]
t.numberPositive = t.numberMinExclusive(0)

--[[**
	ensures value is a number where value < 0

	@returns A function that will return true iff the condition is passed
**--]]
t.numberNegative = t.numberMaxExclusive(0)

--[[**
	ensures value is a number where min <= value <= max

	@param min The minimum to use
	@param max The maximum to use

	@returns A function that will return true iff the condition is passed
**--]]
function t.numberConstrained(min, max)
	assert(t.number(min))
	assert(t.number(max))
	local minCheck = t.numberMin(min)
	local maxCheck = t.numberMax(max)

	return function(value)
		local minSuccess, minErrMsg = minCheck(value)
		if not minSuccess then
			return false, minErrMsg or ""
		end

		local maxSuccess, maxErrMsg = maxCheck(value)
		if not maxSuccess then
			return false, maxErrMsg or ""
		end

		return true
	end
end

--[[**
	ensures value is a number where min < value < max

	@param min The minimum to use
	@param max The maximum to use

	@returns A function that will return true iff the condition is passed
**--]]
function t.numberConstrainedExclusive(min, max)
	assert(t.number(min))
	assert(t.number(max))
	local minCheck = t.numberMinExclusive(min)
	local maxCheck = t.numberMaxExclusive(max)

	return function(value)
		local minSuccess, minErrMsg = minCheck(value)
		if not minSuccess then
			return false, minErrMsg or ""
		end

		local maxSuccess, maxErrMsg = maxCheck(value)
		if not maxSuccess then
			return false, maxErrMsg or ""
		end

		return true
	end
end

--[[**
	ensures value matches string pattern

	@param string pattern to check against

	@returns A function that will return true iff the condition is passed
**--]]
function t.match(pattern)
	assert(t.string(pattern))
	return function(value)
		local stringSuccess, stringErrMsg = t.string(value)
		if not stringSuccess then
			return false, stringErrMsg
		end

		if string.match(value, pattern) == nil then
			return false, string.format("%q failed to match pattern %q", value, pattern)
		end

		return true
	end
end

--[[**
	ensures value is either nil or passes check

	@param check The check to use

	@returns A function that will return true iff the condition is passed
**--]]
function t.optional(check)
	assert(t.callback(check))
	return function(value)
		if value == nil then
			return true
		end

		local success, errMsg = check(value)
		if success then
			return true
		else
			return false, string.format("(optional) %s", errMsg or "")
		end
	end
end

--[[**
	matches given tuple against tuple type definition

	@param ... The type definition for the tuples

	@returns A function that will return true iff the condition is passed
**--]]
function t.tuple(...)
	local checks = { ... }
	return function(...)
		local args = { ... }
		for i, check in ipairs(checks) do
			local success, errMsg = check(args[i])
			if success == false then
				return false, string.format("Bad tuple index #%s:\n\t%s", i, errMsg or "")
			end
		end

		return true
	end
end

--[[**
	ensures all keys in given table pass check

	@param check The function to use to check the keys

	@returns A function that will return true iff the condition is passed
**--]]
function t.keys(check)
	assert(t.callback(check))
	return function(value)
		local tableSuccess, tableErrMsg = t.table(value)
		if tableSuccess == false then
			return false, tableErrMsg or ""
		end

		for key in pairs(value) do
			local success, errMsg = check(key)
			if success == false then
				return false, string.format("bad key %s:\n\t%s", tostring(key), errMsg or "")
			end
		end

		return true
	end
end

--[[**
	ensures all values in given table pass check

	@param check The function to use to check the values

	@returns A function that will return true iff the condition is passed
**--]]
function t.values(check)
	assert(t.callback(check))
	return function(value)
		local tableSuccess, tableErrMsg = t.table(value)
		if tableSuccess == false then
			return false, tableErrMsg or ""
		end

		for key, val in pairs(value) do
			local success, errMsg = check(val)
			if success == false then
				return false, string.format("bad value for key %s:\n\t%s", tostring(key), errMsg or "")
			end
		end

		return true
	end
end

--[[**
	ensures value is a table and all keys pass keyCheck and all values pass valueCheck

	@param keyCheck The function to use to check the keys
	@param valueCheck The function to use to check the values

	@returns A function that will return true iff the condition is passed
**--]]
function t.map(keyCheck, valueCheck)
	assert(t.callback(keyCheck))
	assert(t.callback(valueCheck))
	local keyChecker = t.keys(keyCheck)
	local valueChecker = t.values(valueCheck)

	return function(value)
		local keySuccess, keyErr = keyChecker(value)
		if not keySuccess then
			return false, keyErr or ""
		end

		local valueSuccess, valueErr = valueChecker(value)
		if not valueSuccess then
			return false, valueErr or ""
		end

		return true
	end
end

--[[**
	ensures value is a table and all keys pass valueCheck and all values are true

	@param valueCheck The function to use to check the values

	@returns A function that will return true iff the condition is passed
**--]]
function t.set(valueCheck)
	return t.map(valueCheck, t.literal(true))
end

do
	local arrayKeysCheck = t.keys(t.integer)
--[[**
		ensures value is an array and all values of the array match check

		@param check The check to compare all values with

		@returns A function that will return true iff the condition is passed
	**--]]
	function t.array(check)
		assert(t.callback(check))
		local valuesCheck = t.values(check)

		return function(value)
			local keySuccess, keyErrMsg = arrayKeysCheck(value)
			if keySuccess == false then
				return false, string.format("[array] %s", keyErrMsg or "")
			end

			-- # is unreliable for sparse arrays
			-- Count upwards using ipairs to avoid false positives from the behavior of #
			local arraySize = 0

			for _ in ipairs(value) do
				arraySize = arraySize + 1
			end

			for key in pairs(value) do
				if key < 1 or key > arraySize then
					return false, string.format("[array] key %s must be sequential", tostring(key))
				end
			end

			local valueSuccess, valueErrMsg = valuesCheck(value)
			if not valueSuccess then
				return false, string.format("[array] %s", valueErrMsg or "")
			end

			return true
		end
	end

--[[**
		ensures value is an array of a strict makeup and size

		@param check The check to compare all values with

		@returns A function that will return true iff the condition is passed
	**--]]
	function t.strictArray(...)
		local valueTypes = { ... }
		assert(t.array(t.callback)(valueTypes))

		return function(value)
			local keySuccess, keyErrMsg = arrayKeysCheck(value)
			if keySuccess == false then
				return false, string.format("[strictArray] %s", keyErrMsg or "")
			end

			-- If there's more than the set array size, disallow
			if #valueTypes < #value then
				return false, string.format("[strictArray] Array size exceeds limit of %d", #valueTypes)
			end

			for idx, typeFn in pairs(valueTypes) do
				local typeSuccess, typeErrMsg = typeFn(value[idx])
				if not typeSuccess then
					return false, string.format("[strictArray] Array index #%d - %s", idx, typeErrMsg)
				end
			end

			return true
		end
	end
end

do
	local callbackArray = t.array(t.callback)
--[[**
		creates a union type

		@param ... The checks to union

		@returns A function that will return true iff the condition is passed
	**--]]
	function t.union(...)
		local checks = { ... }
		assert(callbackArray(checks))

		return function(value)
			for _, check in ipairs(checks) do
				if check(value) then
					return true
				end
			end

			return false, "bad type for union"
		end
	end

--[[**
		Alias for t.union
	**--]]
	t.some = t.union

--[[**
		creates an intersection type

		@param ... The checks to intersect

		@returns A function that will return true iff the condition is passed
	**--]]
	function t.intersection(...)
		local checks = { ... }
		assert(callbackArray(checks))

		return function(value)
			for _, check in ipairs(checks) do
				local success, errMsg = check(value)
				if not success then
					return false, errMsg or ""
				end
			end

			return true
		end
	end

--[[**
		Alias for t.intersection
	**--]]
	t.every = t.intersection
end

do
	local checkInterface = t.map(t.any, t.callback)
--[[**
		ensures value matches given interface definition

		@param checkTable The interface definition

		@returns A function that will return true iff the condition is passed
	**--]]
	function t.interface(checkTable)
		assert(checkInterface(checkTable))
		return function(value)
			local tableSuccess, tableErrMsg = t.table(value)
			if tableSuccess == false then
				return false, tableErrMsg or ""
			end

			for key, check in pairs(checkTable) do
				local success, errMsg = check(value[key])
				if success == false then
					return false, string.format("[interface] bad value for %s:\n\t%s", tostring(key), errMsg or "")
				end
			end

			return true
		end
	end

--[[**
		ensures value matches given interface definition strictly

		@param checkTable The interface definition

		@returns A function that will return true iff the condition is passed
	**--]]
	function t.strictInterface(checkTable)
		assert(checkInterface(checkTable))
		return function(value)
			local tableSuccess, tableErrMsg = t.table(value)
			if tableSuccess == false then
				return false, tableErrMsg or ""
			end

			for key, check in pairs(checkTable) do
				local success, errMsg = check(value[key])
				if success == false then
					return false, string.format("[interface] bad value for %s:\n\t%s", tostring(key), errMsg or "")
				end
			end

			for key in pairs(value) do
				if not checkTable[key] then
					return false, string.format("[interface] unexpected field %q", tostring(key))
				end
			end

			return true
		end
	end
end

--[[**
	ensure value is an Instance and it's ClassName matches the given ClassName

	@param className The class name to check for

	@returns A function that will return true iff the condition is passed
**--]]
function t.instanceOf(className, childTable)
	assert(t.string(className))

	local childrenCheck
	if childTable ~= nil then
		childrenCheck = t.children(childTable)
	end

	return function(value)
		local instanceSuccess, instanceErrMsg = t.Instance(value)
		if not instanceSuccess then
			return false, instanceErrMsg or ""
		end

		if value.ClassName ~= className then
			return false, string.format("%s expected, got %s", className, value.ClassName)
		end

		if childrenCheck then
			local childrenSuccess, childrenErrMsg = childrenCheck(value)
			if not childrenSuccess then
				return false, childrenErrMsg
			end
		end

		return true
	end
end

t.instance = t.instanceOf

--[[**
	ensure value is an Instance and it's ClassName matches the given ClassName by an IsA comparison

	@param className The class name to check for

	@returns A function that will return true iff the condition is passed
**--]]
function t.instanceIsA(className, childTable)
	assert(t.string(className))

	local childrenCheck
	if childTable ~= nil then
		childrenCheck = t.children(childTable)
	end

	return function(value)
		local instanceSuccess, instanceErrMsg = t.Instance(value)
		if not instanceSuccess then
			return false, instanceErrMsg or ""
		end

		if not value:IsA(className) then
			return false, string.format("%s expected, got %s", className, value.ClassName)
		end

		if childrenCheck then
			local childrenSuccess, childrenErrMsg = childrenCheck(value)
			if not childrenSuccess then
				return false, childrenErrMsg
			end
		end

		return true
	end
end

--[[**
	ensures value is an enum of the correct type

	@param enum The enum to check

	@returns A function that will return true iff the condition is passed
**--]]
function t.enum(enum)
	assert(t.Enum(enum))
	return function(value)
		local enumItemSuccess, enumItemErrMsg = t.EnumItem(value)
		if not enumItemSuccess then
			return false, enumItemErrMsg
		end

		if value.EnumType == enum then
			return true
		else
			return false, string.format("enum of %s expected, got enum of %s", tostring(enum), tostring(value.EnumType))
		end
	end
end

do
	local checkWrap = t.tuple(t.callback, t.callback)

--[[**
		wraps a callback in an assert with checkArgs

		@param callback The function to wrap
		@param checkArgs The function to use to check arguments in the assert

		@returns A function that first asserts using checkArgs and then calls callback
	**--]]
	function t.wrap(callback, checkArgs)
		assert(checkWrap(callback, checkArgs))
		return function(...)
			assert(checkArgs(...))
			return callback(...)
		end
	end
end

--[[**
	asserts a given check

	@param check The function to wrap with an assert

	@returns A function that simply wraps the given check in an assert
**--]]
function t.strict(check)
	return function(...)
		assert(check(...))
	end
end

do
	local checkChildren = t.map(t.string, t.callback)

--[[**
		Takes a table where keys are child names and values are functions to check the children against.
		Pass an instance tree into the function.
		If at least one child passes each check, the overall check passes.

		Warning! If you pass in a tree with more than one child of the same name, this function will always return false

		@param checkTable The table to check against

		@returns A function that checks an instance tree
	**--]]
	function t.children(checkTable)
		assert(checkChildren(checkTable))

		return function(value)
			local instanceSuccess, instanceErrMsg = t.Instance(value)
			if not instanceSuccess then
				return false, instanceErrMsg or ""
			end

			local childrenByName = {}
			for _, child in ipairs(value:GetChildren()) do
				local name = child.Name
				if checkTable[name] then
					if childrenByName[name] then
						return false, string.format("Cannot process multiple children with the same name %q", name)
					end

					childrenByName[name] = child
				end
			end

			for name, check in pairs(checkTable) do
				local success, errMsg = check(childrenByName[name])
				if not success then
					return false, string.format("[%s.%s] %s", value:GetFullName(), name, errMsg or "")
				end
			end

			return true
		end
	end
end

return t
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\init.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/init.lua"] = function(script)
local Dictionary = {
	copy = require(script.copy),
	copyDeep = require(script.copyDeep),
	count = require(script.count),
	equals = require(script.equals),
	equalsDeep = require(script.equalsDeep),
	every = require(script.every),
	filter = require(script.filter),
	flatten = require(script.flatten),
	flip = require(script.flip),
	fromLists = require(script.fromLists),
	has = require(script.has),
	includes = require(script.includes),
	join = require(script.merge),
	joinDeep = require(script.mergeDeep),
	keys = require(script.keys),
	map = require(script.map),
	merge = require(script.merge),
	mergeDeep = require(script.mergeDeep),
	removeKey = require(script.removeKey),
	removeKeys = require(script.removeKeys),
	removeValue = require(script.removeValue),
	removeValues = require(script.removeValues),
	set = require(script.set),
	some = require(script.some),
	update = require(script.update),
	values = require(script.values),
}

return Dictionary
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\copy.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/copy.lua"] = function(script)
return table.clone
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\copyDeep.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/copyDeep.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.table

local function copyDeep(dictionary)
	assert(validate(dictionary))
	
	local new = {}

	for key, value in pairs(dictionary) do
		if type(value) == "table" then
			new[key] = copyDeep(value)
		else
			new[key] = value
		end
	end

	return new
end

return copyDeep
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\count.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/count.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local function alwaysTrue()
	return true
end

local validate = t.tuple(t.table, t.optional(t.callback))

local function count(dictionary, predicate)
	assert(validate(dictionary, predicate))

	predicate = predicate or alwaysTrue
	
	local counter = 0

	for key, value in pairs(dictionary) do
		if predicate(value, key) then
			counter = counter + 1
		end
	end

	return counter
end

return count
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\equals.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/equals.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local equalObjects = require(Llama.equalObjects)

local function compare(a, b)
	if type(a) ~= "table" or type(b) ~= "table" then
		return a == b
	end

	for key, value in pairs(a) do
		if b[key] ~= value then
			return false
		end
	end

	for key, value in pairs(b) do
		if a[key] ~= value then
			return false
		end
	end

	return true
end

local function equals(...)
	if equalObjects(...) then
		return true
	end

	local argCount = select('#', ...)
	local firstObject = select(1, ...)

	for i = 2, argCount do
		local object = select(i, ...)

		if not compare(firstObject, object) then
			return false
		end
	end

	return true
end

return equals
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\equalsDeep.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/equalsDeep.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local equalObjects = require(Llama.equalObjects)

local function compareDeep(a, b)
	if type(a) ~= "table" or type(b) ~= "table" then
		return a == b
	end

	for key, value in pairs(a) do
		if not compareDeep(b[key], value) then
			return false
		end
	end

	for key, value in pairs(b) do
		if not compareDeep(a[key], value) then
			return false
		end
	end

	return true
end

local function equalsDeep(...)
	if equalObjects(...) then
		return true
	end

	local argCount = select('#', ...)
	local firstObject = select(1, ...)

	for i = 2, argCount do
		local object = select(i, ...)

		if not compareDeep(firstObject, object) then
			return false
		end
	end

	return true
end

return equalsDeep
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\every.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/every.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function every(dictionary, predicate)
	assert(validate(dictionary, predicate))
	
	for key, value in pairs(dictionary) do
		if not predicate(value, key) then
			return false
		end
	end

	return true
end

return every
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\filter.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/filter.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function filter(dictionary, filterer)
	assert(validate(dictionary, filterer))

	local new = {}

	for key, value in pairs(dictionary) do
		if filterer(value, key) then
			new[key] = value
		end
	end
	
	return new
end

return filter
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\flatten.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/flatten.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.optional(t.intersection(t.integer, t.numberMin(0))))

local function flatten(dictionary, depth)
	assert(validate(dictionary, depth))
	
	local new = {}

	for key, value in pairs(dictionary) do
		if type(value) == "table" and (not depth or depth > 0) then
			local subDictionary = flatten(value, depth and depth - 1)

			for newKey, newValue in pairs(new) do
				subDictionary[newKey] = newValue
			end

			new = subDictionary
		else
			new[key] = value
		end
	end

	return new
end

return flatten
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\flip.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/flip.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.table

local function flip(dictionary)
	assert(validate(dictionary))
	
	local new = {}

	for key, value in pairs(dictionary) do
		new[value] = key
	end

	return new
end

return flip
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\fromLists.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/fromLists.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.table)

local function fromLists(keys, values)
	assert(validate(keys, values))

	local keysLen = #keys

	assert(keysLen == #values, "lists must be same size")

	local dictionary = {}

	for i = 1, keysLen do
		dictionary[keys[i]] = values[i]
	end

	return dictionary
end

return fromLists
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\has.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/has.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.any)

local function has(dictionary, key)
	assert(validate(dictionary, key))
	
	return dictionary[key] ~= nil
end

return has
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\includes.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/includes.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.table

local function includes(dictionary, value)
	assert(validate(dictionary))
	
	for _, v in pairs(dictionary) do
		if v == value then
			return true
		end
	end

	return false
end

return includes
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\keys.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/keys.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.table

local function keys(dictionary)
	assert(validate(dictionary))
	
	local keysList = {}

	local index = 1

	for key, _ in pairs(dictionary) do
		keysList[index] = key
		index = index + 1
	end

	return keysList
end

return keys
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\map.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/map.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function map(dictionary, mapper)
	assert(validate(dictionary, mapper))

	local new = {}

	for key, value in pairs(dictionary) do
		local newValue, newKey = mapper(value, key)
		new[newKey or key] = newValue
	end

	return new
end

return map
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\merge.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/merge.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local None = require(Llama.None)
local t = require(Llama.t)

local validate = t.table

local function merge(...)
	local new = {}

	for dictionaryIndex = 1, select('#', ...) do
		local dictionary = select(dictionaryIndex, ...)

		if dictionary ~= nil then
			assert(validate(dictionary))
			
			for key, value in pairs(dictionary) do
				if value == None then
					new[key] = nil
				else
					new[key] = value
				end
			end
		end
	end

	return new
end

return merge
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\mergeDeep.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/mergeDeep.lua"] = function(script)
local Dictionary = script.Parent
local copyDeep = require(Dictionary.copyDeep)

local Llama = Dictionary.Parent
local None = require(script.Parent.Parent.None)
local t = require(Llama.t)

local validate = t.table

local function mergeDeep(...)
	local new = {}

	for dictionaryIndex = 1, select('#', ...) do
		local dictionary = select(dictionaryIndex, ...)

		if dictionary ~= nil then
			assert(validate(dictionary))

			for key, value in pairs(dictionary) do
				if value == None then
					new[key] = nil
				elseif type(value) == "table" then
					if new[key] == nil or type(new[key]) ~= "table" then
						new[key] = copyDeep(value)
					else
						new[key] = mergeDeep(new[key], value)
					end
				else
					new[key] = value
				end
			end
		end
	end

	return new
end

return mergeDeep
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\removeKey.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/removeKey.lua"] = function(script)
local Dictionary = script.Parent
local copy = require(Dictionary.copy)

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.table

local function removeKey(dictionary, key)
	assert(validate(dictionary))
	
	local new = copy(dictionary)

	new[key] = nil

	return new
end

return removeKey
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\removeKeys.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/removeKeys.lua"] = function(script)
local Dictionary = script.Parent
local copy = require(Dictionary.copy)

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.table

local function removeKeys(dictionary, ...)
	assert(validate(dictionary))
	
	local new = copy(dictionary)

	for i = 1, select('#', ...) do
		new[select(i, ...)] = nil
	end

	return new
end

return removeKeys
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\removeValue.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/removeValue.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.table

local function removeValue(dictionary, valueToRemove)
	assert(validate(dictionary))

	local new = {}

	for key, value in pairs(dictionary) do
		if value ~= valueToRemove then
			new[key] = value
		end
	end

	return new
end

return removeValue
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\removeValues.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/removeValues.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local List = Llama.List
local toSet = require(List.toSet)

local validate = t.table

local function removeValues(dictionary, ...)
	assert(validate(dictionary))
	
	local valuesSet = toSet({...})

	local new = {}

	for key, value in pairs(dictionary) do
		if not valuesSet[value] then
			new[key] = value
		end
	end

	return new
end

return removeValues
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\set.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/set.lua"] = function(script)
local Dictionary = script.Parent
local copy = require(Dictionary.copy)

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.any)

local function set(dictionary, key, value)
	assert(validate(dictionary, key))

	local new = copy(dictionary)

	new[key] = value

	return new
end

return set
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\some.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/some.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function some(dictionary, predicate)
	assert(validate(dictionary, predicate))

	for key, value in pairs(dictionary) do
		if predicate(value, key) then
			return true
		end
	end

	return false
end

return some
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\update.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/update.lua"] = function(script)
local Dictionary = script.Parent
local copy = require(Dictionary.copy)

local Llama = Dictionary.Parent
local t = require(Llama.t)

local function noUpdate(value)
	return value
end

local function call(callback, ...)
	if type(callback) == "function" then
		return callback(...)
	end
end

local optionalCallbackType = t.optional(t.callback)
local validate = t.tuple(t.table, t.any, optionalCallbackType, optionalCallbackType)

local function update(dictionary, key, updater, callback)
	assert(validate(dictionary, key, updater, callback))

	updater = updater or noUpdate

	local new = copy(dictionary)

	if new[key] ~= nil then
		new[key] = updater(new[key], key)
	else
		new[key] = call(callback, key)
	end

	return new
end

return update
end

-- module: include\node_modules\@rbxts\llama\out\Dictionary\values.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Dictionary/values.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local t = require(Llama.t)

local validate = t.table

local function values(dictionary)
	assert(validate(dictionary))
	
	local valuesList = {}

	local index = 1

	for _, value in pairs(dictionary) do
		valuesList[index] = value
		index = index + 1
	end

	return valuesList
end

return values
end

-- module: include\node_modules\@rbxts\llama\out\List\init.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/init.lua"] = function(script)
local List = {
	append = require(script.push),
	concat = require(script.concat),
	concatDeep = require(script.concatDeep),
	copy = require(script.copy),
	copyDeep = require(script.copyDeep),
	count = require(script.count),
	create = require(script.create),
	equals = require(script.equals),
	equalsDeep = require(script.equalsDeep),
	every = require(script.every),
	filter = require(script.filter),
	find = require(script.find),
	findLast = require(script.findLast),
	findWhere = require(script.findWhere),
	findWhereLast = require(script.findWhereLast),
	first = require(script.first),
	flatten = require(script.flatten),
	includes = require(script.includes),
	insert = require(script.insert),
	join = require(script.concat),
	joinDeep = require(script.concatDeep),
	last = require(script.last),
	map = require(script.map),
	pop = require(script.pop),
	push = require(script.push),
	reduce = require(script.reduce),
	reduceRight = require(script.reduceRight),
	removeIndex = require(script.removeIndex),
	removeIndices = require(script.removeIndices),
	removeValue = require(script.removeValue),
	removeValues = require(script.removeValues),
	reverse = require(script.reverse),
	set = require(script.set),
	shift = require(script.shift),
	slice = require(script.slice),
	some = require(script.some),
	sort = require(script.sort),
	splice = require(script.splice),
	toSet = require(script.toSet),
	unshift = require(script.unshift),
	update = require(script.update),
	zip = require(script.zip),
	zipAll = require(script.zipAll),
}

return List
end

-- module: include\node_modules\@rbxts\llama\out\List\concat.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/concat.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local None = require(Llama.None)
local t = require(Llama.t)

local validate = t.table

local function concat(...)
	local new = {}
	local index = 1

	for listIndex = 1, select('#', ...) do
		local list = select(listIndex, ...)

		if list ~= nil then
			assert(validate(list))

			for _, v in ipairs(list) do
				if v ~= None then
					new[index] = v
					index += 1
				end
			end
		end
	end

	return new
end

return concat
end

-- module: include\node_modules\@rbxts\llama\out\List\concatDeep.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/concatDeep.lua"] = function(script)
local List = script.Parent
local copyDeep = require(List.copyDeep)

local Llama = List.Parent
local None = require(Llama.None)
local t = require(Llama.t)

local validate = t.table

local function concatDeep(...)
	local new = {}
	local index = 1

	for listIndex = 1, select('#', ...) do
		local list = select(listIndex, ...)

		if list ~= nil then
			assert(validate(list))

			for _, v in ipairs(list) do
				if v ~= None then
					if type(v) == "table" then
						new[index] = copyDeep(v)
					else
						new[index] = v
					end

					index += 1
				end
			end
		end
	end

	return new
end

return concatDeep
end

-- module: include\node_modules\@rbxts\llama\out\List\copy.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/copy.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function copy(list)
	assert(validate(list))

	local new = {}

	for i, v in ipairs(list) do
		new[i] = v
	end

	return new
end

return copy
end

-- module: include\node_modules\@rbxts\llama\out\List\copyDeep.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/copyDeep.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function copyDeep(list)
	assert(validate(list))

	local new = {}

	for i, v in ipairs(list) do
		if type(v) == "table" then
			new[i] = copyDeep(v)
		else
			new[i] = v
		end
	end

	return new
end

return copyDeep
end

-- module: include\node_modules\@rbxts\llama\out\List\count.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/count.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local function alwaysTrue()
	return true
end

local validate = t.tuple(t.table, t.optional(t.callback))

local function count(list, predicate)
	assert(validate(list, predicate))

	predicate = predicate or alwaysTrue

	local counter = 0

	for i, v in ipairs(list) do
		if predicate(v, i) then
			counter += 1
		end
	end

	return counter
end

return count
end

-- module: include\node_modules\@rbxts\llama\out\List\create.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/create.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.intersection(t.integer, t.numberMin(0)), t.any)

local function recur(count, value)
	assert(validate(count, value))

	local list = {}

	for i = 1, count do
		list[i] = value
	end

	return list
end

return recur
end

-- module: include\node_modules\@rbxts\llama\out\List\equals.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/equals.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local equalObjects = require(Llama.equalObjects)

local function compare(a, b)
	if type(a) ~= "table" or type(b) ~= "table" then
		return a == b
	end

	local aLen = #a

	if aLen ~= #b then
		return false
	end

	for i = 1, #a do
		if a[i] ~= b[i] then
			return false
		end
	end

	return true
end

local function equals(...)
	if equalObjects(...) then
		return true
	end

	local argCount = select('#', ...)
	local firstObject = select(1, ...)

	for i = 2, argCount do
		local object = select(i, ...)

		if not compare(firstObject, object) then
			return false
		end
	end

	return true
end

return equals
end

-- module: include\node_modules\@rbxts\llama\out\List\equalsDeep.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/equalsDeep.lua"] = function(script)
local Dictionary = script.Parent

local Llama = Dictionary.Parent
local equalObjects = require(Llama.equalObjects)

local function compareDeep(a, b)
	if type(a) ~= "table" or type(b) ~= "table" then
		return a == b
	end

	local aLen = #a

	if aLen ~= #b then
		return false
	end

	for i = 1, aLen do
		if not compareDeep(a[i], b[i]) then
			return false
		end
	end

	return true
end

local function equalsDeep(...)
	if equalObjects(...) then
		return true
	end

	local argCount = select('#', ...)
	local firstObject = select(1, ...)

	for i = 2, argCount do
		local object = select(i, ...)

		if not compareDeep(firstObject, object) then
			return false
		end
	end

	return true
end

return equalsDeep
end

-- module: include\node_modules\@rbxts\llama\out\List\every.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/every.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function every(list, predicate)
	assert(validate(list, predicate))

	for i, v in ipairs(list) do
		if not predicate(v, i) then
			return false
		end
	end

	return true
end

return every
end

-- module: include\node_modules\@rbxts\llama\out\List\filter.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/filter.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function filter(list, filterer)
	assert(validate(list, filterer))

	local new = {}
	local index = 1

	for i, v in ipairs(list) do
		if filterer(v, i) then
			new[index] = v
			index += 1
		end
	end

	return new
end

return filter
end

-- module: include\node_modules\@rbxts\llama\out\List\find.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/find.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.optional(t.any), t.optional(t.integer))

local function find(list, value, from)
	assert(validate(list, value, from))

	local len = #list

	from = from or 1

	if from < 1 then
		from = len + from
	end

	assert(from > 0 and from <= len + 1, string.format("index %d out of bounds of list of length %d", from, len))
	
	for i = from, len do
		if list[i] == value then
			return i
		end
	end

	return nil
end

return find
end

-- module: include\node_modules\@rbxts\llama\out\List\findLast.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/findLast.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.optional(t.any), t.optional(t.integer))

local function findLast(list, value, from)
	assert(validate(list, value, from))

	local len = #list

	if len <= 0 then
		return nil
	end

	from = from or len

	if from < 1 then
		from = len + from
	end

	assert(from > 0 and from <= len + 1, string.format("index %d out of bounds of list of length %d", from, len))

	for i = from, 1, -1 do
		if list[i] == value then
			return i
		end
	end

	return nil
end

return findLast
end

-- module: include\node_modules\@rbxts\llama\out\List\findWhere.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/findWhere.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback, t.optional(t.integer))

local function findWhere(list, predicate, from)
	assert(validate(list, predicate, from))

	local len = #list

	from = from or 1

	if from < 1 then
		from = len + from
	end

	assert(from > 0 and from <= len + 1, string.format("index %d out of bounds of list of length %d", from, len))

	for i = from, len do
		if predicate(list[i], i) then
			return i
		end
	end

	return nil
end

return findWhere
end

-- module: include\node_modules\@rbxts\llama\out\List\findWhereLast.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/findWhereLast.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback, t.optional(t.integer))

local function findWhereLast(list, predicate, from)
	assert(validate(list, predicate, from))

	local len = #list

	if len <= 0 then
		return nil
	end

	from = from or len

	if from < 1 then
		from = len + from
	end

	assert(from > 0 and from <= len + 1, string.format("index %d out of bounds of list of length %d", from, len))
	
	for i = from, 1, -1 do
		if predicate(list[i], i) then
			return i
		end
	end

	return nil
end

return findWhereLast
end

-- module: include\node_modules\@rbxts\llama\out\List\first.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/first.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function first(list)
	assert(validate(list))

	return list[1]
end

return first
end

-- module: include\node_modules\@rbxts\llama\out\List\flatten.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/flatten.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.optional(t.intersection(t.integer, t.numberMin(0))))

local function flatten(list, depth)
	assert(validate(list))
	
	local new = {}
	local index = 1

	for _, v in ipairs(list) do
		if type(v) == "table" and (not depth or depth > 0) then
			local subList = flatten(v, depth and depth - 1)

			for j = 1, #subList do
				new[index] = subList[j]
				index = index + 1
			end
		else
			new[index] = v
			index = index + 1
		end
	end

	return new
end

return flatten
end

-- module: include\node_modules\@rbxts\llama\out\List\includes.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/includes.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function includes(list, value)
	assert(validate(list))

	for _, v in ipairs(list) do
		if v == value then
			return true
		end
	end

	return false
end

return includes
end

-- module: include\node_modules\@rbxts\llama\out\List\insert.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/insert.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.optional(t.integer))

local function insert(list, index, ...)
	assert(validate(list, index))

	local len = #list

	if index < 1 then
		index = len + index
	end

	assert(index > 0 and index <= len + 1, string.format("index %d out of bounds of list of length %d", index, len))

	local new = {}
	local resultIndex = 1
	
	for i = 1, len do
		if i == index then
			for j = 1, select('#', ...) do
				new[resultIndex] = select(j, ...)
				resultIndex = resultIndex + 1
			end
		end
		
		new[resultIndex] = list[i]
		resultIndex = resultIndex + 1
	end

	return new
end

return insert
end

-- module: include\node_modules\@rbxts\llama\out\List\last.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/last.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function last(list)
	assert(validate(list))

	return list[#list]
end

return last
end

-- module: include\node_modules\@rbxts\llama\out\List\map.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/map.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function map(list, mapper)
	assert(validate(list, mapper))

	local new = {}
	local index = 1

	for i, v in ipairs(list) do
		local value = mapper(v, i)

		if value ~= nil then
			new[index] = value
			index += 1
		end
	end

	return new
end

return map
end

-- module: include\node_modules\@rbxts\llama\out\List\pop.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/pop.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.optional(t.intersection(t.integer, t.numberMin(0))))

local function pop(list, numPops)
	assert(validate(list, numPops))

	local len = #list

	numPops = numPops or 1

	assert(numPops > 0 and numPops <= len + 1, string.format("index %d out of bounds of list of length %d", numPops, len))

	local new = {}

	for i = 1, #list - numPops do
		new[i] = list[i]
	end

	return new
end

return pop
end

-- module: include\node_modules\@rbxts\llama\out\List\push.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/push.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function push(list, ...)
	assert(validate(list))
	
	local new = {}
	local len = #list

	for i = 1, len do
		new[i] = list[i]
	end

	for i = 1, select('#', ...) do
		new[len + i] = select(i, ...)
	end

	return new
end

return push
end

-- module: include\node_modules\@rbxts\llama\out\List\reduce.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/reduce.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function reduce(list, reducer, initialReduction)
	assert(validate(list, reducer))

	local reduction = initialReduction
	local start = 1

	if reduction == nil then
		reduction = list[1]
		start = 2
	end

	for i = start, #list do
		reduction = reducer(reduction, list[i], i)
	end

	return reduction
end

return reduce
end

-- module: include\node_modules\@rbxts\llama\out\List\reduceRight.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/reduceRight.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function reduceRight(list, reducer, initialReduction)
	assert(validate(list, reducer))

	local len = #list
	local reduction = initialReduction
	local start = len

	if reduction == nil then
		reduction = list[len]
		start = len - 1
	end

	for i = start, 1, -1 do
		reduction = reducer(reduction, list[i], i)
	end

	return reduction
end

return reduceRight
end

-- module: include\node_modules\@rbxts\llama\out\List\removeIndex.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/removeIndex.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.integer)

local function removeIndex(list, indexToRemove)
	assert(validate(list, indexToRemove))

	local len = #list

	if indexToRemove < 1 then
		indexToRemove += len
	end

	assert(indexToRemove > 0 and indexToRemove <= len, string.format("index %d out of bounds of list of length %d", indexToRemove, len))

	local new = {}
	local index = 1

	for i, v in ipairs(list) do
		if i ~= indexToRemove then
			new[index] = v
			index += 1
		end
	end

	return new
end

return removeIndex
end

-- module: include\node_modules\@rbxts\llama\out\List\removeIndices.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/removeIndices.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validateList = t.table
local validateIndex = t.integer

local function removeIndices(list, ...)
	assert(validateList(list))

	local len = #list
	local indicesToRemove = {}

	for i = 1, select('#', ...) do
		local index = select(i, ...)
		
		assert(validateIndex(index))

		if index < 1 then
			index = len + index
		end

		assert(index > 0 and index <= len, string.format("index %d out of bounds of list of length %d", index, len))

		indicesToRemove[index] = true
	end
	
	local new = {}
	local index = 1

	for i = 1, len do
		if not indicesToRemove[i] then
			new[index] = list[i]
			index = index + 1
		end
	end

	return new
end

return removeIndices
end

-- module: include\node_modules\@rbxts\llama\out\List\removeValue.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/removeValue.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function removeValue(list, value)
	assert(validate(list))

	local new = {}
	local index = 1

	for _, v in ipairs(list) do
		if v ~= value then
			new[index] = v
			index += 1
		end
	end

	return new
end

return removeValue
end

-- module: include\node_modules\@rbxts\llama\out\List\removeValues.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/removeValues.lua"] = function(script)
local List = script.Parent
local toSet = require(List.toSet)

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function removeValue(list, ...)
	assert(validate(list))

	local valuesSet = toSet({...})
	local new = {}
	local index = 1

	for _, v in ipairs(list) do
		if not valuesSet[v] then
			new[index] = v
			index += 1
		end
	end

	return new
end

return removeValue
end

-- module: include\node_modules\@rbxts\llama\out\List\reverse.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/reverse.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function reverse(list)
	assert(validate(list))

	local new = {}

	local back = #list + 1

	for i, _ in ipairs(list) do
		new[i] = list[back - i]
	end

	return new
end

return reverse
end

-- module: include\node_modules\@rbxts\llama\out\List\set.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/set.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.integer)

local function set(list, index, value)
	assert(validate(list, index))
	
	local len = #list

	if index < 0 then
		index = len + index
	end

	assert(index > 0 and index <= len + 1, string.format("index %d out of bounds of list of length %d", index, len))

	local new = {}
	local indexNew = 1

	for i = 1, len do
		if i == index then
			new[indexNew] = value
		else
			new[indexNew] = list[i]
		end

		indexNew += 1
	end

	return new
end

return set
end

-- module: include\node_modules\@rbxts\llama\out\List\shift.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/shift.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.optional(t.intersection(t.integer, t.numberMin(0))))

local function shift(list, numPlaces)
	assert(validate(list, numPlaces))

	local len = #list
	
	numPlaces = numPlaces or 1

	assert(numPlaces > 0 and numPlaces <= len + 1, string.format("index %d out of bounds of list of length %d", numPlaces, len))
	
	local new = {}

	for i = 1 + numPlaces, len do
		new[i - numPlaces] = list[i]
	end

	return new
end

return shift
end

-- module: include\node_modules\@rbxts\llama\out\List\slice.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/slice.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local indexType = t.optional(t.integer)
local validate = t.tuple(t.table, indexType, indexType)

local function slice(list, from, to)
	assert(validate(list, from, to))
	
	local len = #list

	from = from or 1
	to = to or len

	if from < 1 then
		from = len + from
	end

	if to < 1 then
		to = len + to
	end

	assert(from > 0 and from <= len + 1, string.format("index %d out of bounds of list of length %d", from, len))
	assert(to > 0 and to <= len + 1, string.format("index %d out of bounds of list of length %d", to, len))
	assert(from <= to, string.format("start index %d cannot be greater than end index %d", from, to))

	local new = {}
	local index = 1

	for i = from, to do
		new[index] = list[i]
		index = index + 1
	end

	return new
end

return slice
end

-- module: include\node_modules\@rbxts\llama\out\List\some.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/some.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function some(list, predicate)
	assert(validate(list, predicate))
	
	for i = 1, #list do
		if predicate(list[i], i) then
			return true
		end
	end

	return false
end

return some
end

-- module: include\node_modules\@rbxts\llama\out\List\sort.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/sort.lua"] = function(script)
local List = script.Parent
local copy = require(List.copy)

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.optional(t.callback))

local function sort(list, comparator)
	assert(validate(list, comparator))
	
	local new = copy(list)

	table.sort(new, comparator)

	return new
end

return sort
end

-- module: include\node_modules\@rbxts\llama\out\List\splice.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/splice.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local indexType = t.optional(t.integer)
local validate = t.tuple(t.table, indexType, indexType)

local function splice(list, from, to, ...)
	assert(validate(list, from, to))
	
	local len = #list

	from = from or 1
	to = to or len + 1

	if from < 1 then
		from = len + from
	end

	if to < 1 then
		to = len + to
	end

	assert(from > 0 and from <= len + 1, string.format("index %d out of bounds of list of length %d", from, len))
	assert(to > 0 and to <= len + 1, string.format("index %d out of bounds of list of length %d", to, len))
	assert(from <= to, string.format("start index %d cannot be greater than end index %d", from, to))

	local new = {}
	local index = 1

	for i = 1, from - 1 do
		new[index] = list[i]
		index = index + 1
	end

	for i = 1, select('#', ...) do
		new[index] = select(i, ...)
		index = index + 1
	end

	for i = to + 1, len do
		new[index] = list[i]
		index = index + 1
	end

	return new
end

return splice
end

-- module: include\node_modules\@rbxts\llama\out\List\toSet.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/toSet.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function toSet(list)
	assert(validate(list))

	local set = {}

	for _, v in ipairs(list) do
		set[v] = true
	end

	return set
end

return toSet
end

-- module: include\node_modules\@rbxts\llama\out\List\unshift.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/unshift.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function unshift(list, ...)
	assert(validate(list))

	local argCount = select('#', ...)

	local new = {}

	for i = 1, argCount do
		new[i] = select(i, ...)
	end

	for i, v in ipairs(list) do
		new[argCount + i] = v
	end

	return new
end

return unshift
end

-- module: include\node_modules\@rbxts\llama\out\List\update.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/update.lua"] = function(script)
local List = script.Parent
local copy = require(List.copy)

local Llama = List.Parent
local t = require(Llama.t)

local function noUpdate(value)
	return value
end

local function call(callback, ...)
	if type(callback) == "function" then
		return callback(...)
	end
end

local optionalCallbackType = t.optional(t.callback)
local validate = t.tuple(t.table, t.integer, optionalCallbackType, optionalCallbackType)

local function update(list, index, updater, callback)
	assert(validate(list, index, updater, callback))

	local len = #list

	if index < 0 then
		index = len + index
	end

	assert(index > 0 and index <= len + 1, string.format("index %d out of bounds of list of length %d", index, len))

	updater = updater or noUpdate

	local new = copy(list)

	if new[index] ~= nil then
		new[index] = updater(new[index], index)
	else
		new[index] = call(callback, index)
	end

	return new
end

return update
end

-- module: include\node_modules\@rbxts\llama\out\List\zip.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/zip.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local t = require(Llama.t)

local validate = t.table

local function zip(...)
	local new = {}
	local argCount = select('#', ...)

	if argCount <= 0 then
		return new
	end

	local firstList = select(1, ...)

	assert(validate(firstList))

	local minLen = #firstList

	for i = 2, argCount do
		local list = select(i, ...)

		assert(validate(list))

		local len = #list

		if len < minLen then
			minLen = len
		end
	end

	for i = 1, minLen do
		new[i] = {}
		
		for j = 1, argCount do
			new[i][j] = select(j, ...)[i]
		end
	end

	return new
end

return zip
end

-- module: include\node_modules\@rbxts\llama\out\List\zipAll.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/List/zipAll.lua"] = function(script)
local List = script.Parent

local Llama = List.Parent
local None = require(Llama.None)
local t = require(Llama.t)

local validate = t.table

local function zipAll(...)
	local new = {}
	local argCount = select('#', ...)
	local maxLen = 0

	for i = 1, argCount do
		local list = select(i, ...)

		assert(validate(list))

		local len = #list

		if len > maxLen then
			maxLen = len
		end
	end

	for i = 1, maxLen do
		new[i] = {}
		
		for j = 1, argCount do
			local value = select(j, ...)[i]

			if value == nil then
				new[i][j] = None
			else
				new[i][j] = select(j, ...)[i]
			end
		end
	end

	return new
end

return zipAll
end

-- module: include\node_modules\@rbxts\llama\out\Set\init.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/init.lua"] = function(script)
local Set = {
	add = require(script.add),
	copy = require(script.copy),
	filter = require(script.filter),
	fromList = require(script.fromList),
	has = require(script.has),
	intersection = require(script.intersection),
	isSubset = require(script.isSubset),
	isSuperset = require(script.isSuperset),
	map = require(script.map),
	subtract = require(script.subtract),
	toList = require(script.toList),
	union = require(script.union),
}

return Set
end

-- module: include\node_modules\@rbxts\llama\out\Set\add.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/add.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.table

local function add(set, ...)
	assert(validate(set))

	local new = {}

	for key, _ in pairs(set) do
		new[key] = true
	end

	for i = 1, select('#', ...) do
		new[select(i, ...)] = true
	end

	return new
end

return add
end

-- module: include\node_modules\@rbxts\llama\out\Set\copy.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/copy.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent

local Dictionary = Llama.Dictionary
local copy = require(Dictionary.copy)

return copy
end

-- module: include\node_modules\@rbxts\llama\out\Set\filter.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/filter.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function filter(set, filterer)
	assert(validate(set, filterer))

	local new = {}

	for key, _ in pairs(set) do
		if filterer(key) then
			new[key] = true
		end
	end
	
	return new
end

return filter
end

-- module: include\node_modules\@rbxts\llama\out\Set\fromList.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/fromList.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.table

local function fromList(list)
	assert(validate(list))
	
	local set = {}

	for i = 1, #list do
		set[list[i]] = true
	end

	return set
end

return fromList
end

-- module: include\node_modules\@rbxts\llama\out\Set\has.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/has.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.any)

local function has(set, key)
	assert(validate(set, key))
	
	return set[key] == true
end

return has
end

-- module: include\node_modules\@rbxts\llama\out\Set\intersection.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/intersection.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.table

local function intersection(...)
	local new = {}
	local argCount = select('#', ...)
	local firstSet = select(1, ...)

	assert(validate(firstSet))

	for key, _ in pairs(firstSet) do
		local intersects = true

		for i = 2, argCount do
			local set = select(i, ...)

			assert(validate(set))

			if set[key] == nil then
				intersects = false
				break
			end
		end

		if intersects then
			new[key] = true
		end
	end

	return new
end

return intersection
end

-- module: include\node_modules\@rbxts\llama\out\Set\isSubset.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/isSubset.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.table)

local function isSubset(subset, superset)
	assert(validate(subset, superset))
	
	for key, value in pairs(subset) do
		if superset[key] ~= value then
			return false
		end
	end

	return true
end

return isSubset
end

-- module: include\node_modules\@rbxts\llama\out\Set\isSuperset.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/isSuperset.lua"] = function(script)
local Set = script.Parent
local isSubset = require(Set.isSubset)

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.table)

local function isSuperset(superset, subset)
	assert(validate(superset, subset))
	
	return isSubset(subset, superset)
end

return isSuperset
end

-- module: include\node_modules\@rbxts\llama\out\Set\map.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/map.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.tuple(t.table, t.callback)

local function map(set, mapper)
	assert(validate(set, mapper))

	local new = {}

	for key, _ in pairs(set) do
		local newKey = mapper(key)

		if newKey ~= nil then
			new[newKey] = true
		end
	end

	return new
end

return map
end

-- module: include\node_modules\@rbxts\llama\out\Set\subtract.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/subtract.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.table

local function subtract(set, ...)
	assert(validate(set))

	local new = {}

	for key, _ in pairs(set) do
		new[key] = true
	end

	for i = 1, select('#', ...) do
		new[select(i, ...)] = nil
	end

	return new
end

return subtract
end

-- module: include\node_modules\@rbxts\llama\out\Set\toList.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/toList.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.table

local function toList(set)
	assert(validate(set))

	local new = {}
	local index = 1

	for key, _ in pairs(set) do
		new[index] = key
		index = index + 1
	end

	return new
end

return toList
end

-- module: include\node_modules\@rbxts\llama\out\Set\union.lua
__tape.chunks["include/node_modules/@rbxts/llama/out/Set/union.lua"] = function(script)
local Set = script.Parent

local Llama = Set.Parent
local t = require(Llama.t)

local validate = t.table

local function union(...)
	local new = {}

	for i = 1, select('#', ...) do
		local set = select(i, ...)

		assert(validate(set))

		for key, _ in pairs(set) do
			new[key] = true
		end
	end

	return new
end

return union
end

-- module: include\node_modules\@rbxts\log\out\init.lua
__tape.chunks["include/node_modules/@rbxts/log/out/init.lua"] = function(script)
-- Compiled with roblox-ts v1.3.3
local TS = _G[script]
local exports = {}
local LogEventRobloxOutputSink = TS.import(script, script, "Core", "LogEventRobloxOutputSink").LogEventRobloxOutputSink
local Logger = TS.import(script, script, "Logger").Logger
exports.Logger = TS.import(script, script, "Logger").Logger
exports.LogLevel = TS.import(script, script, "Core").LogLevel
local Log = {}
do
	local _container = Log
	local defaultLogger = Logger:default()
	local function SetLogger(logger)
		defaultLogger = logger
	end
	_container.SetLogger = SetLogger
	local function Default()
		return defaultLogger
	end
	_container.Default = Default
	--[[
		*
		* Configure a custom logger
	]]
	local function Configure()
		return Logger:configure()
	end
	_container.Configure = Configure
	--[[
		*
		* Creates a custom logger
		* @returns The logger configuration, use `Initialize` to get the logger once configured
		* @deprecated Use {@link Configure}. This will be removed in future.
	]]
	local Create = Configure
	_container.Create = Create
	--[[
		*
		* The default roblox output sink
		* @param options Options for the sink
	]]
	local RobloxOutput = function(options)
		if options == nil then
			options = {}
		end
		return LogEventRobloxOutputSink.new(options)
	end
	_container.RobloxOutput = RobloxOutput
	--[[
		*
		* Write a "Fatal" message to the default logger
		* @param template
		* @param args
	]]
	local function Fatal(template, ...)
		local args = { ... }
		return defaultLogger:Fatal(template, unpack(args))
	end
	_container.Fatal = Fatal
	--[[
		*
		* Write a "Verbose" message to the default logger
		* @param template
		* @param args
	]]
	local function Verbose(template, ...)
		local args = { ... }
		defaultLogger:Verbose(template, unpack(args))
	end
	_container.Verbose = Verbose
	--[[
		*
		* Write an "Information" message to the default logger
		* @param template
		* @param args
	]]
	local function Info(template, ...)
		local args = { ... }
		defaultLogger:Info(template, unpack(args))
	end
	_container.Info = Info
	--[[
		*
		* Write a "Debugging" message to the default logger
		* @param template
		* @param args
	]]
	local function Debug(template, ...)
		local args = { ... }
		defaultLogger:Debug(template, unpack(args))
	end
	_container.Debug = Debug
	--[[
		*
		* Write a "Warning" message to the default logger
		* @param template
		* @param args
	]]
	local function Warn(template, ...)
		local args = { ... }
		defaultLogger:Warn(template, unpack(args))
	end
	_container.Warn = Warn
	--[[
		*
		* Write an "Error" message to the default logger
		* @param template
		* @param args
	]]
	local function Error(template, ...)
		local args = { ... }
		return defaultLogger:Error(template, unpack(args))
	end
	_container.Error = Error
	--[[
		*
		* Creates a logger that enriches log events with the specified context as the property `SourceContext`.
		* @param context The tag to use
	]]
	local function ForContext(context, contextConfiguration)
		return defaultLogger:ForContext(context, contextConfiguration)
	end
	_container.ForContext = ForContext
	--[[
		*
		* Creates a logger that nriches log events with the specified property
		* @param name The name of the property
		* @param value The value of the property
	]]
	local function ForProperty(name, value)
		return defaultLogger:ForProperty(name, value)
	end
	_container.ForProperty = ForProperty
	--[[
		*
		* Creates a logger that enriches log events with the specified properties
		* @param props The properties
	]]
	local function ForProperties(props)
		return defaultLogger:ForProperties(props)
	end
	_container.ForProperties = ForProperties
	--[[
		*
		* Creates a logger that enriches log events with the `SourceContext` as the containing script
	]]
	local function ForScript(scriptContextConfiguration)
		-- Unfortunately have to duplicate here, since `debug.info`.
		local s = debug.info(2, "s")
		local copy = defaultLogger:Copy()
		local _result = scriptContextConfiguration
		if _result ~= nil then
			_result(copy)
		end
		return copy:EnrichWithProperties({
			SourceContext = s,
			SourceKind = "Script",
		}):Create()
	end
	_container.ForScript = ForScript
	--[[
		*
		* Set the minimum log level for the default logger
	]]
	local function SetMinLogLevel(logLevel)
		defaultLogger:SetMinLogLevel(logLevel)
	end
	_container.SetMinLogLevel = SetMinLogLevel
	--[[
		*
		* Creates a logger that enriches log events with `SourceContext` as the specified function
	]]
	local function ForFunction(func, funcContextConfiguration)
		return defaultLogger:ForFunction(func, funcContextConfiguration)
	end
	_container.ForFunction = ForFunction
end
local default = Log
exports.default = default
return exports
end

-- module: include\node_modules\@rbxts\log\out\Configuration.lua
__tape.chunks["include/node_modules/@rbxts/log/out/Configuration.lua"] = function(script)
-- Compiled with roblox-ts v1.3.3
local TS = _G[script]
local LogEventPropertyEnricher = TS.import(script, script.Parent, "Core", "LogEventPropertyEnricher").LogEventPropertyEnricher
local LogLevel = TS.import(script, script.Parent, "Core").LogLevel
local LogEventCallbackSink = TS.import(script, script.Parent, "Core", "LogEventCallbackSink").LogEventCallbackSink
local RunService = game:GetService("RunService")
local LogConfiguration
do
	LogConfiguration = setmetatable({}, {
		__tostring = function()
			return "LogConfiguration"
		end,
	})
	LogConfiguration.__index = LogConfiguration
	function LogConfiguration.new(...)
		local self = setmetatable({}, LogConfiguration)
		return self:constructor(...) or self
	end
	function LogConfiguration:constructor(logger)
		self.logger = logger
		self.sinks = {}
		self.enrichers = {}
		self.logLevel = if RunService:IsStudio() then LogLevel.Debugging else LogLevel.Information
	end
	function LogConfiguration:WriteTo(sink, configure)
		local _result = configure
		if _result ~= nil then
			_result(sink)
		end
		local _sinks = self.sinks
		table.insert(_sinks, sink)
		return self
	end
	function LogConfiguration:WriteToCallback(sinkCallback, configure)
		local sink = LogEventCallbackSink.new(sinkCallback)
		local _result = configure
		if _result ~= nil then
			_result(sink)
		end
		local _sinks = self.sinks
		table.insert(_sinks, sink)
		return self
	end
	function LogConfiguration:Enrich(enricher)
		if type(enricher) == "function" then
		else
			local _enrichers = self.enrichers
			table.insert(_enrichers, enricher)
		end
		return self
	end
	function LogConfiguration:EnrichWithProperty(propertyName, value, configure)
		return self:EnrichWithProperties({
			[propertyName] = value,
		}, configure)
	end
	function LogConfiguration:EnrichWithProperties(props, configure)
		local enricher = LogEventPropertyEnricher.new(props)
		local _result = configure
		if _result ~= nil then
			_result(enricher)
		end
		local _enrichers = self.enrichers
		table.insert(_enrichers, enricher)
		return self
	end
	function LogConfiguration:SetMinLogLevel(logLevel)
		self.logLevel = logLevel
		return self
	end
	function LogConfiguration:Create()
		self.logger:SetSinks(self.sinks)
		self.logger:SetEnrichers(self.enrichers)
		self.logger:SetMinLogLevel(self.logLevel)
		return self.logger
	end
end
return {
	LogConfiguration = LogConfiguration,
}
end

-- module: include\node_modules\@rbxts\log\out\Logger.lua
__tape.chunks["include/node_modules/@rbxts/log/out/Logger.lua"] = function(script)
-- Compiled with roblox-ts v1.3.3
local TS = _G[script]
local MessageTemplateParser = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out.MessageTemplateParser).MessageTemplateParser
local _MessageTemplateToken = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out.MessageTemplateToken)
local DestructureMode = _MessageTemplateToken.DestructureMode
local TemplateTokenKind = _MessageTemplateToken.TemplateTokenKind
local LogLevel = TS.import(script, script.Parent, "Core").LogLevel
local LogConfiguration = TS.import(script, script.Parent, "Configuration").LogConfiguration
local PlainTextMessageTemplateRenderer = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out).PlainTextMessageTemplateRenderer
local RbxSerializer = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out.RbxSerializer).RbxSerializer
local Logger
do
	Logger = setmetatable({}, {
		__tostring = function()
			return "Logger"
		end,
	})
	Logger.__index = Logger
	function Logger.new(...)
		local self = setmetatable({}, Logger)
		return self:constructor(...) or self
	end
	function Logger:constructor()
		self.logLevel = LogLevel.Information
		self.sinks = {}
		self.enrichers = {}
	end
	function Logger:configure()
		return LogConfiguration.new(Logger.new())
	end
	function Logger:SetSinks(sinks)
		self.sinks = sinks
	end
	function Logger:SetEnrichers(enrichers)
		self.enrichers = enrichers
	end
	function Logger:SetMinLogLevel(logLevel)
		self.logLevel = logLevel
	end
	function Logger:default()
		return self.defaultLogger
	end
	function Logger:_serializeValue(value)
		if typeof(value) == "Vector3" then
			return {
				X = value.X,
				Y = value.Y,
				Z = value.Z,
			}
		elseif typeof(value) == "Vector2" then
			return {
				X = value.X,
				Y = value.Y,
			}
		elseif typeof(value) == "Instance" then
			return value:GetFullName()
		elseif typeof(value) == "EnumItem" then
			return tostring(value)
		elseif type(value) == "string" or (type(value) == "number" or (type(value) == "boolean" or type(value) == "table")) then
			return value
		else
			return tostring(value)
		end
	end
	function Logger:Write(logLevel, template, ...)
		local args = { ... }
		local message = {
			Level = logLevel,
			SourceContext = nil,
			Template = template,
			Timestamp = DateTime.now():ToIsoDate(),
		}
		local tokens = MessageTemplateParser.GetTokens(template)
		local _arg0 = function(t)
			return t.kind == TemplateTokenKind.Property
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(tokens) do
			if _arg0(_v, _k - 1, tokens) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local propertyTokens = _newValue
		local idx = 0
		for _, token in ipairs(propertyTokens) do
			local _exp = args
			local _original = idx
			idx += 1
			local arg = _exp[_original + 1]
			if idx <= #args then
				if arg ~= nil then
					if token.destructureMode == DestructureMode.ToString then
						message[token.propertyName] = tostring(arg)
					else
						message[token.propertyName] = if type(arg) == "table" then arg else RbxSerializer.Serialize(arg)
					end
				end
			end
		end
		for _, enricher in ipairs(self.enrichers) do
			local toApply = {}
			enricher:Enrich(message, toApply)
			for key, value in pairs(toApply) do
				message[key] = if type(value) == "table" then value else RbxSerializer.Serialize(value)
			end
		end
		for _, sink in ipairs(self.sinks) do
			sink:Emit(message)
		end
		return PlainTextMessageTemplateRenderer.new(tokens):Render(message)
	end
	function Logger:GetLevel()
		return self.logLevel
	end
	function Logger:Verbose(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Verbose then
			return nil
		end
		self:Write(LogLevel.Verbose, template, unpack(args))
	end
	function Logger:Info(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Information then
			return nil
		end
		self:Write(LogLevel.Information, template, unpack(args))
	end
	function Logger:Debug(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Debugging then
			return nil
		end
		self:Write(LogLevel.Debugging, template, unpack(args))
	end
	function Logger:Warn(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Warning then
			return nil
		end
		self:Write(LogLevel.Warning, template, unpack(args))
	end
	function Logger:Error(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Error then
			return nil
		end
		return self:Write(LogLevel.Error, template, unpack(args))
	end
	function Logger:Fatal(template, ...)
		local args = { ... }
		return self:Write(LogLevel.Fatal, template, unpack(args))
	end
	function Logger:Copy()
		local config = LogConfiguration.new(Logger.new())
		config:SetMinLogLevel(self:GetLevel())
		for _, sink in ipairs(self.sinks) do
			config:WriteTo(sink)
		end
		for _, enricher in ipairs(self.enrichers) do
			config:Enrich(enricher)
		end
		return config
	end
	function Logger:ForContext(context, contextConfiguration)
		local copy = self:Copy()
		local sourceContext
		if typeof(context) == "Instance" then
			sourceContext = context:GetFullName()
		else
			sourceContext = tostring(context)
		end
		local _result = contextConfiguration
		if _result ~= nil then
			_result(copy)
		end
		return copy:EnrichWithProperties({
			SourceContext = sourceContext,
			SourceKind = "Context",
		}):Create()
	end
	function Logger:ForScript(scriptContextConfiguration)
		local s = debug.info(2, "s")
		local copy = self:Copy()
		local _result = scriptContextConfiguration
		if _result ~= nil then
			_result(copy)
		end
		return copy:EnrichWithProperties({
			SourceContext = s,
			SourceKind = "Script",
		}):Create()
	end
	function Logger:ForFunction(func, funcContextConfiguration)
		local funcName, funcLine, funcSource = debug.info(func, "nls")
		local copy = self:Copy()
		local _result = funcContextConfiguration
		if _result ~= nil then
			_result(copy)
		end
		local _fn = copy
		local _object = {}
		local _left = "SourceContext"
		local _condition = funcName
		if _condition == nil then
			_condition = "(anonymous)"
		end
		_object[_left] = "function '" .. (_condition .. "'")
		_object.SourceLine = funcLine
		_object.SourceFile = funcSource
		_object.SourceKind = "Function"
		return _fn:EnrichWithProperties(_object):Create()
	end
	function Logger:ForProperty(name, value)
		return self:Copy():EnrichWithProperty(name, value):Create()
	end
	function Logger:ForProperties(props)
		return self:Copy():EnrichWithProperties(props):Create()
	end
	Logger.defaultLogger = Logger.new()
end
return {
	Logger = Logger,
}
end

-- module: include\node_modules\@rbxts\log\out\Core\init.lua
__tape.chunks["include/node_modules/@rbxts/log/out/Core/init.lua"] = function(script)
-- Compiled with roblox-ts v1.3.3
local LogLevel
do
	local _inverse = {}
	LogLevel = setmetatable({}, {
		__index = _inverse,
	})
	LogLevel.Verbose = 0
	_inverse[0] = "Verbose"
	LogLevel.Debugging = 1
	_inverse[1] = "Debugging"
	LogLevel.Information = 2
	_inverse[2] = "Information"
	LogLevel.Warning = 3
	_inverse[3] = "Warning"
	LogLevel.Error = 4
	_inverse[4] = "Error"
	LogLevel.Fatal = 5
	_inverse[5] = "Fatal"
end
return {
	LogLevel = LogLevel,
}
end

-- module: include\node_modules\@rbxts\log\out\Core\LogEventCallbackSink.lua
__tape.chunks["include/node_modules/@rbxts/log/out/Core/LogEventCallbackSink.lua"] = function(script)
-- Compiled with roblox-ts v1.3.3
local LogEventCallbackSink
do
	LogEventCallbackSink = setmetatable({}, {
		__tostring = function()
			return "LogEventCallbackSink"
		end,
	})
	LogEventCallbackSink.__index = LogEventCallbackSink
	function LogEventCallbackSink.new(...)
		local self = setmetatable({}, LogEventCallbackSink)
		return self:constructor(...) or self
	end
	function LogEventCallbackSink:constructor(callback)
		self.callback = callback
	end
	function LogEventCallbackSink:Emit(message)
		local _binding = self
		local minLogLevel = _binding.minLogLevel
		if minLogLevel == nil or message.Level >= minLogLevel then
			self.callback(message)
		end
	end
	function LogEventCallbackSink:SetMinLogLevel(logLevel)
		self.minLogLevel = logLevel
	end
end
return {
	LogEventCallbackSink = LogEventCallbackSink,
}
end

-- module: include\node_modules\@rbxts\log\out\Core\LogEventPropertyEnricher.lua
__tape.chunks["include/node_modules/@rbxts/log/out/Core/LogEventPropertyEnricher.lua"] = function(script)
-- Compiled with roblox-ts v1.3.3
local LogEventPropertyEnricher
do
	LogEventPropertyEnricher = setmetatable({}, {
		__tostring = function()
			return "LogEventPropertyEnricher"
		end,
	})
	LogEventPropertyEnricher.__index = LogEventPropertyEnricher
	function LogEventPropertyEnricher.new(...)
		local self = setmetatable({}, LogEventPropertyEnricher)
		return self:constructor(...) or self
	end
	function LogEventPropertyEnricher:constructor(props)
		self.props = props
	end
	function LogEventPropertyEnricher:Enrich(message, properties)
		local minLogLevel = self.minLogLevel
		if minLogLevel == nil or message.Level >= minLogLevel then
			for k, v in pairs(self.props) do
				properties[k] = v
			end
		end
	end
	function LogEventPropertyEnricher:SetMinLogLevel(minLogLevel)
		self.minLogLevel = minLogLevel
	end
end
return {
	LogEventPropertyEnricher = LogEventPropertyEnricher,
}
end

-- module: include\node_modules\@rbxts\log\out\Core\LogEventRobloxOutputSink.lua
__tape.chunks["include/node_modules/@rbxts/log/out/Core/LogEventRobloxOutputSink.lua"] = function(script)
-- Compiled with roblox-ts v1.3.3
local TS = _G[script]
local _message_templates = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out)
local MessageTemplateParser = _message_templates.MessageTemplateParser
local PlainTextMessageTemplateRenderer = _message_templates.PlainTextMessageTemplateRenderer
local LogLevel = TS.import(script, script.Parent).LogLevel
local LogEventRobloxOutputSink
do
	LogEventRobloxOutputSink = setmetatable({}, {
		__tostring = function()
			return "LogEventRobloxOutputSink"
		end,
	})
	LogEventRobloxOutputSink.__index = LogEventRobloxOutputSink
	function LogEventRobloxOutputSink.new(...)
		local self = setmetatable({}, LogEventRobloxOutputSink)
		return self:constructor(...) or self
	end
	function LogEventRobloxOutputSink:constructor(options)
		self.options = options
	end
	function LogEventRobloxOutputSink:Emit(message)
		local _binding = self.options
		local TagFormat = _binding.TagFormat
		if TagFormat == nil then
			TagFormat = "short"
		end
		local ErrorsTreatedAsExceptions = _binding.ErrorsTreatedAsExceptions
		local Prefix = _binding.Prefix
		if message.Level >= LogLevel.Error and ErrorsTreatedAsExceptions then
			return nil
		end
		local template = PlainTextMessageTemplateRenderer.new(MessageTemplateParser.GetTokens(message.Template))
		local _time = DateTime.fromIsoDate(message.Timestamp)
		if _time ~= nil then
			_time = _time:FormatLocalTime("HH:mm:ss", "en-us")
		end
		local time = _time
		local tag
		local _exp = message.Level
		repeat
			if _exp == (LogLevel.Verbose) then
				tag = if TagFormat == "short" then "VRB" else "VERBOSE"
				break
			end
			if _exp == (LogLevel.Debugging) then
				tag = if TagFormat == "short" then "DBG" else "DEBUG"
				break
			end
			if _exp == (LogLevel.Information) then
				tag = if TagFormat == "short" then "INF" else "INFO"
				break
			end
			if _exp == (LogLevel.Warning) then
				tag = if TagFormat == "short" then "WRN" else "WARNING"
				break
			end
			if _exp == (LogLevel.Error) then
				tag = if TagFormat == "short" then "ERR" else "ERROR"
				break
			end
			if _exp == (LogLevel.Fatal) then
				tag = if TagFormat == "short" then "FTL" else "FATAL"
				break
			end
		until true
		local messageRendered = template:Render(message)
		local formattedMessage = if Prefix ~= nil then "[" .. (Prefix .. ("] [" .. (tag .. ("] " .. messageRendered)))) else "[" .. (tag .. ("] " .. messageRendered))
		if message.Level >= LogLevel.Warning then
			warn(formattedMessage)
		else
			print(formattedMessage)
		end
	end
end
return {
	LogEventRobloxOutputSink = LogEventRobloxOutputSink,
}
end

-- module: include\node_modules\@rbxts\message-templates\out\init.lua
__tape.chunks["include/node_modules/@rbxts/message-templates/out/init.lua"] = function(script)
-- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local exports = {}
exports.MessageTemplateParser = TS.import(script, script, "MessageTemplateParser").MessageTemplateParser
exports.MessageTemplateRenderer = TS.import(script, script, "MessageTemplateRenderer").MessageTemplateRenderer
exports.PlainTextMessageTemplateRenderer = TS.import(script, script, "PlainTextMessageTemplateRenderer").PlainTextMessageTemplateRenderer
exports.TemplateTokenKind = TS.import(script, script, "MessageTemplateToken").TemplateTokenKind
return exports
end

-- module: include\node_modules\@rbxts\message-templates\out\MessageTemplate.lua
__tape.chunks["include/node_modules/@rbxts/message-templates/out/MessageTemplate.lua"] = function(script)
-- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local TemplateTokenKind = TS.import(script, script.Parent, "MessageTemplateToken").TemplateTokenKind
local HttpService = game:GetService("HttpService")
local MessageTemplate
do
	MessageTemplate = setmetatable({}, {
		__tostring = function()
			return "MessageTemplate"
		end,
	})
	MessageTemplate.__index = MessageTemplate
	function MessageTemplate.new(...)
		local self = setmetatable({}, MessageTemplate)
		return self:constructor(...) or self
	end
	function MessageTemplate:constructor(template, tokens)
		self.template = template
		self.tokens = tokens
		local _arg0 = function(f)
			return f.kind == TemplateTokenKind.Property
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(tokens) do
			if _arg0(_v, _k - 1, tokens) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		self.properties = _newValue
	end
	function MessageTemplate:GetTokens()
		return self.tokens
	end
	function MessageTemplate:GetProperties()
		return self.properties
	end
	function MessageTemplate:GetText()
		return self.template
	end
end
return {
	MessageTemplate = MessageTemplate,
}
end

-- module: include\node_modules\@rbxts\message-templates\out\MessageTemplateParser.lua
__tape.chunks["include/node_modules/@rbxts/message-templates/out/MessageTemplateParser.lua"] = function(script)
-- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local _MessageTemplateToken = TS.import(script, script.Parent, "MessageTemplateToken")
local DestructureMode = _MessageTemplateToken.DestructureMode
local TemplateTokenKind = _MessageTemplateToken.TemplateTokenKind
local MessageTemplateParser = {}
do
	local _container = MessageTemplateParser
	local tokenize
	local function GetTokens(message)
		local tokens = {}
		for _result in tokenize(message).next do
			if _result.done then
				break
			end
			local token = _result.value
			-- ▼ Array.push ▼
			tokens[#tokens + 1] = token
			-- ▲ Array.push ▲
		end
		return tokens
	end
	_container.GetTokens = GetTokens
	local parseText, parseProperty
	function tokenize(messageTemplate)
		return TS.generator(function()
			if #messageTemplate == 0 then
				local _arg0 = {
					kind = TemplateTokenKind.Text,
					text = "",
				}
				coroutine.yield(_arg0)
				return nil
			end
			local nextIndex = 0
			while true do
				local startIndex = nextIndex
				local textToken
				local _binding = parseText(nextIndex, messageTemplate)
				nextIndex = _binding[1]
				textToken = _binding[2]
				if nextIndex > startIndex then
					coroutine.yield(textToken)
				end
				if nextIndex >= #messageTemplate then
					break
				end
				startIndex = nextIndex
				local propertyToken
				local _binding_1 = parseProperty(nextIndex, messageTemplate)
				nextIndex = _binding_1[1]
				propertyToken = _binding_1[2]
				if startIndex < nextIndex then
					coroutine.yield(propertyToken)
				end
				if nextIndex > #messageTemplate then
					break
				end
			end
		end)
	end
	function parseText(startAt, messageTemplate)
		local results = {}
		repeat
			do
				local char = string.sub(messageTemplate, startAt, startAt)
				if char == "{" then
					local _arg0 = startAt + 1
					local _arg1 = startAt + 1
					local nextChar = string.sub(messageTemplate, _arg0, _arg1)
					if nextChar == "{" then
						-- ▼ Array.push ▼
						results[#results + 1] = char
						-- ▲ Array.push ▲
						startAt += 1
					else
						break
					end
				else
					-- ▼ Array.push ▼
					results[#results + 1] = char
					-- ▲ Array.push ▲
					local _arg0 = startAt + 1
					local _arg1 = startAt + 1
					local nextChar = string.sub(messageTemplate, _arg0, _arg1)
					if char == "}" then
						if nextChar == "}" then
							startAt += 1
						end
					end
				end
				startAt += 1
			end
		until not (startAt <= #messageTemplate)
		local _ptr = {
			kind = TemplateTokenKind.Text,
		}
		local _left = "text"
		-- ▼ ReadonlyArray.join ▼
		local _arg0 = ""
		if _arg0 == nil then
			_arg0 = ", "
		end
		-- ▲ ReadonlyArray.join ▲
		_ptr[_left] = table.concat(results, _arg0)
		return { startAt, _ptr }
	end
	local function readWhile(startAt, text, condition)
		local result = ""
		while startAt < #text and condition(string.sub(text, startAt, startAt)) do
			local char = string.sub(text, startAt, startAt)
			result ..= char
			startAt += 1
		end
		return { startAt, result }
	end
	local function isValidNameCharacter(char)
		return (string.match(char, "[%w_]")) ~= nil
	end
	local function isValidDestructureHint(char)
		return (string.match(char, "[@$]")) ~= nil
	end
	function parseProperty(index, messageTemplate)
		index += 1
		local propertyName
		local _binding = readWhile(index, messageTemplate, function(c)
			return isValidDestructureHint(c) or (isValidNameCharacter(c) and c ~= "}")
		end)
		index = _binding[1]
		propertyName = _binding[2]
		if index > #messageTemplate then
			local _arg0 = {
				kind = TemplateTokenKind.Text,
				text = propertyName,
			}
			return { index, _arg0 }
		end
		local destructureMode = DestructureMode.Default
		local char = string.sub(propertyName, 1, 1)
		if isValidDestructureHint(char) then
			repeat
				if char == ("@") then
					destructureMode = DestructureMode.Destructure
					break
				end
				if char == ("$") then
					destructureMode = DestructureMode.ToString
					break
				end
				destructureMode = DestructureMode.Default
			until true
			propertyName = string.sub(propertyName, 2)
		end
		local _exp = index + 1
		local _arg0 = {
			kind = TemplateTokenKind.Property,
			propertyName = propertyName,
			destructureMode = destructureMode,
		}
		return { _exp, _arg0 }
	end
end
return {
	MessageTemplateParser = MessageTemplateParser,
}
end

-- module: include\node_modules\@rbxts\message-templates\out\MessageTemplateRenderer.lua
__tape.chunks["include/node_modules/@rbxts/message-templates/out/MessageTemplateRenderer.lua"] = function(script)
-- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local TemplateTokenKind = TS.import(script, script.Parent, "MessageTemplateToken").TemplateTokenKind
local MessageTemplateRenderer
do
	MessageTemplateRenderer = {}
	function MessageTemplateRenderer:constructor(tokens)
		self.tokens = tokens
	end
	function MessageTemplateRenderer:Render(properties)
		local result = ""
		for _, token in ipairs(self.tokens) do
			local _exp = token.kind
			repeat
				local _fallthrough = false
				if _exp == (TemplateTokenKind.Property) then
					result ..= self:RenderPropertyToken(token, properties[token.propertyName])
					break
				end
				if _exp == (TemplateTokenKind.Text) then
					result ..= self:RenderTextToken(token)
				end
			until true
		end
		return result
	end
end
return {
	MessageTemplateRenderer = MessageTemplateRenderer,
}
end

-- module: include\node_modules\@rbxts\message-templates\out\MessageTemplateToken.lua
__tape.chunks["include/node_modules/@rbxts/message-templates/out/MessageTemplateToken.lua"] = function(script)
-- Compiled with roblox-ts v1.2.2
local TemplateTokenKind
do
	local _inverse = {}
	TemplateTokenKind = setmetatable({}, {
		__index = _inverse,
	})
	TemplateTokenKind.Text = 0
	_inverse[0] = "Text"
	TemplateTokenKind.Property = 1
	_inverse[1] = "Property"
end
local DestructureMode
do
	local _inverse = {}
	DestructureMode = setmetatable({}, {
		__index = _inverse,
	})
	DestructureMode.Default = 0
	_inverse[0] = "Default"
	DestructureMode.ToString = 1
	_inverse[1] = "ToString"
	DestructureMode.Destructure = 2
	_inverse[2] = "Destructure"
end
local function createNode(prop)
	return prop
end
return {
	createNode = createNode,
	TemplateTokenKind = TemplateTokenKind,
	DestructureMode = DestructureMode,
}
end

-- module: include\node_modules\@rbxts\message-templates\out\PlainTextMessageTemplateRenderer.lua
__tape.chunks["include/node_modules/@rbxts/message-templates/out/PlainTextMessageTemplateRenderer.lua"] = function(script)
-- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local RbxSerializer = TS.import(script, script.Parent, "RbxSerializer").RbxSerializer
local MessageTemplateRenderer = TS.import(script, script.Parent, "MessageTemplateRenderer").MessageTemplateRenderer
local HttpService = game:GetService("HttpService")
local PlainTextMessageTemplateRenderer
do
	local super = MessageTemplateRenderer
	PlainTextMessageTemplateRenderer = setmetatable({}, {
		__tostring = function()
			return "PlainTextMessageTemplateRenderer"
		end,
		__index = super,
	})
	PlainTextMessageTemplateRenderer.__index = PlainTextMessageTemplateRenderer
	function PlainTextMessageTemplateRenderer.new(...)
		local self = setmetatable({}, PlainTextMessageTemplateRenderer)
		return self:constructor(...) or self
	end
	function PlainTextMessageTemplateRenderer:constructor(...)
		super.constructor(self, ...)
	end
	function PlainTextMessageTemplateRenderer:RenderPropertyToken(propertyToken, value)
		local serialized = RbxSerializer.Serialize(value, propertyToken.destructureMode)
		if type(serialized) == "table" then
			return HttpService:JSONEncode(serialized)
		else
			return tostring(serialized)
		end
	end
	function PlainTextMessageTemplateRenderer:RenderTextToken(textToken)
		return textToken.text
	end
end
return {
	PlainTextMessageTemplateRenderer = PlainTextMessageTemplateRenderer,
}
end

-- module: include\node_modules\@rbxts\message-templates\out\RbxSerializer.lua
__tape.chunks["include/node_modules/@rbxts/message-templates/out/RbxSerializer.lua"] = function(script)
-- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local DestructureMode = TS.import(script, script.Parent, "MessageTemplateToken").DestructureMode
--[[
	*
	* Handles serialization of Roblox objects for use in event data
]]
local RbxSerializer = {}
do
	local _container = RbxSerializer
	local HttpService = game:GetService("HttpService")
	local function SerializeVector3(value)
		return {
			X = value.X,
			Y = value.Y,
			Z = value.Z,
		}
	end
	_container.SerializeVector3 = SerializeVector3
	local function SerializeVector2(value)
		return {
			X = value.X,
			Y = value.Y,
		}
	end
	_container.SerializeVector2 = SerializeVector2
	local function SerializeNumberRange(numberRange)
		return {
			Min = numberRange.Min,
			Max = numberRange.Max,
		}
	end
	_container.SerializeNumberRange = SerializeNumberRange
	local function SerializeDateTime(dateTime)
		return dateTime:ToIsoDate()
	end
	_container.SerializeDateTime = SerializeDateTime
	local function SerializeEnumItem(enumItem)
		return tostring(enumItem)
	end
	_container.SerializeEnumItem = SerializeEnumItem
	local function SerializeUDim(value)
		return {
			Offset = value.Offset,
			Scale = value.Scale,
		}
	end
	_container.SerializeUDim = SerializeUDim
	local function SerializeUDim2(value)
		return {
			X = SerializeUDim(value.X),
			Y = SerializeUDim(value.Y),
		}
	end
	_container.SerializeUDim2 = SerializeUDim2
	local function SerializeColor3(color3)
		return {
			R = color3.R,
			G = color3.G,
			B = color3.B,
		}
	end
	_container.SerializeColor3 = SerializeColor3
	local function SerializeBrickColor(color)
		return SerializeColor3(color.Color)
	end
	_container.SerializeBrickColor = SerializeBrickColor
	local function SerializeRect(value)
		return {
			RectMin = SerializeVector2(value.Min),
			RectMax = SerializeVector2(value.Max),
			RectHeight = value.Height,
			RectWidth = value.Width,
		}
	end
	_container.SerializeRect = SerializeRect
	local function SerializePathWaypoint(value)
		return {
			WaypointAction = SerializeEnumItem(value.Action),
			WaypointPosition = SerializeVector3(value.Position),
		}
	end
	_container.SerializePathWaypoint = SerializePathWaypoint
	local function SerializeColorSequenceKeypoint(value)
		return {
			ColorTime = value.Time,
			ColorValue = SerializeColor3(value.Value),
		}
	end
	_container.SerializeColorSequenceKeypoint = SerializeColorSequenceKeypoint
	local function SerializeColorSequence(value)
		local _ptr = {}
		local _left = "ColorKeypoints"
		local _keypoints = value.Keypoints
		local _arg0 = function(v)
			return SerializeColorSequenceKeypoint(v)
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#_keypoints)
		for _k, _v in ipairs(_keypoints) do
			_newValue[_k] = _arg0(_v, _k - 1, _keypoints)
		end
		-- ▲ ReadonlyArray.map ▲
		_ptr[_left] = _newValue
		return _ptr
	end
	_container.SerializeColorSequence = SerializeColorSequence
	local function SerializeNumberSequenceKeypoint(value)
		return {
			NumberTime = value.Time,
			NumberValue = value.Value,
		}
	end
	_container.SerializeNumberSequenceKeypoint = SerializeNumberSequenceKeypoint
	local function SerializeNumberSequence(value)
		local _ptr = {}
		local _left = "NumberKeypoints"
		local _keypoints = value.Keypoints
		local _arg0 = function(v)
			return SerializeNumberSequenceKeypoint(v)
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#_keypoints)
		for _k, _v in ipairs(_keypoints) do
			_newValue[_k] = _arg0(_v, _k - 1, _keypoints)
		end
		-- ▲ ReadonlyArray.map ▲
		_ptr[_left] = _newValue
		return _ptr
	end
	_container.SerializeNumberSequence = SerializeNumberSequence
	local function Serialize(value, destructureMode)
		if destructureMode == nil then
			destructureMode = DestructureMode.Default
		end
		if destructureMode == DestructureMode.ToString then
			return tostring(value)
		end
		if typeof(value) == "Instance" then
			return value:GetFullName()
		elseif type(value) == "vector" or typeof(value) == "Vector3int16" then
			return SerializeVector3(value)
		elseif typeof(value) == "Vector2" or typeof(value) == "Vector2int16" then
			return SerializeVector2(value)
		elseif typeof(value) == "DateTime" then
			return SerializeDateTime(value)
		elseif typeof(value) == "EnumItem" then
			return SerializeEnumItem(value)
		elseif typeof(value) == "NumberRange" then
			return SerializeNumberRange(value)
		elseif typeof(value) == "UDim" then
			return SerializeUDim(value)
		elseif typeof(value) == "UDim2" then
			return SerializeUDim2(value)
		elseif typeof(value) == "Color3" then
			return SerializeColor3(value)
		elseif typeof(value) == "BrickColor" then
			return SerializeBrickColor(value)
		elseif typeof(value) == "Rect" then
			return SerializeRect(value)
		elseif typeof(value) == "PathWaypoint" then
			return SerializePathWaypoint(value)
		elseif typeof(value) == "ColorSequenceKeypoint" then
			return SerializeColorSequenceKeypoint(value)
		elseif typeof(value) == "ColorSequence" then
			return SerializeColorSequence(value)
		elseif typeof(value) == "NumberSequenceKeypoint" then
			return SerializeNumberSequenceKeypoint(value)
		elseif typeof(value) == "NumberSequence" then
			return SerializeNumberSequence(value)
		elseif type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
			return value
		elseif type(value) == "table" then
			return HttpService:JSONEncode(value)
		elseif type(value) == "nil" then
			return nil
		else
			error("Destructuring of '" .. typeof(value) .. "' not supported by Serializer")
		end
	end
	_container.Serialize = Serialize
end
return {
	RbxSerializer = RbxSerializer,
}
end

-- module: include\node_modules\@rbxts\object-utils\init.lua
__tape.chunks["include/node_modules/@rbxts/object-utils/init.lua"] = function(script)
local HttpService = game:GetService("HttpService")

local Object = {}

function Object.keys(object)
	local result = table.create(#object)
	for key in pairs(object) do
		result[#result + 1] = key
	end
	return result
end

function Object.values(object)
	local result = table.create(#object)
	for _, value in pairs(object) do
		result[#result + 1] = value
	end
	return result
end

function Object.entries(object)
	local result = table.create(#object)
	for key, value in pairs(object) do
		result[#result + 1] = { key, value }
	end
	return result
end

function Object.assign(toObj, ...)
	for i = 1, select("#", ...) do
		local arg = select(i, ...)
		if type(arg) == "table" then
			for key, value in pairs(arg) do
				toObj[key] = value
			end
		end
	end
	return toObj
end

function Object.copy(object)
	local result = table.create(#object)
	for k, v in pairs(object) do
		result[k] = v
	end
	return result
end

local function deepCopyHelper(object, encountered)
	local result = table.create(#object)
	encountered[object] = result

	for k, v in pairs(object) do
		if type(k) == "table" then
			k = encountered[k] or deepCopyHelper(k, encountered)
		end

		if type(v) == "table" then
			v = encountered[v] or deepCopyHelper(v, encountered)
		end

		result[k] = v
	end

	return result
end

function Object.deepCopy(object)
	return deepCopyHelper(object, {})
end

function Object.deepEquals(a, b)
	-- a[k] == b[k]
	for k in pairs(a) do
		local av = a[k]
		local bv = b[k]
		if type(av) == "table" and type(bv) == "table" then
			local result = Object.deepEquals(av, bv)
			if not result then
				return false
			end
		elseif av ~= bv then
			return false
		end
	end

	-- extra keys in b
	for k in pairs(b) do
		if a[k] == nil then
			return false
		end
	end

	return true
end

function Object.toString(data)
	return HttpService:JSONEncode(data)
end

function Object.isEmpty(object)
	return next(object) == nil
end

function Object.fromEntries(entries)
	local entriesLen = #entries

	local result = table.create(entriesLen)
	if entries then
		for i = 1, entriesLen do
			local pair = entries[i]
			result[pair[1]] = pair[2]
		end
	end
	return result
end

return Object
end

-- module: include\node_modules\@rbxts\services\init.lua
__tape.chunks["include/node_modules/@rbxts/services/init.lua"] = function(script)
return setmetatable({}, {
	__index = function(self, serviceName)
		local service = game:GetService(serviceName)
		self[serviceName] = service
		return service
	end,
})
end

-- tree
__tape.buildTree("[[\"out\",\"init.lua\"],[[[\"helper\",\"helper.lua\"],[]],[[\"types\",\"types.lua\"],[]],[[\"class\",null],[[[\"block\",\"class/block.lua\"],[]],[[\"line\",\"class/line.lua\"],[]],[[\"logger\",\"class/logger.lua\"],[]]]],[[\"include\",null],[[[\"node_modules\",null],[[[\"@rbxts\",null],[[[\"llama\",null],[[[\"out\",\"include/node_modules/@rbxts/llama/out/init.lua\"],[[[\"equalObjects\",\"include/node_modules/@rbxts/llama/out/equalObjects.lua\"],[]],[[\"isEmpty\",\"include/node_modules/@rbxts/llama/out/isEmpty.lua\"],[]],[[\"None\",\"include/node_modules/@rbxts/llama/out/None.lua\"],[]],[[\"t\",\"include/node_modules/@rbxts/llama/out/t.lua\"],[]],[[\"Dictionary\",\"include/node_modules/@rbxts/llama/out/Dictionary/init.lua\"],[[[\"copy\",\"include/node_modules/@rbxts/llama/out/Dictionary/copy.lua\"],[]],[[\"copyDeep\",\"include/node_modules/@rbxts/llama/out/Dictionary/copyDeep.lua\"],[]],[[\"count\",\"include/node_modules/@rbxts/llama/out/Dictionary/count.lua\"],[]],[[\"equals\",\"include/node_modules/@rbxts/llama/out/Dictionary/equals.lua\"],[]],[[\"equalsDeep\",\"include/node_modules/@rbxts/llama/out/Dictionary/equalsDeep.lua\"],[]],[[\"every\",\"include/node_modules/@rbxts/llama/out/Dictionary/every.lua\"],[]],[[\"filter\",\"include/node_modules/@rbxts/llama/out/Dictionary/filter.lua\"],[]],[[\"flatten\",\"include/node_modules/@rbxts/llama/out/Dictionary/flatten.lua\"],[]],[[\"flip\",\"include/node_modules/@rbxts/llama/out/Dictionary/flip.lua\"],[]],[[\"fromLists\",\"include/node_modules/@rbxts/llama/out/Dictionary/fromLists.lua\"],[]],[[\"has\",\"include/node_modules/@rbxts/llama/out/Dictionary/has.lua\"],[]],[[\"includes\",\"include/node_modules/@rbxts/llama/out/Dictionary/includes.lua\"],[]],[[\"keys\",\"include/node_modules/@rbxts/llama/out/Dictionary/keys.lua\"],[]],[[\"map\",\"include/node_modules/@rbxts/llama/out/Dictionary/map.lua\"],[]],[[\"merge\",\"include/node_modules/@rbxts/llama/out/Dictionary/merge.lua\"],[]],[[\"mergeDeep\",\"include/node_modules/@rbxts/llama/out/Dictionary/mergeDeep.lua\"],[]],[[\"removeKey\",\"include/node_modules/@rbxts/llama/out/Dictionary/removeKey.lua\"],[]],[[\"removeKeys\",\"include/node_modules/@rbxts/llama/out/Dictionary/removeKeys.lua\"],[]],[[\"removeValue\",\"include/node_modules/@rbxts/llama/out/Dictionary/removeValue.lua\"],[]],[[\"removeValues\",\"include/node_modules/@rbxts/llama/out/Dictionary/removeValues.lua\"],[]],[[\"set\",\"include/node_modules/@rbxts/llama/out/Dictionary/set.lua\"],[]],[[\"some\",\"include/node_modules/@rbxts/llama/out/Dictionary/some.lua\"],[]],[[\"update\",\"include/node_modules/@rbxts/llama/out/Dictionary/update.lua\"],[]],[[\"values\",\"include/node_modules/@rbxts/llama/out/Dictionary/values.lua\"],[]]]],[[\"List\",\"include/node_modules/@rbxts/llama/out/List/init.lua\"],[[[\"concat\",\"include/node_modules/@rbxts/llama/out/List/concat.lua\"],[]],[[\"concatDeep\",\"include/node_modules/@rbxts/llama/out/List/concatDeep.lua\"],[]],[[\"copy\",\"include/node_modules/@rbxts/llama/out/List/copy.lua\"],[]],[[\"copyDeep\",\"include/node_modules/@rbxts/llama/out/List/copyDeep.lua\"],[]],[[\"count\",\"include/node_modules/@rbxts/llama/out/List/count.lua\"],[]],[[\"create\",\"include/node_modules/@rbxts/llama/out/List/create.lua\"],[]],[[\"equals\",\"include/node_modules/@rbxts/llama/out/List/equals.lua\"],[]],[[\"equalsDeep\",\"include/node_modules/@rbxts/llama/out/List/equalsDeep.lua\"],[]],[[\"every\",\"include/node_modules/@rbxts/llama/out/List/every.lua\"],[]],[[\"filter\",\"include/node_modules/@rbxts/llama/out/List/filter.lua\"],[]],[[\"find\",\"include/node_modules/@rbxts/llama/out/List/find.lua\"],[]],[[\"findLast\",\"include/node_modules/@rbxts/llama/out/List/findLast.lua\"],[]],[[\"findWhere\",\"include/node_modules/@rbxts/llama/out/List/findWhere.lua\"],[]],[[\"findWhereLast\",\"include/node_modules/@rbxts/llama/out/List/findWhereLast.lua\"],[]],[[\"first\",\"include/node_modules/@rbxts/llama/out/List/first.lua\"],[]],[[\"flatten\",\"include/node_modules/@rbxts/llama/out/List/flatten.lua\"],[]],[[\"includes\",\"include/node_modules/@rbxts/llama/out/List/includes.lua\"],[]],[[\"insert\",\"include/node_modules/@rbxts/llama/out/List/insert.lua\"],[]],[[\"last\",\"include/node_modules/@rbxts/llama/out/List/last.lua\"],[]],[[\"map\",\"include/node_modules/@rbxts/llama/out/List/map.lua\"],[]],[[\"pop\",\"include/node_modules/@rbxts/llama/out/List/pop.lua\"],[]],[[\"push\",\"include/node_modules/@rbxts/llama/out/List/push.lua\"],[]],[[\"reduce\",\"include/node_modules/@rbxts/llama/out/List/reduce.lua\"],[]],[[\"reduceRight\",\"include/node_modules/@rbxts/llama/out/List/reduceRight.lua\"],[]],[[\"removeIndex\",\"include/node_modules/@rbxts/llama/out/List/removeIndex.lua\"],[]],[[\"removeIndices\",\"include/node_modules/@rbxts/llama/out/List/removeIndices.lua\"],[]],[[\"removeValue\",\"include/node_modules/@rbxts/llama/out/List/removeValue.lua\"],[]],[[\"removeValues\",\"include/node_modules/@rbxts/llama/out/List/removeValues.lua\"],[]],[[\"reverse\",\"include/node_modules/@rbxts/llama/out/List/reverse.lua\"],[]],[[\"set\",\"include/node_modules/@rbxts/llama/out/List/set.lua\"],[]],[[\"shift\",\"include/node_modules/@rbxts/llama/out/List/shift.lua\"],[]],[[\"slice\",\"include/node_modules/@rbxts/llama/out/List/slice.lua\"],[]],[[\"some\",\"include/node_modules/@rbxts/llama/out/List/some.lua\"],[]],[[\"sort\",\"include/node_modules/@rbxts/llama/out/List/sort.lua\"],[]],[[\"splice\",\"include/node_modules/@rbxts/llama/out/List/splice.lua\"],[]],[[\"toSet\",\"include/node_modules/@rbxts/llama/out/List/toSet.lua\"],[]],[[\"unshift\",\"include/node_modules/@rbxts/llama/out/List/unshift.lua\"],[]],[[\"update\",\"include/node_modules/@rbxts/llama/out/List/update.lua\"],[]],[[\"zip\",\"include/node_modules/@rbxts/llama/out/List/zip.lua\"],[]],[[\"zipAll\",\"include/node_modules/@rbxts/llama/out/List/zipAll.lua\"],[]]]],[[\"Set\",\"include/node_modules/@rbxts/llama/out/Set/init.lua\"],[[[\"add\",\"include/node_modules/@rbxts/llama/out/Set/add.lua\"],[]],[[\"copy\",\"include/node_modules/@rbxts/llama/out/Set/copy.lua\"],[]],[[\"filter\",\"include/node_modules/@rbxts/llama/out/Set/filter.lua\"],[]],[[\"fromList\",\"include/node_modules/@rbxts/llama/out/Set/fromList.lua\"],[]],[[\"has\",\"include/node_modules/@rbxts/llama/out/Set/has.lua\"],[]],[[\"intersection\",\"include/node_modules/@rbxts/llama/out/Set/intersection.lua\"],[]],[[\"isSubset\",\"include/node_modules/@rbxts/llama/out/Set/isSubset.lua\"],[]],[[\"isSuperset\",\"include/node_modules/@rbxts/llama/out/Set/isSuperset.lua\"],[]],[[\"map\",\"include/node_modules/@rbxts/llama/out/Set/map.lua\"],[]],[[\"subtract\",\"include/node_modules/@rbxts/llama/out/Set/subtract.lua\"],[]],[[\"toList\",\"include/node_modules/@rbxts/llama/out/Set/toList.lua\"],[]],[[\"union\",\"include/node_modules/@rbxts/llama/out/Set/union.lua\"],[]]]]]]]],[[\"log\",null],[[[\"out\",\"include/node_modules/@rbxts/log/out/init.lua\"],[[[\"Configuration\",\"include/node_modules/@rbxts/log/out/Configuration.lua\"],[]],[[\"Logger\",\"include/node_modules/@rbxts/log/out/Logger.lua\"],[]],[[\"Core\",\"include/node_modules/@rbxts/log/out/Core/init.lua\"],[[[\"LogEventCallbackSink\",\"include/node_modules/@rbxts/log/out/Core/LogEventCallbackSink.lua\"],[]],[[\"LogEventPropertyEnricher\",\"include/node_modules/@rbxts/log/out/Core/LogEventPropertyEnricher.lua\"],[]],[[\"LogEventRobloxOutputSink\",\"include/node_modules/@rbxts/log/out/Core/LogEventRobloxOutputSink.lua\"],[]]]]]]]],[[\"message-templates\",null],[[[\"out\",\"include/node_modules/@rbxts/message-templates/out/init.lua\"],[[[\"MessageTemplate\",\"include/node_modules/@rbxts/message-templates/out/MessageTemplate.lua\"],[]],[[\"MessageTemplateParser\",\"include/node_modules/@rbxts/message-templates/out/MessageTemplateParser.lua\"],[]],[[\"MessageTemplateRenderer\",\"include/node_modules/@rbxts/message-templates/out/MessageTemplateRenderer.lua\"],[]],[[\"MessageTemplateToken\",\"include/node_modules/@rbxts/message-templates/out/MessageTemplateToken.lua\"],[]],[[\"PlainTextMessageTemplateRenderer\",\"include/node_modules/@rbxts/message-templates/out/PlainTextMessageTemplateRenderer.lua\"],[]],[[\"RbxSerializer\",\"include/node_modules/@rbxts/message-templates/out/RbxSerializer.lua\"],[]]]]]],[[\"object-utils\",\"include/node_modules/@rbxts/object-utils/init.lua\"],[]],[[\"services\",\"include/node_modules/@rbxts/services/init.lua\"],[]]]]]]]]]]")

return require("init.lua")
