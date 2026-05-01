return {
    MAIN_BUF_NAME = "dap-view://main",
    HOVER_BUF_NAME = "dap-view://hover",
    NAMESPACE = vim.api.nvim_create_namespace("dap-view"),
    NAMESPACE_VT = vim.api.nvim_create_namespace("dap-view-vt"),
    HL_PREFIX = "NvimDapView",
    HAS_0_12 = vim.fn.has("nvim-0.12") == 1,
}
