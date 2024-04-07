context="$USER@$HOST"
START="%{$fg_bold[blue]%}["
END="%{$fg[blue]%}]%{$reset_color%}"
TIMESTAMP="$START%{$reset_color%}%*$END"

PROMPT='%{$TIMESTAMP%} %{$START%}%{$fg[cyan]%}$context:%~$END $(git_prompt_info)
  %{$fg_bold[blue] » %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="*%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

