#!/bin/sh -x

SESSION=rigdashboard
LOCAL1=local1
LOCAL2=local2
MULTI1=all # has extra pane for rig0
MULTI2=rigs1
MULTI3=rigs2
MULTI4=rigs3

cd # go home

tmux att -d -t $SESSION && exit 0 # already done

while read args
do
    test "x$args" = x && continue
    tmux $args
done <<EOF
new-session -d -s $SESSION
rename-window $LOCAL1
select-window -t $LOCAL1

new-window -n $LOCAL2
select-window -t $LOCAL2
split-window -dh -p 50
select-layout tiled

new-window -n $MULTI1
select-window -t $MULTI1
split-window -dv -p 10
split-window -dh -p 10
split-window -dh -p 10
split-window -dv -p 10
split-window -dh -p 10
split-window -dh -p 10
select-layout tiled

new-window -n $MULTI2
select-window -t $MULTI2
split-window -dv -p 10
split-window -dh -p 10
split-window -dh -p 10
split-window -dv -p 10
split-window -dh -p 10
select-layout tiled

new-window -n $MULTI3
select-window -t $MULTI3
split-window -dv -p 10
split-window -dh -p 10
split-window -dh -p 10
split-window -dv -p 10
split-window -dh -p 10
select-layout tiled

new-window -n $MULTI4
select-window -t $MULTI4
split-window -dv -p 10
split-window -dh -p 10
split-window -dh -p 10
split-window -dv -p 10
split-window -dh -p 10
select-layout tiled
EOF

for window in $MULTI1 $MULTI2 $MULTI3 $MULTI4 ; do
    for pane in 1 2 3 4 5 6 ; do
        host="backplane-rig$pane"
        tmux send-keys -t "$window.$pane" "sleep $pane ; ssh $host" C-m
    done
    tmux set-window-option -t $window synchronize-panes on
done

exec tmux att -t $SESSION
exit 1
