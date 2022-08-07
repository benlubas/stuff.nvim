local F = {}
local selected_win

local move_float = function(conf, dir)
	if dir == "down" then
		conf["row"][false] = conf["row"][false] + 1
	elseif dir == "up" then
		conf["row"][false] = conf["row"][false] - 1
	elseif dir == "left" then
		conf["col"][false] = conf["col"][false] - 1
	elseif dir == "right" then
		conf["col"][false] = conf["col"][false] + 1
	end

	return conf
end

local change_win_prop = function(direction)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local conf = vim.api.nvim_win_get_config(win)
		if conf.relative ~= "" then
			conf = move_float(conf, direction)
            selected_win = win
			vim.api.nvim_win_set_config(selected_win, conf)
		end
	end
end

local entered_already = {}
F.enter_float = function()
    if #entered_already == #vim.api.nvim_list_wins() then entered_already = {} end
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if not vim.tbl_contains(entered_already, win) then
            selected_win = win
            table.insert(entered_already, win)
            vim.api.nvim_set_current_win(selected_win)
            return
        end
    end
end

F.setup = function()
	vim.keymap.set('n', '<C-down>', function() change_win_prop("down") end)
	vim.keymap.set('n', '<C-up>', function() change_win_prop("up") end)
	vim.keymap.set('n', '<C-left>', function() change_win_prop("left") end)
	vim.keymap.set('n', '<C-right>', function() change_win_prop("right") end)
	-- vim.keymap.set('n', 'U', enter_float)
end

return F
