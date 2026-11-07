-- Load before default.hypr.omarchy; call bindings() after personal bindings.
-- Omarchy's bootstrap clears this configuration's modules on every reload.
require("default.hypr.helpers")
local workspaces = require("default.hypr.monitor-workspaces")

-- The stock event callbacks resolve this method when they run. Disabling it
-- prevents hotplug/reload from renumbering or moving existing workspaces.
workspaces.reconcile = function() end
workspaces.focus = function(id)
  return hl.dsp.focus({ workspace = tostring(id) })
end
workspaces.move_window = function(id, follow)
  return hl.dsp.window.move({ workspace = tostring(id), follow = follow ~= false })
end
workspaces.move_to_monitor = function(direction)
  return hl.dsp.workspace.move({ monitor = direction })
end

-- Restore the pre-4.5 move-to-monitor action without block reconciliation.
workspaces.move_window_to_monitor = function(direction)
  return hl.dsp.window.move({ monitor = direction })
end

local M = {}
function M.bindings()
  local navigation = {
    { "SUPER + TAB", "Next workspace", "e+1" },
    { "SUPER + SHIFT + TAB", "Previous workspace", "e-1" },
    { "SUPER + CTRL + TAB", "Former workspace", "previous" },
    { "SUPER + mouse_down", "Scroll workspace forward", "e+1" },
    { "SUPER + mouse_up", "Scroll workspace backward", "e-1" },
  }
  for _, binding in ipairs(navigation) do
    o.rebind(binding[1], binding[2], hl.dsp.focus({ workspace = binding[3] }))
  end
end
return M
