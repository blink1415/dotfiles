# Prompt
def prompt_func_git [] {
    # Check if the git_branch executable exists
    let git_branch_path = which git_branch

    if ($git_branch_path | length) > 0 {
        let git_branch = (git_branch)
        if $git_branch == "" {
            return ""
        }

        return $"(ansi blue_bold)\(($git_branch)\)"
    }

    # Return an empty string if git_branch doesn't exist
    return ""
}

def create_left_prompt [] {
    let home =  $nu.home-path
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    let path_segment = $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"

	$"($path_segment) (prompt_func_git)"
}

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]


$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "\n>" }
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "\n|" }
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "\n" }

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| "" }
$env.PROMPT_INDICATOR = {|| "\n> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "\n: " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "\n> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "\n::: " }

$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.BAT_THEME = "Solarized (light)"
$env.TOPIARY_CONFIG_FILE = ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
$env.TOPIARY_LANGUAGE_DIR = ($env.XDG_CONFIG_HOME | path join topiary languages)

$env.config.show_banner = false
$env.config.edit_mode = 'vi'
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

alias gti = git
alias gb = git checkout -b
alias gs = git status
alias gd = git diff
alias fzf = sk
alias z = cd (gitlist | fzf)

alias gt = gotestsum
alias nt = npm run test
alias gg = go generate ./...
alias glt = gleam test
alias glr = gleam run --

alias s = is-fast --cache-mode read-write

def --env v [...args] {
  # Fallback if any args are provided, just use editor as normal
  if ($args | length) != 0 { hx ...$args; return}

  # Otherwise use gitlist to fuzzy find project
  let selection = gitlist | fzf --delimiter ':' --reverse
  let dir = $selection | split column ':' | get column2.0 | str trim
  cd $dir

  if ZELLIJ in $env { zellij action rename-tab ( pwd | split row "/" | last ) }

  hx .
}

def switch [...args] {
  # Fallback if any args are provided, just use editor as normal
  if ($args | length) != 0 { git switch ...$args; return}
  git branch | fzf --reverse | str trim | git switch $in
}

def mr_url [] {
  let remote = (git remote get-url origin)
  let branch = (git rev-parse --abbrev-ref HEAD)
  if ($remote | str contains "gitlab") {
    let base = ($remote | str replace --all '.git$' '' | str replace 'git@gitlab.com:' 'https://gitlab.com/' | str replace 'git@gitlab.' 'https://gitlab.') | str replace '.git' ''
    $"($base)/-/merge_requests/new?merge_request[source_branch]=($branch)"
  } else if ($remote | str contains "github") {
    let base = ($remote | str replace --all '.git$' '' | str replace 'git@github.com:' 'https://github.com/' | str replace 'git@' 'https://')
    $"($base)/compare/($branch)?expand=1"
  } else {
    "Unsupported remote host"
  }
}


def repo [
  path?: string  # Optional path to a git repository
] {
  let repo_path = if ($path == null) { "." } else { $path }
  
  let remote = (git -C $repo_path remote get-url origin | str trim | str replace ".git" "")
  let cleaned = ($remote | str replace "git@" "")
  let parts = ($cleaned | split row ":")
  
  let url = if ($remote | str starts-with "git@") {
    $"https://($parts.0)/($parts.1)"
  } else if ($remote | str starts-with "https://") {
    $remote
  } else {
    $remote
  }

  ^open $url
}

def repos [] {
  let selection = gitlist | sk --delimiter ':'
  let dir = $selection | split column ':' | get column2.0 | str trim
  cd $dir
	repo
}

def oil [] {
    nvim +Oil
}

def gogetu [] {
    # Check if go.mod exists
    if not ('go.mod' | path exists) {
        print "Error: go.mod not found in current directory"
        return
    }

    # Read go.mod and extract direct dependencies
    let deps = (
        open go.mod
        | lines
        | where ($it | str starts-with "\t") # Lines in require block start with tab
        | where ($it !~ '// indirect')       # Exclude indirect dependencies
        | str trim                            # Remove leading tabs
        | parse "{module} {version}"         # Parse module and version
        | get module                          # Get just the module name
    )

    if ($deps | is-empty) {
        print "No direct dependencies found in go.mod"
        return
    }

    # Use fzf to select a dependency
    let selected = ($deps | str join "\n" | sk --height=40% --reverse)

    # Run go get -u on selected dependency
    if ($selected | is-not-empty) {
        print $"Updating ($selected)..."
        go get -u $selected
    }
}
