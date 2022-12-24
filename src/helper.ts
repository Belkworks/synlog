import { Token } from "./types";

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

export const colorify = (val: unknown): Token => {
	const str = tostring(val);
	switch (typeOf(val)) {
		case "number":
			return Text.color(str, Colors.Mint);

		case "string":
			// TODO: check if string is wrapped in quotes
			return Text.white(str);

		case "boolean":
			return Text.color(str, (val as boolean) ? Colors.LightGreen : Colors.LightRed);

		case "vector":
			return Text.color(str, Colors.BabyBlue);

		case "nil":
			return Text.color(str, Colors.GreyGrey);

		// TODO: table
		// TODO: userdata
		// TODO: function
		// TODO: thread

		default:
			return Text.color(`[${str}]`, Colors.Grey);
	}
};

const compareProps = <T>(a: T, b: T, props: readonly (keyof T)[]) => props.some((prop) => a[prop] !== b[prop]);

const tokenProps = ["color", "font", "italics"] as const;

export const mergeTokens = (tokens: Token[]) =>
	tokens.reduce<Token[]>((acc, token) => {
		const last = acc[acc.size() - 1];
		if (!last || compareProps(last, token, tokenProps)) acc.push({ ...token });
		else last.text += token.text;
		return acc;
	}, []);
