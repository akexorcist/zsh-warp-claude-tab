# new-claude-tab: open a new Warp tab and start a Claude Code session,
#                 optionally pre-loaded with a hand-off file and/or prompt.
#                 Uses warp://tab_config URI scheme — no keystroke simulation,
#                 no clipboard hijack, no Accessibility permission required.
#
# Usage:
#   new-claude-tab                          # new tab, plain claude
#   new-claude-tab handoff.md               # new tab, file content as first message
#   new-claude-tab handoff.md "also do X"   # file + extra prompt prepended
#   new-claude-tab "" "just a quick task"   # prompt only, no file

new-claude-tab() {
  local file="${1:-}"
  local prompt="${2:-}"

  [[ -n "$file" && -f "$file" ]] && file="$(realpath "$file")"

  local id="${$}_$(date +%s)"
  local msg_file="/tmp/.ct_msg_${id}"
  local config_name="ct_${id}"
  local config_path="${HOME}/.warp/tab_configs/${config_name}.toml"

  # Build message file (only when there's content)
  {
    [[ -n "$prompt" ]] && printf '%s\n\n' "$prompt"
    [[ -n "$file" && -f "$file" ]] && cat "$file"
  } > "$msg_file"

  # Build the claude command; escape " as \" for embedding in a TOML double-quoted string
  local claude_cmd toml_cmd
  if [[ -s "$msg_file" ]]; then
    claude_cmd="claude \"\$(cat ${msg_file}; rm -f ${msg_file})\""
  else
    rm -f "$msg_file"
    claude_cmd="claude"
  fi
  toml_cmd="${claude_cmd//\"/\\\"}"

  # Write Warp Tab Config TOML
  mkdir -p "${HOME}/.warp/tab_configs"
  {
    echo "name = \"${config_name}\""
    echo ""
    echo "[[panes]]"
    echo "id = \"${config_name}\""
    echo "type = \"terminal\""
    echo "directory = \"${PWD}\""
    echo "commands = [\"${toml_cmd}\"]"
  } > "$config_path"

  open "warp://tab_config/${config_name}"
}
