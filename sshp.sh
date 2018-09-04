#!/bin/bash
command=$1
path=~/.ssh/sshp/
add(){
    read -r -p "server name:" server_name
    read -r -p "server host:" server_host
    read -r -p "server port(22):" server_port
    read -r -p "server user(root):" server_user
    read -r -p "server password:" server_password

    if [[ -z "$server_name" || -z "$server_host" ]]
    then
    	echo "server_name or server_host does not exist"
    	exit;
    fi

    server_port=${server_port:-22}
    server_user=${server_user:-"root"}

	if [ ! -d $path ]
	then
		( mkdir $path )
	fi

	if [ ! -f $path$server_name ]
	then
		( touch $path$server_name )
	else

		read -r -p "server_name[$server_name] already exists,overwrite[o] or enter new server_name:" action
		if [ ! $action ]
		then
			exit
		fi

		if [ $action == "o" ]
		then
			echo "" > $path$server_name
		else
			if [ $server_name == $action ]
			then
				echo "server_name already exists!"
				exit
			else
				server_name=$action
			fi
		fi

	fi

    echo "server_name=$server_name" >> $path$server_name
    echo "server_host=$server_host" >> $path$server_name
    echo "server_port=$server_port" >> $path$server_name
    echo "server_user=$server_user" >> $path$server_name
    echo "server_password=$server_password" >> $path$server_name
}

ls(){
	for file in $path*
	do
		while read line
		do
		    eval "$line"
		done < $file
	    echo "`basename $file`:$server_host"
	    unset server_host
	done
}

login(){
	if [ ! -f $path$1 ]
	then
		echo "server_name[$1] does not exist"
		exit
	fi
	while read line
	do
	    eval "$line"
	done < $path$1
	expect -c'
	spawn ssh -p '$server_port' '$server_user'@'$server_host'
	expect {
		"*yes/no" { send "yes\r"; exp_continue}
		"*password:" { send "'$server_password'\r" }
	}
	interact
	'
}

delete(){
	read -r -p "do you want to delete[y]?" action
	if [ "$action"x == "y"x ]
	then
		rm -rf $path$1
	fi
	exit
}

case $command in
  (add)
     add
     ;;
  (ls)
     ls
     ;;
  (rm)
     delete $2
     ;;
  (*)
     login $command
     ;;
esac
