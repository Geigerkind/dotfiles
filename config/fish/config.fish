set -U fish_greeting

if status is-interactive
  eval "$(starship init fish)"
end
