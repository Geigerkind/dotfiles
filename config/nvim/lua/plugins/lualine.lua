require([[lualine]]).setup{
  options = {
    theme = [[zerodark]],
    section_separators = {[[]]},
    component_separators = {[[]]},
  },
  sections = {
    lualine_a = {[[mode]]},
    lualine_b = {[[branch]]},
    lualine_c = {[[filename]]},
    lualine_x = {[[filetype]]},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {[[mode]]},
    lualine_b = {[[branch]]},
    lualine_c = {[[filename]]},
    lualine_x = {[[filetype]]},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {[[fugitive]], [[chadtree]]},
}
