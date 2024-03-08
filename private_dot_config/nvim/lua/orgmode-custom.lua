local M = {}

function unfold_node(node)
    local start_row, _, end_row, _ = node:range()
    vim.api.nvim_win_set_cursor(0, {start_row + 1, end_row})
    vim.cmd('foldopen')
end

local function get_value_for_directive(node)
    result = ""
    local child = node:child(0)
    if child == nil then
        return result
    end

    local value = vim.treesitter.get_node_text(child,0)
    if value then
        return value
    end
    return result
end

local function get_parent_subsection(node)
    if node == nil then
        return nil
    end

    local n = node:parent()
    if n == nil then
        return nil
    end

    if n:type() == "section" then
        return n
    end
    return get_parent_subsection(n)
end

function M:VISIBILITY()
    local query_string = [[
        (
         (directive name: (expr) @name value: (value) @value)
         ((#match? @name "VISIBILITY"))
        )
    ]]

    local parser = require('nvim-treesitter.parsers').get_parser()
    local query = vim.treesitter.query.parse(parser:lang(), query_string)
    local tree = parser:parse()[1]
    local result = query:iter_captures(tree:root(), 0)
    for _, n in result do
        if n:type() == "value" then
            local value = get_value_for_directive(n)
            if value == "children" then
                -- Get the parent section, and unfold all the children
                parent = get_parent_subsection(n)
                for child in parent:iter_children() do
                    pcall(unfold_node, child);
                end
            elseif value == "all" then
                unfold_node(n)
            elseif value == "folded" then
                -- Do nothing for now
                -- unfold_node(n)
            end
        end
    end
    vim.api.nvim_win_set_cursor(0, {1, 0})
end

return M
