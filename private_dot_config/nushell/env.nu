# Nushell Environment Config File

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { "〉" }
let-env PROMPT_INDICATOR_VI_INSERT = { ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = { "〉" }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# Zoxide

mkdir $env.NU_LIB_DIRS.0
zoxide init nushell --hook prompt | save ($env.NU_LIB_DIRS.0 | path join 'zoxide.nu')

# Starship

starship init nu | save ($env.NU_LIB_DIRS.0 | path join 'starship-init.nu')

# Personal environment settings

let home_path_additions = [ /.config/yarn/global/node_modules/.bin/ 
    /.emacs.d/bin 
    /.cargo/bin 
    /.local/bin 
]
let full_home_path_additions = ($home_path_additions | each { |it| $"($env.HOME)($it)"})
let-env PATH = ($env.PATH | append $full_home_path_additions )
let-env PATH = ($env.PATH | append '/usr/lib/llvm-14/bin')
let-env PATH = ($env.PATH | uniq)

