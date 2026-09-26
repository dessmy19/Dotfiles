PS1='\[\e[1;38;2;122;162;247m\]\W \[\e[1;38;2;224;175;104m\]\$\[\e[0m\] '

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export EDITOR="nvim"
export VISUAL="nvim"

export GPG_TTY=$(tty)

export PATH="$HOME/.local/bin:$HOME/.config/scripts:$PATH"

case $- in
*i*) ;;
*) return ;;
esac

if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec ~/.config/scripts/startdwl
fi

export HISTFILE="$XDG_STATE_HOME/bash/history"
mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND="history -a; ${PROMPT_COMMAND}"

shopt -s autocd 2>/dev/null
shopt -s checkwinsize
shopt -s globstar 2>/dev/null

if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
  source /usr/share/fzf/key-bindings.bash
  source /usr/share/fzf/completion.bash
fi

_fzf_preview() {
  local file="$1"
  local width="${2:-$FZF_PREVIEW_COLUMNS}"
  local height="${3:-$FZF_PREVIEW_LINES}"

  if [[ ! -f "$file" ]]; then
    ls -la --color=always "$file" 2>/dev/null
    return
  fi

  local mime=$(file --mime-type -b "$file" 2>/dev/null)

  case "$mime" in
    image/*)
      chafa -f sixel -s "${width}x${height}" "$file" 2>/dev/null || chafa -s "${width}x${height}" "$file" 2>/dev/null
      ;;
    video/*)
      local thumb="/tmp/fzf-thumb-$(basename "$file").jpg"
      ffmpegthumbnailer -i "$file" -o "$thumb" -s 0 -q 10 2>/dev/null && _fzf_preview "$thumb" "$width" "$height"
      ;;
    application/pdf)
      mutool draw -F txt -o - "$file" 1 2>/dev/null | head -n "$height"
      ;;
    application/*zip*|application/x-tar|application/gzip|application/x-bzip2|application/x-xz)
      tar -tvf "$file" 2>/dev/null | head -n "$height"
      ;;
    text/*|application/json|application/xml|application/javascript|application/x-shellscript)
      cat "$file" 2>/dev/null | head -n "$height"
      ;;
    *)
      file "$file"
      ;;
  esac
}

export -f _fzf_preview
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/.git/*' -printf '%P\n'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border=none
  --no-separator
  --no-scrollbar
  --prompt='  '
  --pointer='  '
  --marker='  '
  --preview='_fzf_preview {}'
  --preview-window=right,65%,wrap,border-none
  --color=bg+:#7aa2f7,spinner:#7aa2f7,hl:#7dcfff
  --color=fg:#c0caf5,header:#7aa2f7,info:#9ece6a,pointer:#bb9af7
  --color=marker:#bb9af7,fg+:#1a1b26,prompt:#7aa2f7,hl+:#e0af68,gutter:#1a1b26
"
export FZF_CTRL_T_OPTS="--preview '_fzf_preview {}'"
export FZF_CTRL_R_OPTS='--preview-window=hidden'

alias sdwl='~/.config/scripts/startdwl'
alias diff='diff --color=auto'
alias df='df -h'
alias vim='nvim'
alias glog='PAGER="less -F -X" git log'
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

set -o vi

bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

BLE_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/blesh"

_ble_fetch() {
  local src
  src="$(mktemp -d)"
  git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git "$src" &&
    make -C "$src" install PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/.."
  rm -rf "$src"
}

[[ -d "$BLE_HOME" ]] || _ble_fetch
[[ -f "$BLE_HOME/ble.sh" ]] && source "$BLE_HOME/ble.sh" --noattach

function blerc/vim-load-hook {
  ble-bind -m vi_imap -f 'C-m' accept-line
  ble-bind -m vi_imap -f 'RET' accept-line
  ble-bind -m vi_nmap -f 'C-m' accept-line
  ble-bind -m vi_nmap -f 'RET' accept-line

  bleopt keymap_vi_mode_name_insert=$'\e[38;2;26;27;38;48;2;158;206;106m INSERT \e[m'
  bleopt keymap_vi_mode_name_replace=$'\e[38;2;26;27;38;48;2;255;158;100m REPLACE \e[m'
  bleopt keymap_vi_mode_name_vreplace=$'\e[38;2;26;27;38;48;2;247;118;142m VREPLACE \e[m'
  bleopt keymap_vi_mode_name_visual=$'\e[38;2;26;27;38;48;2;187;154;247m VISUAL \e[m'
  bleopt keymap_vi_mode_name_select=$'\e[38;2;26;27;38;48;2;125;207;255m SELECT \e[m'
  bleopt keymap_vi_mode_name_linewise=$'\e[38;2;26;27;38;48;2;122;162;247m LINE \e[m'
  bleopt keymap_vi_mode_name_blockwise=$'\e[38;2;26;27;38;48;2;224;175;104m BLOCK \e[m'
  bleopt keymap_vi_mode_string_nmap=$'\e[38;2;122;162;247m~\e[m'

  function ble/prompt/backslash:keymap:vi/mode-indicator {
    [[ $bleopt_keymap_vi_mode_show ]] || return 0
    local keymap=${prompt_vi_keymap-}
    if [[ $keymap ]]; then
      ble/prompt/unit/add-hash '$_ble_decode_keymap,${_ble_decode_keymap_stack[*]}'
    else
      ble/keymap:vi/script/get-vi-keymap || return 0
    fi
    local name= show= overwrite=
    ble/prompt/unit/add-hash '$_ble_edit_overwrite_mode,$_ble_keymap_vi_single_command,$_ble_keymap_vi_single_command_overwrite'
    if [[ $keymap == vi_imap ]]; then
      show=1 overwrite=$_ble_edit_overwrite_mode
    elif [[ $_ble_keymap_vi_single_command && ($keymap == vi_nmap || $keymap == vi_omap) ]]; then
      show=1 overwrite=$_ble_keymap_vi_single_command_overwrite
    elif [[ $keymap == vi_[xs]map ]]; then
      show=x overwrite=$_ble_keymap_vi_single_command_overwrite
    else
      name=$bleopt_keymap_vi_mode_string_nmap
    fi
    if [[ $show ]]; then
      if [[ $overwrite == R ]]; then
        name=$bleopt_keymap_vi_mode_name_replace
      elif [[ $overwrite ]]; then
        name=$bleopt_keymap_vi_mode_name_vreplace
      else
        name=$bleopt_keymap_vi_mode_name_insert
      fi
      if [[ $_ble_keymap_vi_single_command ]]; then
        local ret
        ble/string#tolower "$name"
        name="($ret)"
      fi
      if [[ $show == x ]]; then
        ble/prompt/unit/add-hash '${_ble_edit_mark_active%+}'
        local mark_type=${_ble_edit_mark_active%+}
        local visual_name=$bleopt_keymap_vi_mode_name_visual
        [[ $keymap == vi_smap ]] && visual_name=$bleopt_keymap_vi_mode_name_select
        if [[ $mark_type == vi_line ]]; then
          visual_name=$visual_name' '$bleopt_keymap_vi_mode_name_linewise
        elif [[ $mark_type == vi_block ]]; then
          visual_name=$visual_name' '$bleopt_keymap_vi_mode_name_blockwise
        fi
        if [[ $_ble_keymap_vi_single_command ]]; then
          name="$name $visual_name"
        else
          name=$visual_name
        fi
      fi
    fi
    [[ ! $name ]] || ble/prompt/print "$name"
  }
}
blehook/eval-after-load keymap_vi blerc/vim-load-hook

alias ble-update=_ble_fetch

[[ ${BLE_VERSION-} ]] && ble-attach
