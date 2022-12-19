-- Compiled with roblox-ts v2.0.4
local TS = _G[script]
local exports = {}
local DrawingLogger = TS.import(script, script, "class", "logger").DrawingLogger
exports.Line = TS.import(script, script, "class", "line").Line
exports.TextBlock = TS.import(script, script, "class", "block").TextBlock
local _helper = TS.import(script, script, "helper")
exports.Colors = _helper.Colors
exports.Text = _helper.Text
local Synlog = DrawingLogger.new()
exports.Synlog = Synlog
return exports
