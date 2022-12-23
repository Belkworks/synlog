import { Token } from "types";

export const Colors = {
	Red: new Color3(1, 0, 0),
	Green: new Color3(0, 1, 0),
	Blue: new Color3(0, 0, 1),

	Yellow: new Color3(1, 1, 0),
	Teal: new Color3(0, 1, 1),
	Magenta: new Color3(1, 0, 1),
	Orange: Color3.fromRGB(255, 150, 0),

	BabyBlue: Color3.fromRGB(100, 140, 200),
	InfoBlue: Color3.fromRGB(50, 150, 220),
	Mint: Color3.fromRGB(100, 210, 160),

	LightRed: Color3.fromRGB(255, 63, 63),
	LightGreen: Color3.fromRGB(82, 255, 107),
	LightPurple: Color3.fromRGB(128, 101, 201),

	Black: new Color3(0, 0, 0),
	White: Color3.fromRGB(255, 255, 255),
	Grey: Color3.fromRGB(176, 176, 176),
	GreyGrey: Color3.fromRGB(105, 105, 105),
};

export const Text = {
	color: (text: string, color: Color3): Token => ({ text, color }),
	white: (text: string): Token => ({ text, color: Colors.White }),
};

export const Fonts = {
	Regular: DrawFont.RegisterDefault("SometypeMono_Regular", {}),
	Italic: DrawFont.RegisterDefault("SometypeMono_Italic", {}),
};
