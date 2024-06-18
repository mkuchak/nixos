if status is-interactive
    # Commands to run in interactive sessions can go here

    # Linux fix terminal control key
    bind \ch backward-kill-word # Control + backspace
    bind \e\[3\;5~ kill-word # Control + delete
    bind \e\[1\;5C forward-word # Control + right arrow
    bind \e\[1\;5D backward-word # Control + left arrow

    # Linux aliases and functions
    alias ll='eza -lahF --group-directories-first --git'
    alias ssh='ssh -o ServerAliveInterval=60'
    alias ssh-reset='ssh-keygen -R'

    # Update Fish configuration
    function fish-update
        set random_md5 (echo (date +%s) | md5sum | awk '{print $1}')
        set url "https://raw.githubusercontent.com/mkuchak/nixos/main/config.fish?v=$random_md5"
        set config_path ~/.config/fish/config.fish
        echo "Downloading Fish configuration from $url..."

        curl -H 'Cache-Control: no-cache, no-store, must-revalidate, max-age=0' -H 'Pragma: no-cache' -H 'Expires: 0' -o $config_path $url

        if test $status -eq 0
            echo "Fish configuration updated successfully."
            source $config_path
        else
            echo "Failed to update Fish configuration."
        end
    end

    # Update NixOS configuration
    function nix-update
        set random_md5 (echo (date +%s) | md5sum | awk '{print $1}')
        set url "https://raw.githubusercontent.com/mkuchak/nixos/main/configuration.nix?v=$random_md5"
        set config_path /etc/nixos/configuration.nix
        echo "Downloading NixOS configuration from $url..."

        curl -H 'Cache-Control: no-cache, no-store, must-revalidate, max-age=0' -H 'Pragma: no-cache' -H 'Expires: 0' -o /tmp/configuration.nix $url

        if test $status -eq 0
            echo "NixOS configuration downloaded successfully."
            sudo mv /tmp/configuration.nix $config_path

            if test $status -eq 0
                echo "NixOS configuration updated successfully."
                sudo nixos-rebuild switch
            else
                echo "Failed to update NixOS configuration."
            end
        else
            echo "Failed to download NixOS configuration."
        end
    end

    # Create a new directory and enter it
    function take
        mkdir $argv[1]
        cd $argv[1]
    end

    # Move all files (including hidden files) from one directory to another
    # Examples: mv-all /path/to/source /path/to/destination; mv-all ..
    function mv-all
        if test (count $argv) -lt 1
            echo "Usage: mv-all [SOURCE_DIR] DESTINATION_DIR"
            return 1
        end
    
        if test (count $argv) -eq 1
            set source_dir .
            set destination_dir $argv[1]
        else
            set source_dir $argv[1]
            set destination_dir $argv[2]
        end
    
        if not test -d $source_dir
            echo "Source directory does not exist: $source_dir"
            return 1
        end
    
        if not test -d $destination_dir
            echo "Destination directory does not exist: $destination_dir"
            return 1
        end
    
        if test (count $source_dir/*) -gt 0
            mv $source_dir/* $destination_dir/
        end
    
        if test (count $source_dir/.*) -gt 0
            mv $source_dir/.* $destination_dir/
        end
    end

    # Command port-list to list processes and their ports
    function port-list
        echo "Process ID | Port | Process Name"

        lsof -i -P -n | while read -l line
            set pid (echo $line | awk '{print $2}')
            set port (echo $line | awk '{print $9}')
            set proc (echo $line | awk '{print $1}')

            if test "$port" != "PORT" -a "$port" != "*" -a "$proc" != "COMMAND"
                echo "$pid | $port | $proc"
            end
        end
    end

    # Command port-kill to kill process using a specific port
    function port-kill
        if test (count $argv) -ne 1
            echo "Usage: pkill <port>"
            return 1
        end

        set port $argv[1]

        set pid (lsof -i :$port | awk 'NR==2{print $2}')

        if test -n "$pid"
            kill $pid
            echo "Process with PID $pid killed."
        else
            echo "No process found using port $port."
        end
    end

    # Command to delete all builds and JavaScript dependencies from current folder
    function clear-project
        rm -rf **/node_modules;
        rm -rf **/.next;
        rm -rf **/.nuxt;
        rm -rf **/.turbo;
        rm -rf **/.cache;
        rm -rf **/target;
        rm -rf **/out;
        rm -rf **/dist;
        rm -rf **/build;
        rm -rf **/coverage;
        rm -rf **/pnpm-lock.yaml;
        rm -rf **/yarn.lock;
        rm -rf **/package-lock.json;
    end

    # GitHub Copilot CLI suggestions
    function copilot
        eval gh copilot suggest '$argv'
    end

    # Docker aliases
    alias d='docker'
    alias dc='docker-compose'
    alias docker-clear='docker stop (docker ps -aq); docker rm -f (docker ps -aq); docker volume rm -f (docker volume ls -q); docker network rm (docker network ls -q); docker rmi -f (docker images -q); docker system prune -fa --volumes; docker container prune -f; docker volume prune -f; docker network prune -f; docker image prune -fa'
    alias docker-start='sudo service docker start'
    alias docker-stop='docker stop (docker ps -aq)'
    alias docker-ps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
    alias docker-top='docker stats $(docker ps --format={{.Names}})'
    alias docker-ip='docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'

    # pnpm aliases and functions
    alias p=pnpm
    alias pnpm-update='pnpm up --interactive --latest --recursive'
    alias pnpm-check='pnpm outdated'
    # alias px='pnpm exec'
    # alias pdx='pnpm dlx'

    function px
        set output (pnpm exec $argv 2>&1)
        set last_exit_status $status

        if test $last_exit_status -ne 0 -a (string match -q "*command not found*" "$output")
            echo "pnpm exec failed with 'command not found', trying pnpm dlx..."
            pnpm dlx $argv
        end
    end
end
