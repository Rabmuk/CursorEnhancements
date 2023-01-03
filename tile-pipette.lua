local bounding_box = require("__flib__/bounding-box")

local util = require("__CursorEnhancements__/util")

--- @param e EventData.CustomInputEvent
local function on_smart_pipette(e)
	local player = game.get_player(e.player_index)
	if
		not player
		or player.selected
		or player.cursor_ghost
		or not player.mod_settings["cen-enable-tile-pipette"].value
	then
		return
	end

	local cursor_stack = player.cursor_stack
	if not cursor_stack or cursor_stack.valid_for_read then
		return
	end

	local tile_area = bounding_box.from_position(e.cursor_position, true)
	local tile = player.surface.find_tiles_filtered({ area = tile_area })[1]
	if not tile or not tile.valid then
		return
	end

	local items_to_place_this = tile.prototype.items_to_place_this
	if not items_to_place_this then
		return
	end

	local item = items_to_place_this[1]
	if not item then
		return
	end

	if not util.set_cursor(player, item.name) then
		return
	end

	player.play_sound({
		path = "utility/smart_pipette",
	})
end

local tile_pipette = {}

tile_pipette.events = {
	["cen-linked-smart-pipette"] = on_smart_pipette,
}

return tile_pipette