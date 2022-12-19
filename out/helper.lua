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
