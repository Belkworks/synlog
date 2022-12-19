-- Compiled with roblox-ts v2.0.4
local TS = _G[script]
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
local paddedLogHeaders = {}
local _exp_1 = Object.keys(logHeaders)
local _arg0_1 = function(key)
	paddedLogHeaders[key] = padStart(logHeaders[key], logHeaderWidth)
	return paddedLogHeaders[key]
end
for _k, _v in _exp_1 do
	_arg0_1(_v, _k - 1, _exp_1)
end
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
		local _arg0_2 = {
			id = id,
			line = line,
			entered = tick(),
			visible = false,
		}
		table.insert(_queue, _arg0_2)
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
			local _exp_2 = MessageTemplateParser.GetTokens(log.Template)
			local _arg0_2 = function(token)
				if token.kind == TemplateTokenKind.Text then
					return Text.white(token.text)
				end
				local prop = log[token.propertyName]
				local str = tostring(prop)
				local _exp_3 = typeof(prop)
				repeat
					if _exp_3 == "number" then
						return Text.color(str, Colors.Mint)
					end
					if _exp_3 == "string" then
						return Text.white(str)
					end
					return Text.color(str, Colors.Grey)
				until true
			end
			-- ▼ ReadonlyArray.map ▼
			local _newValue = table.create(#_exp_2)
			for _k, _v in _exp_2 do
				_newValue[_k] = _arg0_2(_v, _k - 1, _exp_2)
			end
			-- ▲ ReadonlyArray.map ▲
			local tokens = _newValue
			local prefix = log.SourceContext
			if prefix ~= nil then
				local _arg0_3 = Text.color("[" .. (prefix .. "] "), Colors.Grey)
				table.insert(tokens, 1, _arg0_3)
			end
			local _arg0_3 = {
				text = paddedLogHeaders[log.Level] .. " ",
				color = if labelColor then logColors[log.Level] else white,
				font = labelFont,
			}
			table.insert(tokens, 1, _arg0_3)
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
		local _arg0_2 = function(entry)
			return entry.id == id
		end
		-- ▼ ReadonlyArray.findIndex ▼
		local _result_1 = -1
		for _i, _v in _lines do
			if _arg0_2(_v, _i - 1, _lines) == true then
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
		local _arg0_2 = function(entry)
			return entry.id == id
		end
		-- ▼ ReadonlyArray.findIndex ▼
		local _result_1 = -1
		for _i, _v in _queue do
			if _arg0_2(_v, _i - 1, _queue) == true then
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
		local _arg0_2 = function(entry)
			return self:destroyEntry(entry)
		end
		for _k, _v in _lines do
			_arg0_2(_v, _k - 1, _lines)
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
		local _arg0_2 = function(entry)
			return entry.line:destroy()
		end
		for _k, _v in _lines do
			_arg0_2(_v, _k - 1, _lines)
		end
		table.clear(self.lines)
		table.clear(self.queue)
	end
end
return {
	logHeaders = logHeaders,
	logHeaderWidth = logHeaderWidth,
	DrawingLogger = DrawingLogger,
}
