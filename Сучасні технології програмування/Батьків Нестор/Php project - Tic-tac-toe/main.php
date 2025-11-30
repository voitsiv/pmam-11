<?php
$board = [" "," "," "," "," "," "," "," "," "];

function show($b){
    echo "\n";
    for($i=0;$i<9;$i++){
        echo $b[$i];
        if(($i+1)%3==0) echo "\n";
        else echo " | ";
    }
    echo "\n";
}

function win($b,$p){
    $w = [
        [0,1,2],[3,4,5],[6,7,8],
        [0,3,6],[1,4,7],[2,5,8],
        [0,4,8],[2,4,6]
    ];
    foreach($w as $c){
        if($b[$c[0]]==$p && $b[$c[1]]==$p && $b[$c[2]]==$p) return true;
    }
    return false;
}

$player = "X";
while(true){
    show($board);
    echo "Player $player move (0-8): ";
    $m = trim(fgets(STDIN));
    if($m<0 || $m>8 || $board[$m]!=" ") continue;

    $board[$m] = $player;

    if(win($board, $player)){
        show($board);
        echo "Player $player wins!\n";
        break;
    }

    if(!in_array(" ", $board)){
        show($board);
        echo "Draw!\n";
        break;
    }

    $player = ($player=="X"?"O":"X");
}
