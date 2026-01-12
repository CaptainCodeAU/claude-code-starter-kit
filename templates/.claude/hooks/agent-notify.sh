#!/usr/bin/env bash

set -euo pipefail

# Claude Code hook script - audio notification when agent completes a task
# Uses macOS 'say' for TTS and Notification Center for visual alert
#
# Trigger: Stop, SubagentStop events
# Platform: macOS only
# Requires: jq

# --- Configuration ---
TTS_RATE=175
NOTIFICATION_SOUND="Glass"
MAX_SUMMARY_LENGTH=60

# Get script directory for finding assets
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_SOUND="${SCRIPT_DIR}/../sounds/agent-complete.mp3"

# --- Helper Functions ---

log_info() { echo "[INFO] $*"; }
log_warn() { echo "[WARN] $*" >&2; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

sanitize_for_speech() {
  local text="$1"
  echo "$text" \
    | sed 's/\x1b\[[0-9;]*m//g' \
    | tr '\n\r' '  ' \
    | sed 's/["\`'\''()]//g' \
    | sed 's/  */ /g' \
    | sed 's/^ *//;s/ *$//'
}

# Extract a clean summary from the prompt
# Takes first sentence or truncates at word boundary
extract_summary() {
  local text="$1"
  local max_len="$MAX_SUMMARY_LENGTH"

  # Clean up the text first
  text=$(sanitize_for_speech "$text")

  # If short enough, use as-is
  if [[ ${#text} -le $max_len ]]; then
    echo "$text"
    return
  fi

  # Try to get first sentence (up to period, question mark, or exclamation)
  local first_sentence
  first_sentence=$(echo "$text" | sed 's/[.!?].*//' | head -c "$max_len")

  if [[ ${#first_sentence} -gt 10 && ${#first_sentence} -le $max_len ]]; then
    echo "$first_sentence"
    return
  fi

  # Truncate at word boundary
  local truncated
  truncated=$(echo "$text" | head -c "$max_len" | sed 's/ [^ ]*$//')

  if [[ -n "$truncated" ]]; then
    echo "$truncated"
  else
    echo "${text:0:$max_len}"
  fi
}

# --- Input Processing ---

read_hook_data() {
  if [[ ! -t 0 ]]; then
    cat
  fi
}

extract_prompt_from_transcript() {
  local transcript_path="$1"

  if [[ -z "$transcript_path" || "$transcript_path" == "null" ]]; then
    return 1
  fi

  if [[ ! -f "$transcript_path" || ! -r "$transcript_path" ]]; then
    return 1
  fi

  # Get the first user message from transcript (original task)
  # Handle both string content and array of content blocks
  jq -s '
    map(select(
      .type == "user" and
      .message.role == "user"
    )) | first | .message.content |
    if type == "string" then .
    elif type == "array" then
      map(select(.type == "text") | .text) | first
    else empty
    end // empty
  ' -r < "$transcript_path" 2>/dev/null || true
}

# --- Audio ---

play_completion_sound() {
  if [[ -f "$CUSTOM_SOUND" ]]; then
    afplay "$CUSTOM_SOUND" 2>/dev/null &
  fi
}

speak_message() {
  local message="$1"

  if [[ -z "$message" ]]; then
    return 1
  fi

  message=$(sanitize_for_speech "$message")
  log_info "Speaking: $message"

  say -r "$TTS_RATE" "$message" 2>/dev/null || {
    # Fallback: notification sound
    afplay "/System/Library/Sounds/${NOTIFICATION_SOUND}.aiff" 2>/dev/null || printf '\a'
  }
}

# --- macOS Notification Center ---

send_notification() {
  local title="$1"
  local message="$2"

  osascript -e "display notification \"$message\" with title \"$title\" sound name \"$NOTIFICATION_SOUND\"" 2>/dev/null || true
}

# --- Main ---

main() {
  # Check requirements
  if ! command_exists jq; then
    log_warn "'jq' not found - install with: brew install jq"
    say -r "$TTS_RATE" "Agent finished" 2>/dev/null || true
    exit 0
  fi

  if ! command_exists say; then
    log_warn "Not macOS - exiting"
    exit 0
  fi

  # Read hook data
  local hook_data
  hook_data=$(read_hook_data)

  # Extract prompt from transcript
  local transcript_path=""
  local prompt=""

  if [[ -n "$hook_data" ]]; then
    transcript_path=$(echo "$hook_data" | jq -r '.transcript_path // empty' 2>/dev/null) || true
  fi

  if [[ -n "$transcript_path" ]]; then
    prompt=$(extract_prompt_from_transcript "$transcript_path") || true
  fi

  # Fallback to hook data prompt field
  if [[ -z "$prompt" && -n "$hook_data" ]]; then
    prompt=$(echo "$hook_data" | jq -r '.prompt // empty' 2>/dev/null) || true
  fi

  # Build notification message
  local summary
  if [[ -n "$prompt" ]]; then
    summary=$(extract_summary "$prompt")
  else
    summary="your task"
  fi

  local message="Agent finished: ${summary}"

  # Play completion sound
  play_completion_sound

  # Send visual notification
  send_notification "Claude Code" "$message"

  # Speak it
  speak_message "$message"

  log_info "Done"
}

main "$@"
