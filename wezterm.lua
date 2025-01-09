-- Core Configuration
local wezterm = require("wezterm")
local act = wezterm.action
local keys = require("keys")
local fonts = require("fonts")
local decoration = require("decoration")
local haswork, work = pcall(require, "work")

local config = wezterm.config_builder()
local launch_menu = {}

-- Preferences
--- Setup PowerShell options based on OS
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	--- Grab the ver info for later use.
	local _, stdout, _ = wezterm.run_child_process({ "cmd.exe", "ver" })
	local _, _, build, _ = stdout:match("Version ([0-9]+)%.([0-9]+)%.([0-9]+)%.([0-9]+)")
	local is_windows_11 = tonumber(build) >= 1900

	--- Make it look cool.
	if is_windows_11 then
		wezterm.log_info("We're running Windows 11!")
	end

	--- Set Pwsh as the default on Windows
	config.default_prog = { "pwsh", "-NoLogo" }
	table.insert(launch_menu, {
		label = "Pwsh",
		args = { "pwsh", "-NoLogo" },
	})
	table.insert(launch_menu, {
		label = "Pwsh-Preview",
		args = { "pwsh-preview", "-NoLogo" },
	})
	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "powershell", "-NoLogo" },
	})
	table.insert(launch_menu, {
		label = "Pwsh No Profile",
		args = { "pwsh", "-NoLogo", "-NoProfile" },
	})
	table.insert(launch_menu, {
		label = "Pwsh Preview No Profile",
		args = { "pwsh-preview", "-NoLogo", "-NoProfile" },
	})
	table.insert(launch_menu, {
		label = "PowerShell No Profile",
		args = { "powershell", "-NoLogo", "-NoProfile" },
	})
else
	--- Non-Windows Machine
	table.insert(launch_menu, {
		label = "Pwsh",
		args = { "/usr/local/bin/pwsh", "-NoLogo" },
	})
	table.insert(launch_menu, {
		label = "Pwsh No Profile",
		args = { "/usr/local/bin/pwsh", "-NoLogo", "-NoProfile" },
	})
end

config.scrollback_lines = 7000
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.launch_menu = launch_menu
-- Allow overwriting for work stuff
if haswork then
	work.apply_to_config(config)
end

fonts.setup(config)
keys.setup(config)
decoration.setup(config, isWindows11)

-- Powershell things!
--- Set Pwsh as the default on Windows
config.default_prog = { "pwsh", "-NoLogo" }

table.insert(launch_menu, {
	label = "PowerShell",
	args = { "powershell", "-NoLogo" },
})
table.insert(launch_menu, {
	label = "Pwsh",
	args = { "pwsh", "-NoLogo" },
})
-- and finally, return the configuration to wezterm
return config
