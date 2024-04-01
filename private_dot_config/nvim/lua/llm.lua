local M = {}

local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

local function write_text(text)
    vim.cmd('vnew')
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, '\n'))
    vim.api.nvim_win_set_cursor(0, {1, 0})
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
end

local function get_templates()
    result = {}
    local output = vim.fn.system("llm templates list | awk '{print $1}'")
    if not output then
        return result
    end

    for k, v in pairs(vim.split(output, '\n')) do
        table.insert(result, v)
    end

    return result
end

function M:new()
    instance = {
        templates = get_templates()
    }
    setmetatable(instance, { __index = M })
    return instance
end

function M:debug()
    print(vim.inspect(self.templates))
end

function M:call_function()
    local result = get_visual_selection()
    local current_buffer = vim.api.nvim_get_current_buf()
    local lang = vim.api.nvim_buf_get_option(current_buffer, "filetype")
    local choice = vim.fn.inputlist(self.templates)
    template = self.templates[choice + 1]
    command = "echo '" .. result .. "' |  llm -t " .. template .. " -p language " .. lang
    local output = vim.fn.system(command)
    write_text(output)
end

return M
