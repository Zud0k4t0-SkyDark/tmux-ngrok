#!/bin/bash


tiempo=0.7

trap ctrl_c SIGINT

function ctrl_c (){
	echo -e "\nSaliendo ...."
	tput cnorm
	tmux kill-session -t "a*"
}

echo -en "Que tipo de conxion quiere hacer?\n==> " && read type
tput civis
service ssh start > /dev/null 2>&1

tmux new-session -d -t "a" && sleep $tiempo
tmux split-window -h
tmux select-pane -t 1 && sleep $tiempo
tmux send-keys "ngrok $type  22 > /dev/null 2>&1 & " C-m && sleep $tiempo
tmux select-pane -t 2 && sleep $tiempo
tmux send-keys "curl http://127.0.0.1:4040/api/tunnels" C-m && sleep $tiempo



h=$(curl -s http://127.0.0.1:4040/api/tunnels | jq '.tunnels[0] | .public_url'  | tr -d '"' | cut -d : -f 2 | tr -d /)
p=$(curl -s http://127.0.0.1:4040/api/tunnels | jq '.tunnels[0] | .public_url' | tr -d '"' | cut -d ":" -f 3)

curl -s -X POST https://api.telegram.org/bot"5247063930:AAGM2gFQrW7lEOl-1MWF0GzESG9znAhZnBs"/sendMessage -d chat_id="1395142508" -d text="Host: $(echo $h) y Puerto $(echo $p)" > /dev/null 2>&1

#echo -e "\nHost:\t==> $h\nPuerto:\t==> $p"

#sleep 3600
#tmux kill-session -t "a*"
tput cnorm
