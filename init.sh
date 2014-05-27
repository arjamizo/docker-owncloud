#echo INPUT
#tmux new-session -d -s foo $'bash --init-file <(cat <<EOF
#. ~/.bashrc;
#mysql -uroot -p '' -e $"SET GLOBAL general_log_file = \"/dev/shm/mysql.txt\";SET GLOBAL general_log = \"ON\";"
#tail -f /dev/shm/mysql.txt"
#EOF
#)'

tmux new-session -d -s foo 'bash'
APACHELOG=0
MYSQLLOG=1
INTER=2

tmux setw -g mode-mouse on
tmux set -g mouse-select-pane on
tmux set -g mouse-resize-pane on
tmux set -g mouse-select-window on

tmux select-window -t foo:0

tmux split-window #this window is half height, will be used as interactive terminal
tmux select-pane -t 0 # switch to the upper pane
tmux split-window
#After those 3 commands we obtain: 
# |-------| |------|
# |       | | A0   | Apache
# |       | |------|
# |       | | M1   | MySql
# |       |>|------|
# |       | |INTER | Interactive part
# |       | |  2   |
# |       | |      |
# |-------| |------|
#alternatively: tmux split-window -v 'bash --init-file <(echo  ". ~/.bashrc; tail -f /var/log/apache2/error.log")' # split upper pane into to and 

RET='C-m' 

tmux send-keys -t $MYSQLLOG "$(cat <<-'EOF'
service mysql start
mysql -uroot -e 'SET GLOBAL general_log_file = "/dev/shm/mysql.txt" ; SET GLOBAL general_log = "ON"'
tail -f /dev/shm/mysql.txt
EOF
)" $RET

tmux send-keys -t $APACHELOG 'service apache2 start; tail -f /var/log/apache2/error.log' $RET

tmux select-pane -t $INTER
tmux send-keys 'echo this window can be used as regular input' $RET
tmux -2 attach-session -t foo
