import { Colors, Fonts } from "../helper";
import { Token } from "../types";

export interface IBlock {
	create(): void;
	update(): void;
	move(vec: Vector2): void;
	destroy(): void;
}

// A block of drawn text
export class TextBlock implements IBlock {
	height = 0;
	width = 0;
	private object?: TextDynamic;

	constructor(private readonly token: Token) {}

	private createObject() {
		let obj = this.object;
		if (obj === undefined) {
			obj = new TextDynamic();
			this.object = obj;
		}
		return obj;
	}

	create() {
		const text = this.createObject();
		text.XAlignment = XAlignment.Right;
		text.YAlignment = YAlignment.Bottom;
		text.Size = 21;
		text.Outlined = true;
		text.OutlineColor = Colors.Black;
		text.Visible = true;

		this.update();
	}

	update() {
		const object = this.object;
		if (!object) return;

		const token = this.token;
		object.Font = token.font ?? (token.italics ? Fonts.Italic : Fonts.Regular);
		object.Color = token.color ?? Colors.White;
		object.Text = token.text;

		this.height = object.TextBounds.Y;
		this.width = object.TextBounds.X;
	}

	move(vec: Vector2) {
		if (!this.object) return;
		this.object.Position = new Point2D(vec);
	}

	destroy() {
		if (this.object) this.object.Visible = false;
		this.object = undefined;
	}
}
