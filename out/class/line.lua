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
