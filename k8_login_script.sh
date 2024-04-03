#!/bin/sh

########################################
###     Kubernetes log-in script     ###
###     Author: Brian Meyer (DCHBX)  ###
###     Created: 6/5/2022            ###
###     Last Updated: 07/26/2023     ###
########################################
# 2022-12-06: Added additional lower environments and cleaned up spacing, comments, etc.
# This script will log into k8 instances of EA or GDB using bash or irb
# 2023-06-21: Updated spacing a bit and fixed some display typos
# 2023-07-26: Updating PreProd login to include 'container enroll'

# Declare color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#######################################################################################
echo "${GREEN}
                /|  /|  ${CYAN}---------------------------${GREEN}
                ||__||  ${CYAN}|                         |${GREEN}
               /   O O\__  ${CYAN}Welcome to the k8	  |${GREEN}
              /          \   ${CYAN}Sign-In Wizard       |${GREEN}
             /      \     \  ${CYAN}                     |${GREEN}
            /   _    \     \ ${CYAN}----------------------${GREEN}
           /    |\____\     \      ${NC}||${GREEN}
          /     | | | |\____/      ${NC}||${GREEN}
         /       \| | | |/ |     __${NC}||${GREEN}
        /  /  \   -------  |_____| ${NC}||${GREEN}
       /   |   |           |       --|
       |   |   |           |_____  --|
       |  |_|_|_|          |     \----
       /\                  |
      / /\        |        /
     / /  |       |       |
 ___/ /   |       |       |
|____/    c_c_c_C/ \C_c_c_c
${NC}"
#######################################################################################

# Initialization and context listing/changing
echo "
${RED}
*****************************************************************************
***  WARNING: Verify you are on the correct Context before continuing     ***
*****************************************************************************${NC}

Current Context: 
-------------------------" 
context="kubectl config current-context"
eval $context
echo "

"
#########################  Choose Context/NameSpace Section  #########################

echo "${CYAN}Context Choice:
	1 - HBX IT
	2 - PVT-2
	3 - PVT-3
	4 - PVT-4
	5 - PVT-5
	6 - PVT
	7 - PreProd
	8 - PRODUCTION
	0 - Exit
	-----------${NC}
	"

read -p "Context: " context 			# Reads the input to be passed to the case

# This case statement uses the context choice to switch to the proper Context
context_choice=$(case "$context" in
	( "1" )	 echo "kubectx dchbx-pvt-eks-cluster"		;;
	( "2" )	 echo "kubectx dchbx-pvt-eks-cluster"		;;
	( "3" )  echo "kubectx dchbx-pvt-eks-cluster"		;;
	( "4" )  echo "kubectx dchbx-pvt-eks-cluster"		;;
	( "5" )	 echo "kubectx dchbx-pvt-eks-cluster"		;;
	( "6" )	 echo "kubectx dchbx-pvt-eks-cluster"		;;
	( "7" )	 echo "kubectx dchbx-preprod-eks-cluster"	;;
	( "8" )	 echo "kubectx dchbx-prod-eks-cluster"		;;
	( "0" )	 echo "exit e"								;;
esac)

eval $context_choice

# This case statement runs the command to list pods via the choice above
namespace_choice=$(case "$context" in 
	( "1" )	 echo "kubectl get pod -n hbxit"		;;
	( "2" )	 echo "kubectl get pod -n pvt-2"		;;
	( "3" )  echo "kubectl get pod -n pvt-3"		;;
	( "4" )  echo "kubectl get pod -n pvt-4"		;;
	( "5" )	 echo "kubectl get pod -n pvt-5"		;;
	( "6" )	 echo "kubectl get pod -n pvt"			;;
	( "7" )	 echo "kubectl get pod -n preprod"		;;
	( "8" )	 echo "kubectl get pod -n prod"			;;
	( "0" )	 echo "exit e"							;;
esac)

eval $namespace_choice

# This case statement displays human-friendly output of instance chosen in terminal
namespace=$(case "$context" in
	( "1" )	 echo "hbxit"   	;;
	( "2" )  echo "pvt-2"  	 	;;
	( "3" )  echo "pvt-3"   	;;
	( "4" )  echo "pvt-4"   	;;
	( "5" )  echo "pvt-5"   	;;
	( "6" )  echo "pvt"   		;;
	( "7" )	 echo "preprod" 	;;
	( "8" )	 echo "prod"   		;;
esac)

