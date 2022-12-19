import { Colors, Fonts } from "synlog/helper";
import { Token } from "synlog/types";

// A block of drawn text
export class TextBlock {
	height = 0;
	width = 0;
	object?: TextDynamic;

	constructor(private readonly token: Token) {}

	private createObject() {
		let obj = this.object;
		if (!obj) {
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
		// text.OutlineOpacity = 3 / 4;
		text.Visible = true;

		this.update();
	}

	update() {
		const object = this.object;
		if (!object) return;

		const token = this.token;
		object.Font = token.font ?? Fonts.Regular;
		object.Color = token.color;
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
