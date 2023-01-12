import { Colors, Fonts } from "../helper";
import { Token } from "../types";

export interface IBlock {
	create(): void;
	update(): void;
	move(to: Vector2 | Point2D): void;
	destroy(): void;
	getBounds(): Vector2;
}

function toPoint(point: Vector2 | Point2D) {
	return typeIs(point, "Vector2") ? new Point2D(point) : point;
}

/**
 * A block of drawn text.
 */
export class TextBlock implements IBlock {
	private bounds = new Vector2();
	private object?: TextDynamic;

	constructor(private readonly token: Token) {}

	private getObject() {
		const obj = this.object;
		return obj ? obj : (this.object = new TextDynamic());
	}

	create() {
		const text = this.getObject();
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

		this.bounds = object.TextBounds;
	}

	move(to: Vector2 | Point2D) {
		if (!this.object) return;
		this.object.Position = toPoint(to);
	}

	destroy() {
		if (this.object) this.object.Visible = false;
		this.object = undefined;
	}

	getBounds() {
		return this.bounds;
	}
}
