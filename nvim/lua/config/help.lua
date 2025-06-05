local wk = require("which-key")
wk.add({
    {
        mode = { "n", "v" },
        { "gD", desc = "Go to definition in a new TAB" },
        { "<leader>t", desc = "Open terminal on the bottom" },
    },
})
