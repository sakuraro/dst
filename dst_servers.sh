#!/bin/bash

steamcmd_dir="$HOME/Steam"
install_dir="$HOME/Steam/steamapps/common/Don't Starve Together Dedicated Server"
config_dir="$HOME/.klei/DoNotStarveTogether"
cluster_name="MyDediServer"

function fail()
{
	echo Error: "$@" >&2
	exit 1
}

function check_for_file()
{
	if [ ! -e "$1" ]; then
		fail "Missing file: $1"
	fi
}

function install_deps()
{
    # install dependencies
    dpkg --add-architecture i386
    apt update
    apt install -y wget libstdc++6:i386 libgcc1:i386 libcurl3-gnutls libcurl4-gnutls-dev:i386
    # clean cache
    rm -rf /var/lib/apt/lists/*
    # install steam
    mkdir -p $steamcmd_dir
    cd $steamcmd_dir
    wget -qO - 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar -xvzf -
    chmod u+x ./steamcmd.sh
    ./steamcmd.sh +login anonymous +quit
}

function install()
{
    cd $steamcmd_dir
    ./steamcmd.sh +login anonymous +app_update 343050 +quit
}

function validate()
{
    cd $steamcmd_dir
    ./steamcmd.sh +login anonymous +app_update 343050 validate +quit
}

function run()
{
    # run game
    check_for_file "$config_dir/$cluster_name/cluster.ini"
    check_for_file "$config_dir/$cluster_name/cluster_token.txt"
    check_for_file "$config_dir/$cluster_name/Master/server.ini"
    check_for_file "$config_dir/$cluster_name/Caves/server.ini"

    cd "$install_dir/bin64"
    run_shared=(./dontstarve_dedicated_server_nullrenderer_x64)
    run_shared+=(-console)
    run_shared+=(-cluster "$cluster_name")
    run_shared+=(-monitor_parent_process $$)

    "${run_shared[@]}" -shard $1  | sed "s/^/$1:  /"
}

if [ "$1" == "install_deps" ]; then
    install_deps
elif [ "$1" == "install" ]; then
    install
elif [ "$1" == "validate" ]; then
    validate
elif [ "$1" == "run" ]; then
    run $2
else
    echo "无效参数"
fi
