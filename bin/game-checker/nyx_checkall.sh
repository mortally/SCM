for file in /home/dong0/Work/game-checker/*.slg.gz; do perl checkgame.pl $file; echo "$file  result: $?"; done;
