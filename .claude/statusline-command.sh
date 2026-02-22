#!/usr/bin/env bash
# Claude Code status line — Catppuccin Mocha aesthetic
# Mirrors the starship prompt: directory git_branch* | model context%
#
# Catppuccin Mocha palette (matches dotfiles/starship.toml exactly):
#   Blue   #89b4fa  — directory
#   Green  #a6e3a1  — git branch / clean
#   Mauve  #cba6f7  — model name
#   Peach  #fab387  — context usage warning
#   Red    #f38ba8  — high context usage
#   Base   #1e1e2e  — dark background
#   Overlay #6c7086 — dimmed text / separators

input=$(cat)

# --- Extract data from JSON ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model_name=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# --- Directory: shorten like starship (truncation_length = 3) ---
dir_path="${cwd/#$HOME/~}"
IFS='/' read -ra SEGS <<< "$dir_path"
if [ ${#SEGS[@]} -gt 3 ]; then
    dir_display="…/${SEGS[-3]}/${SEGS[-2]}/${SEGS[-1]}"
else
    dir_display="$dir_path"
fi

# --- Git: branch + modified flag (mirrors starship git_branch + git_status) ---
git_text=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null \
             || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        modified=""
        if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
            modified="*"
        fi
        ahead=$(git -C "$cwd" --no-optional-locks rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
        behind=$(git -C "$cwd" --no-optional-locks rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
        sync=""
        [ "$ahead" -gt 0 ] 2>/dev/null && sync="${sync}↑"
        [ "$behind" -gt 0 ] 2>/dev/null && sync="${sync}↓"
        git_text=" ${branch}${modified}${sync}"
    fi
fi

# --- Context usage coloring ---
# Green -> Peach -> Red as usage rises (mirrors starship character symbols)
ctx_text=""
if [ -n "$used_pct" ]; then
    used_int=${used_pct%.*}
    if [ "$used_int" -ge 80 ] 2>/dev/null; then
        # Red — #f38ba8
        ctx_color="\033[38;2;243;139;168m"
    elif [ "$used_int" -ge 50 ] 2>/dev/null; then
        # Peach — #fab387
        ctx_color="\033[38;2;250;179;135m"
    else
        # Green — #a6e3a1
        ctx_color="\033[38;2;166;227;161m"
    fi
    ctx_text=" ${ctx_color}${used_int}%\033[0m"
fi

# --- Vim mode indicator ---
vim_text=""
if [ -n "$vim_mode" ]; then
    if [ "$vim_mode" = "NORMAL" ]; then
        # Mauve for NORMAL
        vim_text=" \033[38;2;203;166;247mNORMAL\033[0m"
    else
        # Green for INSERT
        vim_text=" \033[38;2;166;227;161mINSERT\033[0m"
    fi
fi

# --- Assemble output ---
# Format: [dir] [git] | [model] [ctx] [vim]
# Colors are foreground-only (dimmed in the status bar anyway)

# Blue directory — #89b4fa
dir_part=$(printf "\033[38;2;137;180;250m%s\033[0m" "$dir_display")

# Green git — #a6e3a1
git_part=""
[ -n "$git_text" ] && git_part=$(printf "\033[38;2;166;227;161m%s\033[0m" "$git_text")

# Separator — Overlay #6c7086
sep=$(printf "\033[38;2;108;112;134m |\033[0m")

# Mauve model — #cba6f7
model_part=""
[ -n "$model_name" ] && model_part=$(printf " \033[38;2;203;166;247m%s\033[0m" "$model_name")

# Build final line
printf "%s%s%s%s%s%s\n" \
    "$dir_part" \
    "$git_part" \
    "$sep" \
    "$model_part" \
    "$ctx_text" \
    "$vim_text"
