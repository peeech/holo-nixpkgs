def to_tmux_color(color):
  color as $color
  | {orange: "colour166",
     purple: "colour63"}
  | .[$color] // $color;

def status(color):
  "#[fg=\(to_tmux_color(color))]███#[default]";

if . == "aurora" then
  status("cyan")
elif .flash? then
  "#[blink]" + status(.flash)
elif .static? then
  status(.static)
else
  empty
end
