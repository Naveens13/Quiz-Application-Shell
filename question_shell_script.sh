#!/bin/bash

#User cred file
USERNAME_FILE="./user_cred.csv"
QUES="./quiz.csv"
CRCT="0"
WR="0"

#Display if Sign Up and Sign In
read -p "Sign In(1) / Sign Up(2): " CRED_USR
echo "${CRED_USR}"
USR_FLAG="false"
AUTH="false"

#Sign UP process.......
if [[ ${CRED_USR} = 2 ]]
then
	echo "SIGNING UP....."
	read -p "UserName- " USERNAME
	read -p "Password- " PSWD
	read -p "Retype Password- " REPSWD
	echo "${USERNAME} - ${PSWD}"
	if [[ ${PSWD} = ${REPSWD} ]]
	then
		echo "Password matched..."
		echo "Setting password......"
		echo "${USERNAME}, ${PSWD}" >> ${USERNAME_FILE}
	        echo "Sign up completed....."
		USR_FLAG="true"	
	else
		echo "Password mismatch retry......."
		exit 1
	fi
fi

#Sign IN process.......
if [[ ${CRED_USR} = 1 || ${USR_FLAG} = "false" ]]
then
	if [[ ${USR_FLAG} = "false" ]]
	then
		echo "SIGNING IN....."
		read -p "Username:- " USR_NAME
		read -p "Password:- " PAWSD
		echo "${USR_NAME} - ${PAWSD}"

		#Read through the user credential file
		while read lines
		do
			UNSR=$(echo "${lines}" | awk -F ", " '{print $1}')
			PNSW=$(echo "${lines}" | awk -F ", " '{print $2}')
			if [[ ${USR_NAME} = ${UNSR} && ${PAWSD} = ${PNSW} ]]
			then
				echo "Authenticated......."
				AUTH="true"
			fi
		done < "${USERNAME_FILE}"
	fi
	
	#Exit if wrong cred
	if [[ ${AUTH} = "false" ]] 
	then
		echo "Not authorized......"
		exit 1
	fi


	if [[ ${USR_FLAG} = "true" ]]
	then
		echo "For sign-in please rerun......"
	fi
fi

#Display the questions
if [[ ${AUTH} = "true" ]]
then
	echo "Starting......"

	while read -u 3 questions
	do
		QUIZIN=$(echo "${questions}" | awk -F ", " '{print $1}')
		ANS=$(echo "${questions}" | awk -F ", " '{print $2}')
		echo "${QUIZIN}"
		#echo "${ANS}"
		read -p "Your answer " wer
		if [[ ${wer} = ${ANS} ]]
		then
			echo "!!!Correct answer!!!"
			CRCT=$((CRCT+1))
		else
			echo "Wrong answer!!"
			WR=$((WR+1))
		fi
	done 3< "${QUES}"

	echo "------------------Quiz Results------------------"
	echo "Wrong question- ${WR}, Correct Question- ${CRCT}"
fi
