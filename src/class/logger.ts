import { Dictionary } from "@rbxts/llama";
import { LogLevel } from "@rbxts/log";
import { LogEvent } from "@rbxts/log/out/Core";
import { MessageTemplateParser, TemplateTokenKind } from "@rbxts/message-templates";
import Object from "@rbxts/object-utils";
import { HttpService, Workspace } from "@rbxts/services";
import { Colors, Fonts, Text } from "../helper";
import { Token } from "../types";
import { Line } from "./line";

export const logHeaders = {
	[LogLevel.Debugging]: "DEBUG",
	[LogLevel.Information]: "INFO",
	[LogLevel.Warning]: "WARN",
	[LogLevel.Error]: "ERROR",
	[LogLevel.Fatal]: "FATAL",
	[LogLevel.Verbose]: "LOG",
};

const padStart = (str: string, len: number, pad = " "): string => pad.rep(len - str.size()) + str;

export const logHeaderWidth = Object.values(logHeaders).reduce((acc, cur) => math.max(acc, cur.size()), 0);
export const logHeadersPadStart = Dictionary.map(logHeaders, (value) => padStart(value, logHeaderWidth));

const Camera = Workspace.CurrentCamera as Camera;

const DEFAULT_LOG_TIME = 7;

const logColors = {
	[LogLevel.Debugging]: Colors.GreyGrey,
	[LogLevel.Information]: Colors.InfoBlue,
	[LogLevel.Warning]: Colors.Orange,
	[LogLevel.Error]: Colors.LightRed,
	[LogLevel.Fatal]: Colors.LightPurple,
	[LogLevel.Verbose]: Colors.White,
};

type LineEntry = {
	id: string;
	line: Line;
	visible: boolean;
	entered?: number;
};

interface SinkOptions {
	label?: {
		italic?: boolean;
		font?: Font;
		color?: boolean;
	};
}

type Direction = "up" | "down";
type MaxBehavior = "drop" | "wait";

export class DrawingLogger {
	private lines: LineEntry[] = [];
	private queue: LineEntry[] = [];
	private behavior: MaxBehavior = "wait";
	private offset = new Vector2(8, 8);

	direction: Direction = "up";
	maxLines = 10;

	setMaxBehavior(behavior: MaxBehavior) {
		this.behavior = behavior;
		this.update();
		return this;
	}

	setOffset(x: number, y = x) {
		this.offset = new Vector2(x, y);
		return this;
	}

	addLine(line: Line) {
		const id = HttpService.GenerateGUID(false);

		this.queue.push({
			id,
			line,
			entered: tick(),
			visible: false,
		});

		this.update();
		return id;
	}

	sink(opts?: SinkOptions) {
		const labelOpts = opts?.label;
		const labelItalic = labelOpts?.italic ?? true;
		const labelFont = labelOpts?.font ?? (labelItalic ? Fonts.Italic : Fonts.Regular);
		const labelColor = labelOpts?.color ?? true;
		const white = Colors.White;

		return (log: LogEvent) => {
			const tokens = MessageTemplateParser.GetTokens(log.Template).map((token): Token => {
				if (token.kind === TemplateTokenKind.Text) return Text.white(token.text);

				const prop = log[token.propertyName];
				const str = tostring(prop);
				switch (typeOf(prop)) {
					case "number":
						return Text.color(str, Colors.Mint);
					case "string":
						return Text.white(str);
					default:
						return Text.color(str, Colors.Grey);
				}
			});

			const prefix = log.SourceContext;
			if (prefix !== undefined) tokens.unshift(Text.color(`[${prefix}] `, Colors.Grey));

			tokens.unshift({
				text: logHeadersPadStart[log.Level] + " ",
				color: labelColor ? logColors[log.Level] : white,
				font: labelFont,
			});

			this.addLine(Line.fromTokens(tokens));
		};
	}

	private destroyEntry(entry: LineEntry) {
		if (!entry.visible) return;
		entry.visible = false;
		entry.line.destroy();
	}

	private enter(entry: LineEntry) {
		entry.visible = true;
		entry.entered = tick();
		entry.line.create();
		task.delay(DEFAULT_LOG_TIME, () => this.dismiss(entry.id));
	}

	private removeById(id: string) {
		const i = this.lines.findIndex((entry) => entry.id === id);
		if (i >= 0) {
			this.destroyEntry(this.lines[i]);
			this.lines.remove(i);
			return true;
		}
		return false;
	}

	dismiss(id: string) {
		const i = this.queue.findIndex((entry) => entry.id === id);
		if (i >= 0) {
			this.queue.remove(i);
			return true;
		}

		if (this.removeById(id)) {
			this.update();
			return true;
		}

		return false;
	}

	clear() {
		this.lines.forEach((entry) => this.destroyEntry(entry));
		this.lines.clear();
		this.queue.clear();
		this.update();
	}

	private update() {
		if (this.lines.size() > 0) {
			let pos = this.offset;
			if (this.direction === "up") {
				pos = new Vector2(pos.X, Camera.ViewportSize.Y - pos.Y);
				for (let i = this.lines.size(); i > 0; i--) {
					const entry = this.lines[i - 1];
					const height = entry.line.height;
					entry.line.move(pos.sub(new Vector2(0, height)));
					pos = pos.sub(new Vector2(0, height));
				}
			} else
				for (const entry of this.lines) {
					entry.line.move(pos);
					pos = pos.add(new Vector2(0, entry.line.height));
				}
		}

		if (this.behavior === "wait") {
			if (this.lines.size() >= this.maxLines) return;

			const entry = this.queue.shift();
			if (!entry) return;

			this.lines.push(entry);
			this.enter(entry);
		} else {
			if (this.queue.isEmpty()) return;

			while (this.queue.size() > 0) {
				const entry = this.queue.shift();
				if (entry) this.lines.push(entry);
			}

			while (this.lines.size() > this.maxLines) {
				const entry = this.lines.shift();
				if (entry) this.destroyEntry(entry);
			}

			for (const entry of this.lines) {
				if (entry.visible) continue;
				this.enter(entry);
			}
		}

		this.update();
	}

	Destroy() {
		this.addLine = () => "";
		this.lines.forEach((entry) => entry.line.destroy());
		this.lines.clear();
		this.queue.clear();
	}
}
