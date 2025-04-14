local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Main function
  s("main", fmt([[
    package main

    import "fmt"

    func main() {{
        {}
    }}
  ]], { i(0) })),

  -- Function definition
  s("func", fmt([[
    func {}({}) {} {{
        {}
    }}
  ]], {
    i(1, ""),
    i(2),
    i(3),
    i(0)
  })),

  -- If error check
  s("ife", fmt([[
    if err != nil {{
        return {}
    }}
  ]], {
    i(0)
  })),

  -- For loop
  s("for", fmt([[
    for {} := 0; {} < {}; {}++ {{
        {}
    }}
  ]], {
    i(1, "i"),
    rep(1),
    i(2, "n"),
    rep(1),
    i(0)
  })),

  -- Struct definition
  s("struct", fmt([[
    type {} struct {{
        {}
    }}
  ]], {
    i(1, ""),
    i(0)
  })),
}
