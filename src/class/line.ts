import { Token } from "../types";
import { TextBlock } from "./block";

// A horizontal list of TextBlocks
export class Line {
	height = 0;

	constructor(readonly blocks: TextBlock[]) {}

	static fromBlock(block: TextBlock) {
		return new Line([block]);
	}

	static fromTokens(tokens: Token[]) {
		return new Line(tokens.map((token) => new TextBlock(token)));
	}

	static fromToken(token: Token) {
		return new Line([new TextBlock(token)]);
	}

	create() {
		this.blocks.forEach((block) => block.create());
		this.height = this.blocks.reduce((acc, block) => math.max(acc, block.height), 0);
	}

	move(position: Vector2) {
		if (!this.blocks) return;
		this.blocks.forEach((block) => {
			block.move(position);
			position = position.add(new Vector2(block.width, 0));
		});
	}

	destroy() {
		this.blocks.forEach((block) => block.destroy());
		this.blocks.clear();
		this.height = 0;
	}
}
