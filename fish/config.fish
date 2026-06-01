# This has been added for making sure that ssh-keys are loading into the env
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

set -x PATH "/Applications/CMake.app/Contents/bin" $PATH # CMake Path
set -x PATH /Users/flameberry/Installations/flutter/bin $PATH
set -x PATH $PATH "$HOME/.pub-cache/bin"
set -x PATH "/Users/flameberry/Library/Application Support/Code/User/globalStorage/ziglang.vscode-zig/zls_install" $PATH
set -x PATH "$HOME/.cargo/bin" $PATH
set -x PATH "/opt/homebrew/opt/postgresql@17/bin" $PATH
set -x PATH "$HOME/.local/share/bob/nvim-bin" $PATH

# Source Vulkan SDK setup
bass source /Users/flameberry/Installations/VulkanSDK/1.4.328.1/setup-env.sh

# Eval Homebrew shell environment
eval ( /opt/homebrew/bin/brew shellenv )

# Starship prompt
starship init fish | source

# ${UserConfigDir}/fish/config.fish
set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
carapace _carapace | source

# global variables
set -x LS_COLORS (vivid generate catppuccin-mocha)
set -gx TERM xterm-256color
set -x COLORTERM truecolor
set -Ux EDITOR nvim
set -gx VISUAL nvim
set -gx BAT_THEME "Catppuccin Mocha"

# FZF Config
set -g FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -g FZF_PREVIEW_FILE_CMD 'Bat --style=numbers --color=always --line-rage :500'
set -g FZF_LEGACY_KEYBINDINGS 0

# fish options
set -U fish_cursor_external block
set -U fish_cursor_insert block
set -U fish_cursor_default block
set -U fish_cursor_visual block
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always
set -g fish_greeting

# |====== Aliases  ======|
alias vi nvim
alias c clear

# |======  LS  ======|
alias l "eza --icons=always --git"
alias ls "eza --icons=always --git --git-ignore --ignore-glob='node_modules'"
alias lla "ls -la"
alias ll "ls -l"
alias lt "eza -lAh --icons=always --git --tree --level=4 --long --ignore-glob='node_modules|.git' "

# |======  Config App  ======|
alias frc "vi ~/.config/fish/config.fish" # fish shell rc
alias sfs "source ~/.config/fish/config.fish" # source fish shell

# |======  Applications  ======|
alias ff fastfetch
alias lg lazygit

# |====== Tmux ======]
abbr tn "tmux new -As (pwd | sed 's/.*\///g')"
abbr tc "sesh connect \$(sesh list | fzf)"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# pnpm
set -gx PNPM_HOME /Users/flameberry/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Postgresql headers and libraries to be found by compiler
set -gx LDFLAGS "-L/opt/homebrew/opt/postgresql@18/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/postgresql@18/include"

# OpenJDK
fish_add_path /opt/homebrew/opt/openjdk/bin

zoxide init fish | source
fzf --fish | source

# Added by Antigravity
fish_add_path /Users/flameberry/.antigravity/antigravity/bin

# Added by Antigravity IDE
fish_add_path /Users/flameberry/.antigravity-ide/antigravity-ide/bin


# Added by Antigravity CLI installer
set -gx PATH "/Users/flameberry/.local/bin" $PATH