##############################  Choose Pod Section  ##############################

echo "${GREEN}
*****************************************************************************
***             Please choose a pod in ${PURPLE}$namespace${NC} ${GREEN}to continue:                 ***
*****************************************************************************
${NC}"

# Input for pod chosen
read -p "------------------------------------
Pod: " podname

# Displays pod instance chosen to termianl
echo "		Pod $podname selected"

echo "${GREEN}
*****************************************************************************
***                        Select Console Type:                           ***
*****************************************************************************
${NC}"

##############################  Choose Console Section  ##############################

# Gets input for the type of console experience you want to use
echo "${CYAN}Console Type: 
	  1 - irb
	  2 - bash
	  0 - Exit
	  -------
${NC}" 

read -p "Console: " type

# Case function to display human friendly text showing the console type chosen in terminal
console=$(case "$type" in
	( "1" )  echo "irb"		  ;;
	( "2" )  echo "Bash"	  ;;
	( "0" )  echo "exit 0"	;;
esac)

echo "${GREEN}

*****************************************************************************
***               ${PURPLE}$namespace${NC} ${GREEN}Instance on ${PURPLE}$console${NC} ${GREEN}starting up......                ***
*****************************************************************************
"
cat << "EOM"

                          ____
                       _.' :  `._
                   .-.'`.  ;   .'`.-.
          __      / : ___\ ;  /___ ; \      __
        ,'_ ""--.:__;".-.";: :".-.":__;.--"" _`,
        :' `.t""--.. '<@.`;_  ',@>` ..--""j.' `;
             `:-.._J '-.-'L__ `-- ' L_..-;'
               "-.__ ;  .-"  "-.  : __.-"
                   L ' /.------.\ ' J
                    "-.   "--"   .-"
                   __.l"-:_JL_;-";.__
                .-j/'.;  ;""""  / .'\"-.
              .' /:`. "-.:     .-" .';  `.
           .-"  / ;  "-. "-..-" .-"  :    "-.
        .+"-.  : :      "-.__.-"      ;-._   \
        ; \  `.; ;                    : : "+. ;
        :  ;   ; ;                    : ;  : \:
       : `."-; ;  ;                  :  ;   ,/;
        ;    -: ;  :                ;  : .-"'  :
        :\     \  : ;             : \.-"      :
         ;`.    \  ; :            ;.'_..--  / ;
         :  "-.  "-:  ;          :/."      .'  :
           \       .-`.\        /t-""  ":-+.   :
            `.  .-"    `l    __/ /`. :  ; ; \  ;
              \   .-" .-"-.-"  .' .'j \  /   ;/
               \ / .-"   /.     .'.' ;_:'    ;
                :-""-.`./-.'     /    `.___.'
                      \ `t  ._  / 
                       "-.t-._:'

               
EOM

echo "               Be careful, you must! ${NC}

"

##############################  Final Logic Section  ##############################

# Case function used to add proper ending onto the command based on EA or GDB
ending=$(case "$podname" in
	("enroll"* )	echo " -- bin/rails c"  	;;
	("edidb"*  )	echo " -- rails c"			;;
esac)

# Application of the ending chosen above based on console choice above
shell=$(case "$type" in
	("1"	)		echo "$ending"		;;
	("2"	)		echo " -- bash"		;;
esac)

echo ""
echo ""

if [ $namespace == "preprod" ]
	then
		# Runs the fully built command in terminal to launch the instance of k8 for PreProd
		echo "${GREEN}kubectl -n" "$namespace" "exec -ti " "$podname" " --container enroll-deploy-tasks -n preprod " "bundle exec rails c${NC}"
		eval "kubectl -n " "$namespace" "exec -ti " "$podname" " --container enroll-deploy-tasks -n preprod " "bundle exec rails c"

	else
		echo "${GREEN}kubectl -n " "$namespace" "exec -ti " "$podname" "$shell${NC}"
		eval "kubectl -n " "$namespace" "exec -ti " "$podname" "$shell"
fi

echo ""
echo ""
						#### END ####

