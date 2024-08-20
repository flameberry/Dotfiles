# This has been added for making sure that ssh-keys are loading into the env
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# CMake Path
set -x PATH "/Applications/CMake.app/Contents/bin" $PATH

# Flutter Path
set -x PATH /Users/flameberry/Installations/flutter/bin $PATH
set -x PATH $PATH "$HOME/.pub-cache/bin"

# Zig Path
set -x PATH "/Users/flameberry/Installations/zig-macos-aarch64-0.12.0" $PATH
set -x PATH "/Users/flameberry/Library/Application Support/Code/User/globalStorage/ziglang.vscode-zig/zls_install" $PATH

# Rust
set -x PATH "$HOME/.cargo/bin" $PATH

# Source Vulkan SDK setup
bass source /Users/flameberry/VulkanSDK/1.3.283.0/setup-env.sh

# Eval Homebrew shell environment
eval ( /opt/homebrew/bin/brew shellenv )

# Initialize starship prompt
starship init fish | source

# global variables
set -x LS_COLORS (vivid generate catppuccin-mocha)
set -gx TERM xterm-256color
set -x COLORTERM truecolor
set -Ux EDITOR nvim
set -gx VISUAL nvim
set -gx BAT_THEME "Catppuccin Mocha"
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml

# FZF Config
set -g FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -g FZF_PREVIEW_FILE_CMD 'Bat --style=numbers --color=always --line-rage :500'
set -g FZF_LEGACY_KEYBINDINGS 0

# theme
set -g theme_color_scheme "Catppuccin Mocha"

# fish options
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# |====== Aliases  ======|
alias vi nvim
alias vim nvim
alias c clear

# |======  LS  ======|
alias l "eza --icons=always --git"
alias ls "eza --icons=always --git --git-ignore --ignore-glob='node_modules'"
alias lla "ls -la"
alias ll "ls -l"
alias lt "eza -lAh --icons=always --git --tree --level=4 --long --ignore-glob='node_modules|.git' "

# |======  Config App  ======|
alias nrc "vim ~/.config/nvim/lua/"
alias frc "vim ~/.config/fish/config.fish" # fish shell rc
alias sfs "source ~/.config/fish/config.fish" # source fish shell
alias nrc "vim ~/.config/nvim/init.lua"
alias arc "vim ~/.config/alacritty/alacritty.toml"
alias wrc "vim ~/.config/wezterm/wezterm.lua"
alias trc "vim ~/.config/tmux/tmux.conf"
alias zelrc "vim ~/.config/zellij/config.kdl"
alias zshrc "vim ~/.config/.zshrc"

# |======  Applications  ======|
alias ff fastfetch
alias lg lazygit

if status is-interactive
    # Commands to run in interactive sessions can go here
end
