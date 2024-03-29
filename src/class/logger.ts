import { tokenize } from "../helper";
import { LineEntry, LogDirection, MaxLogBehavior, Token } from "../types";
import { Line } from "./line";

const Workspace = game.GetService("Workspace");
const Camera = Workspace.CurrentCamera as Camera;

/**
 * A vertical list of {@link Line}s.
 */
export class DrawingLogger {
	private lines: LineEntry[] = [];
	private queue: LineEntry[] = [];
	private behavior: MaxLogBehavior = "wait";
	private offset = new Vector2(8, 8);

	/**
	 * The direction to render logs in.
	 */
	direction: LogDirection = "up";

	/**
	 * The maximum number of lines to display at once.
	 */
	maxLines = 10;

	/**
	 * The amount of time that logs are displayed for (in seconds).
	 */
	logTime = 10;

	/**
	 * Set the behavior for when {@link maxLines} is reached.
	 *
	 * `"drop"` will push the oldest line out, while
	 * `"wait"` will wait for space.
	 */
	setMaxBehavior(behavior: MaxLogBehavior) {
		this.behavior = behavior;
		this.update();
		return this;
	}

	/**
	 * Set the offset in pixels from the corner to display logs.
	 */
	setOffset(x: number, y = x) {
		this.offset = new Vector2(x, y);
		return this;
	}

	private counter = 0;

	private getId() {
		return `line_${this.counter++}`;
	}

	private getEntry(line: Line) {
		return {
			id: this.getId(),
			enteredAt: DateTime.now(),
			visible: false,
			line,
		};
	}

	/**
	 * Add a {@link Line} to the queue.
	 * @returns Displayed line id.
	 */
	addLine(line: Line) {
		const entry = this.getEntry(line);
		this.queue.push(entry);

		this.update();
		return entry.id;
	}

	printTokens(tokens: Token[]) {
		return this.addLine(Line.fromTokens(tokens));
	}

	/**
	 * Show arbitrary data as a colorized line.
	 */
	print(...args: unknown[]) {
		return this.printTokens(tokenize(args));
	}

	private destroyEntry(entry: LineEntry) {
		if (!entry.visible) return;
		entry.visible = false;
		entry.line.destroy();
	}

	private enter(entry: LineEntry) {
		entry.visible = true;
		entry.shownAt = DateTime.now();
		entry.line.create();
		task.delay(this.logTime, () => this.dismiss(entry.id));
	}

	private removeById(id: string) {
		const i = this.lines.findIndex((entry) => entry.id === id);
		if (i < 0) return false;
		this.destroyEntry(this.lines.remove(i) as LineEntry);
		return true;
	}

	/**
	 * Dismiss a line by its id.
	 * @returns `true` if found, `false` otherwise.
	 */
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

	/**
	 * Remove all lines, including those in the queue.
	 */
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

	/**
	 * Stops the logger and removes all lines.
	 *
	 * Once called, {@link addLine} will do nothing.
	 */
	Destroy() {
		this.addLine = () => "";
		this.clear();
	}
}
