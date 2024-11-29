local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	{ family = "Iosevka" },
})
config.font_size = 18

-- Text rendering settings
config.front_end = "WebGpu" -- Use modern rendering engine
config.webgpu_power_preference = "HighPerformance"

-- Cool window with no borders
config.window_decorations = "RESIZE"

-- Dont lag
config.max_fps = 120

-- Fine tune text rendering
config.freetype_load_flags = "NO_HINTING" -- works more predictably and with fewer surprising artifacts
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.cell_width = 1.0

config.color_scheme = "Apple System Colors"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
	config.font_size = 15
	config.freetype_load_target = "Normal"
	config.freetype_render_target = "Normal"
	config.window_decorations = "BORDER | RESIZE"
end

return config
