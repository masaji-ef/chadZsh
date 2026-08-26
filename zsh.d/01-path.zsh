# Set cursor to blinking block
echo -ne "\e[2 q"

# Remove duplicate path entries
typeset -U path

# Add directories to PATH if they exist
add_path() {
  for p in "$@"; do
    [[ -d $p ]] && path=("$p" $path)
  done
}

# Common binary directories
add_path \
  "/usr/local/bin" \
  "/usr/local/sbin" \
  "/snap/bin" \
  "/usr/local/go/bin" \
  "/usr/local/opt/python/libexec/bin" \
  "$(go env GOPATH 2>/dev/null)/bin" \
  "$HOME/.local/bin" \
  "$HOME/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.pyenv/bin" \
  "$HOME/.poetry/bin" \
  "$HOME/.local/share/uv/tools/bin" \
  "$HOME/.nvm/versions/node/*/bin" \
  "$HOME/.local/share/npm/bin" \
  "$HOME/.local/share/pnpm" \
  "$HOME/.bun/bin" \
  "$HOME/.docker/bin" \
  "$HOME/.local/share/flatpak/exports/bin"

export PATH

# CDPATH for cd command - current and home only
export CDPATH=".:~"
