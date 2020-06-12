#!/bin/bash

# Step #1: Define variables

RED='\e[91m' #Red color text opening tag
CLC='\e[0m' #close color tag

# Step #2: User defined function

#Install WDL function
install_wdl(){
        ./scripts/install-wdl.sh
}

#Create virtual host function
create_vhost() {
        ./scripts/create-vhost.sh
}

#Remove virtual host function
remove_vhost(){
        ./scripts/remove-vhost.sh
}

#Function to display menus
show_menu() {
	clear
        echo "
WDL - WSL Debian localhost
Copyright (C) 2020  Szymon Krawiec

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see http://www.gnu.org/licenses/.
"

	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Install WDL"
	echo "2. Create virtual host"
	echo "3. Remove virtual host"
        echo "4. Exit"
}

#Read input from the keyboard and take a action
read_options(){
	local choice
	read -p "Enter choice [ 1 - 4] " choice
	case $choice in
		1) install_wdl ;;
		2) create_vhost ;;
                3) remove_vhost ;;
		4) exit 0;;
		*) echo -e "${RED}Error...${CLC} Type your choice again in a moment." && sleep 2 && clear
	esac
}

# Step #3: Trap CTRL+C, CTRL+Z and quit singles
trap '' SIGINT SIGQUIT SIGTSTP

# Step #4: Main logic - infinite loop
while true
do
	show_menu
	read_options
done
