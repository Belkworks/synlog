import type { Line } from "class/line";

export type Token = {
	text: string;
	color?: Color3 | undefined;
	font?: DrawFont | undefined;
	italics?: boolean | undefined;
	// TODO: size
	// TODO: bold?
	// TODO: underline?
};

export type LogDirection = "up" | "down";

export type MaxLogBehavior = "drop" | "wait";

export type LineEntry = {
	id: string;
	line: Line;
	visible: boolean;
	enteredAt: DateTime;
	shownAt?: DateTime;
};
