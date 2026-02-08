return {
    cmd = {
        "pyright-langserver",
        "--stdio",
    },
    filetypes = {
        "python",
    },
    root_markers = {
        "Pipfile",
        "pyproject.toml",
        "pyrightconfig.json",
        "requirements.txt",
        "setup.cfg",
        "setup.py",
    },
    settings = {
        python = {
            pythonPath = vim.fn.expand(".venv/bin/python"),
            venvPath = vim.fn.expand("."),
            venv = ".venv",
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
    single_file_support = true,
}
