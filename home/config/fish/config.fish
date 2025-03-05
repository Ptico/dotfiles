# Homebrew setup, credits to @tmwatchanan https://github.com/orgs/Homebrew/discussions/4412
if test -d /home/linuxbrew/.linuxbrew # Linux
	set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
	set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
	set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
else if test -d /opt/homebrew # MacOS
	set -gx HOMEBREW_PREFIX "/opt/homebrew"
	set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
	set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
end
fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin";
! set -q MANPATH; and set MANPATH ''; set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH;
! set -q INFOPATH; and set INFOPATH ''; set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH;

# Aliases
alias la="eza -la"

if status is-interactive
  # FNM setup
  if type -q fnm
    fnm env --use-on-cd --shell fish | source
  end

  # Output of `thefuck --alias` for faster load
  if type -q thefuck
    function fuck -d "Correct your previous console command"
      set -l fucked_up_command $history[1]
      env TF_SHELL=fish TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command THEFUCK_ARGUMENT_PLACEHOLDER $argv | read -l unfucked_command
      if [ "$unfucked_command" != "" ]
        eval $unfucked_command
        builtin history delete --exact --case-sensitive -- $fucked_up_command
        builtin history merge
      end
    end
  end

  # Hydro prompt settings
  set hydro_color_pwd $fish_color_cwd
  set hydro_color_prompt $fish_color_operator
  set hydro_color_git $fish_color_autosuggestion

  # FZF settings
  set fzf_diff_highlighter delta --paging=never --width=20 # Use delta for diffs
  set fzf_preview_dir_cmd eza --all --color=always         # Use eza for dir listing
  set fzf_preview_file_cmd bat                             # Use bat for file preview
end

# Functions

function mkcd -d "Create directory and change to it"
  mkdir -pv $argv;
  cd $argv;
end

# Add relative bin folder to the path
set PATH bin $PATH
