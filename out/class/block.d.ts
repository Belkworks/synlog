/// <reference types="synapse-types" />
/// <reference types="@rbxts/types" />
/// <reference types="@rbxts/types" />
import { Token } from "../types";
export declare class TextBlock {
    private readonly token;
    height: number;
    width: number;
    object?: TextDynamic;
    constructor(token: Token);
    private createObject;
    create(): void;
    update(): void;
    move(vec: Vector2): void;
    destroy(): void;
}
