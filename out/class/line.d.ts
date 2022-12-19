/// <reference types="@rbxts/types" />
/// <reference types="@rbxts/types" />
import { Token } from "../types";
import { TextBlock } from "./block";
export declare class Line {
    readonly blocks: TextBlock[];
    height: number;
    constructor(blocks: TextBlock[]);
    static fromBlock(block: TextBlock): Line;
    static fromTokens(tokens: Token[]): Line;
    static fromToken(token: Token): Line;
    create(): void;
    move(position: Vector2): void;
    destroy(): void;
}
