#! /bin/bash

boardState=(" " " " " " " " " " " " " " " " " ")
playerMark='O'
compMark='X'
playerMovesCount=0
compMovesCount=0
startingPlayer=1

function help()
{
	echo "TicTacToe"
	echo
	echo "Syntax: ttt [-h|p|a|s]"
	echo "h - print help."
	echo "p - assign player char (non-whitespace charcter)"
	echo "a - assign computer char (non-whitespace charcter)"
	echo "s - starting player[computer:0|player:1]"
	echo
	echo "Positions values:"
	echo "   |   |   "
	echo " 0 | 1 | 2 "
	echo "___|__ |___"
	echo "   |   |   "
	echo " 3 | 4 | 5 "
	echo "___|__ |___"
	echo "   |   |   "
	echo " 6 | 7 | 8 " 
	echo "   |   |   "
	echo
	echo "Author: Mikolaj Lebioda"
	echo "Index: 101507"
	echo "Subject: Systemy Operacyjne"
}

function main()
{
	currentPlayer=$startingPlayer
	while true;
	do	
		if [[ "$currentPlayer" == 1 ]];
		then
			drawNewBoard "${boardState[@]}"
			echo "Enter position [0-8]:"
			read pos
			while ! isLegalMove $pos
			do
				echo "Given position value in illegal. Try again."
				read pos
			done
			assignNewPlayerMark $pos
			if isWin $playerMark
			then
			echo "You win!"
			break
			fi
		else
			assignNewCompMark
			if isWin $compMark
			then
			echo "You lose!"
			break
			fi
		fi
		if isDraw
		then
			echo "Draw!"
			break
		fi
		switchActivePlayer
	done
	echo "Player's moves: "$playerMovesCount
	echo "Computer's moves: "$compMovesCount
}

function switchActivePlayer()
{
	((currentPlayer++))
	currentPlayer=$((currentPlayer%2))
}

function drawNewBoard()
{
	
	clear
	echo "   |   |   "
	echo " $1 | $2 | $3 "
	echo "___|__ |___"
	echo "   |   |   "
	echo " $4 | $5 | $6 "
	echo "___|__ |___"
	echo "   |   |   "
	echo " $7 | $8 | $9 " 
	echo "   |   |   "
}

function isLegalMove()
{
	result=1
	re='^[0-8]$'	
	if [[ $1 =~ $re ]] # check input
	then 
		if [[ "${boardState[$1]}" == " " ]] # check if pos is free
		then
			result=0
		fi
	fi
	return $result
}

function assignNewPlayerMark()
{
	boardState[$1]=$playerMark
	((playerMovesCount++))
	drawNewBoard "${boardState[@]}"
}

function assignNewCompMark()
{
	pos=$(( $RANDOM % 9 ))
	while ! isLegalMove $pos
	do
		pos=$(( $RANDOM % 9 ))
	done
	boardState[$pos]=$compMark
	((compMovesCount++))
	drawNewBoard "${boardState[@]}"
}

function isDraw()
{
	for (( i=0; i<9; i++ ))
	do
		if [[ "${boardState[$i]}" == " " ]]
		then
			return 1
		fi
	done
	return 0
}

function isWin()
{
	result=1
	if [[ "${boardState[0]}" == "$1" ]]
	then
		if [ "${boardState[1]}" == "$1" -a "${boardState[2]}" == "$1" ]
		then
			result=0
		elif [ "${boardState[3]}" == "$1" -a "${boardState[6]}" == "$1" ]
		then
			result=0
		elif [ "${boardState[4]}" == "$1" -a "${boardState[8]}" == "$1" ]
		then
			result=0
		fi
	elif [[ "${boardState[2]}" == "$1" ]]
	then
		if [ "${boardState[5]}" == "$1" -a "${boardState[8]}" == "$1" ]
		then
			result=0
		elif [ "${boardState[4]}" == "$1" -a "${boardState[6]}" == "$1" ]
		then
			result=0
		fi
	elif [ "${boardState[1]}" == "$1" -a "${boardState[4]}" == "$1" -a "${boardState[7]}" == "$1" ]
	then
		result=0
	elif [ "${boardState[3]}" == "$1" -a "${boardState[4]}" == "$1" -a "${boardState[5]}" == "$1" ]
	then
		result=0
	elif [ "${boardState[6]}" == "$1" -a "${boardState[7]}" == "$1" -a "${boardState[8]}" == "$1" ]
	then
		result=0
	fi
	return $result
}

function assignPlayerChar()
{
	result=1
	re='^\S$'	
	if [[ $1 =~ $re ]] # check input
	then 
		playerMark=$1
		result=0
	fi
	return $result
}

function assignCompChar()
{
	result=1
	re='^\S$'	
	if [[ $1 =~ $re ]] # check input
	then 
		compMark=$1
		result=0
	fi
	return $result
}

function setStaringPlayer()
{
	result=1
	re='^[0|1]$'	
	if [[ $1 =~ $re ]] # check input
	then 
		startingPlayer=$1
		result=0
	fi
	return $result
}

function showInvValErrMsg()
{
	echo "Error: Invalid value"
}

function showInvOptErrMsg()
{
	echo "Error: Invalid option"
}

# START
while getopts ":hp:c:s:" flag; do
	case "${flag}" in
		h)
			help
			exit;;
		p)
			if ! assignPlayerChar $OPTARG
			then
				showInvValErrMsg
				exit 1
			fi;;
		c)
			if ! assignCompChar $OPTARG
			then
				showInvValErrMsg
				exit 1
			fi;;
		s)
			if ! setStaringPlayer $OPTARG
			then
				showInvValErrMsg
				exit 1
			fi;;
		\?)
			showInvOptErrMsg
			exit;;
	esac	
done

main
