# ---------------------------------------------
# ~/.zshrc
# ---------------------------------------------

# Use powerlevel10k if already installed
# Load Powerlevel10k theme (Example)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable command completions
autoload -Uz compinit
compinit

# Enable history-based autosuggestions
# zsh-autosuggestions & zsh-syntax-highlighting assumed installed
# via a plugin manager or manually
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# History Settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Default editor
export EDITOR=vim

# Automatically start tmux if not already inside tmux
# (Avoid nesting if already in a tmux session)
if [ -z "$TMUX" ]; then
  tmux
fi

eval "$(jump shell)"


### 🟢 LS 명령어 개선 (lsd 사용) ###
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -la'
alias lt='lsd --tree'   # 트리 형태로 출력

### 🟣 Git 단축 명령어 ###
alias g='git'
alias ga='git add .'
alias gs='git status'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gm='git merge'
alias gl='git log --oneline --graph --decorate --all'
alias gr='git reset --hard HEAD'
alias grm='git rm'

### 🔵 Tmux 관련 ###
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias trc='nvim ~/.tmux.conf'

### 🟡 편리한 시스템 명령어 ###
alias df='df -h'             # 디스크 공간 확인 (사람이 읽기 쉬운 형식)
alias du='du -h --max-depth=1' # 폴더별 용량 확인
alias free='free -h'         # 메모리 사용량 확인
alias grep='grep --color=auto'
alias ip='ip -c'             # IP 주소 보기 (색상 추가)
alias cls='clear'            # 터미널 클리어

### 🟠 Vim 관련 ###
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vrc='nvim ~/.config/nvim/init.vim'

### 🟢 Docker 관련 ###
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'

### 🟣 Python 관련 ###
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv venv'
alias act='source venv/bin/activate'
alias deact='deactivate'

### 🟢 Zsh 설정 ###
alias zrc="nvim ~/.zshrc"
alias reload="source ~/.zshrc"
source ~/.p10k/powerlevel10k.zsh-theme
