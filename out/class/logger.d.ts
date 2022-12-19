/// <reference types="@rbxts/types" />
import { LogEvent } from "@rbxts/log/out/Core";
import { Line } from "./line";
export declare const logHeaders: {
    1: string;
    2: string;
    3: string;
    4: string;
    5: string;
    0: string;
};
export declare const logHeaderWidth: number;
interface SinkOptions {
    label?: {
        italic?: boolean;
        font?: Font;
        color?: boolean;
    };
}
declare type Direction = "up" | "down";
declare type MaxBehavior = "drop" | "wait";
export declare class DrawingLogger {
    private lines;
    private queue;
    private behavior;
    private offset;
    direction: Direction;
    maxLines: number;
    setMaxBehavior(behavior: MaxBehavior): this;
    setOffset(x: number, y?: number): this;
    addLine(line: Line): string;
    sink(opts?: SinkOptions): (log: LogEvent) => void;
    private destroyEntry;
    private enter;
    private removeById;
    dismiss(id: string): boolean;
    clear(): void;
    private update;
    Destroy(): void;
}
export {};
