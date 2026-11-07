local stock = { reconcile = function() error("stock reconcile must be disabled") end }
package.loaded["default.hypr.helpers"] = true
package.loaded["default.hypr.monitor-workspaces"] = stock
local bindings = {}
local function action(kind)
  return function(spec) return { kind = kind, spec = spec } end
end
hl = { dsp = { focus = action("focus"), window = { move = action("window") }, workspace = { move = action("workspace") } } }
o = { rebind = function(key, _, dispatcher) bindings[key] = dispatcher end }
local shared = dofile("workspaces.lua")
stock.reconcile()
assert(stock.focus(3, "HDMI-A-1").spec.workspace == "3")
assert(stock.move_window(4).spec.follow == true)
assert(stock.move_window(4, false).spec.follow == false)
assert(stock.move_window(4).spec.workspace == "4")
assert(stock.move_to_monitor("l").spec.monitor == "l")
assert(stock.move_window_to_monitor("r").spec.monitor == "r")
shared.bindings()
assert(bindings["SUPER + TAB"].spec.workspace == "e+1")
assert(bindings["SUPER + SHIFT + TAB"].spec.workspace == "e-1")
assert(bindings["SUPER + CTRL + TAB"].spec.workspace == "previous")
assert(bindings["SUPER + mouse_down"].spec.workspace == "e+1")
assert(bindings["SUPER + mouse_up"].spec.workspace == "e-1")
print("Global workspace actions and navigation bindings passed")
