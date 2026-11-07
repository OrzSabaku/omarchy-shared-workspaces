import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';
import vm from 'node:vm';
const qml = readFileSync('Workspaces.qml', 'utf8');
const functions = ['workspaceIds', 'focusWorkspace'].map(name => {
  const match = qml.match(new RegExp(`  function ${name}\\([^)]*\\) \\{[\\s\\S]*?\\n  \\}`));
  assert.ok(match, name);
  return match[0];
}).join('\n');
let dispatched;
const context = vm.createContext({
  Hyprland: { workspaces: { values: [{id: 12}, {id: -99}, {id: 3}, {id: 11}, {id: 12}] } },
  root: { dispatch: value => { dispatched = value; } },
});
vm.runInContext(functions, context);
assert.deepEqual(Array.from(vm.runInContext('workspaceIds()', context)), [1,2,3,4,5,11,12]);
vm.runInContext('focusWorkspace(12)', context);
assert.equal(dispatched, 'hl.dsp.focus({ workspace = "12" })');
assert.ok(qml.includes('readonly property var monitor: Hyprland.focusedMonitor'));
assert.ok(!qml.includes('slotOf('));
console.log('Global list, distinct workspace IDs, and click dispatch passed');
