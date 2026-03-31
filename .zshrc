# Coffee cup on terminal startup (must be before instant prompt)
printf "\n"
printf "  \033[36m) )\033[0m\n"
printf "  \033[36m( (\033[0m\n"
printf " \033[37m╭───╮\033[0m\n"
printf " \033[37m│ \033[30m▄\033[37m │─╮\033[0m\n"
printf " \033[37m╰───╯─╯\033[0m\n"
printf "\n"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# Disable zsh autocorrect prompt (e.g. "correct 'hello' to '_hello'")
unsetopt correct
unsetopt correct_all

# thefuck integration (works after installing `thefuck`)
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Tavily Search API Key
export TAVILY_API_KEY="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"
export GOOGLE_CLOUD_PROJECT_ID="gen-lang-client-0156443237"
export OPENROUTER_API_KEY="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"

# OpenClaw Completion
source "/home/ilya/.openclaw/completions/openclaw.zsh"

export GOOGLE_CLOUD_PROJECT="gen-lang-client-0156443237"
export GOOGLE_GENAI_USE_VERTEXAI=true
export GOOGLE_CLOUD_LOCATION="us-central1"

# Created by `pipx` on 2026-02-27 19:23:50

# pipx local bin
export PATH="$HOME/.local/bin:$PATH"

# runbg: detached launcher
runbg() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: runbg <command> [args...]"
    return 1
  fi

  nohup "$@" >/dev/null 2>&1 < /dev/null &
  disown
  echo "Started in background (detached, no log)."
}



export PATH=$PATH:/home/ilya/.spicetify

# Fastfetch alias
alias ff="fastfetch"
