set -e

source bin/colors.sh
echo "${COL_BLUE}TRACE: Start $0${COL_RESET}"
echo "${COL_BLUE}TRACE: $@${COL_RESET}"

# Entry point
function main() {
    case $Mode in
        # Engine commands
        -b|build)    engine_build;;
        -a|analyze)  engine_analyze;;
        -s|export)   engine_export;;
        # Engine debug commands
        -r|run)      engine_run;;
        -e|exec)     engine_exec;;
        -d|destroy)  engine_destroy;;
    esac
}

function parse_args() {
    while [[ $# -gt 1 ]] 
    do
        key="$1"
        case $key in
            --mode)      Mode="$2";;
            --dock)      EngineDock="$2";;
            --image)     EngineImage="$2";;
            --instance)  EngineInstance="$2";;
            --path)      Path="$2";;
            --output)    Output="$2";;
            --command)   Command="$2";;
            --workdir)   Workdir="$2";;
            --share)     Share="$2";;
            --prefix)    Prefix="$2";;
            --start)     Startup="$2";;
        esac
        shift
        shift
    done
}

# Engine functions
function engine_build()
{
    echo "${COL_GREEN}INFO: Build linter dock${COL_RESET}"
    docker build --build-arg WORKDIR=$Workdir -t $EngineImage -f $EngineDock . 
}

function engine_analyze()
{
    echo "${COL_GREEN}INFO: Run analysis${COL_RESET}"
    if [ ! "$Output" ];
        then docker run -i --rm --name $EngineInstance --volumes-from=$Share $EngineImage $Command
        else docker run -i --rm --name $EngineInstance --volumes-from=$Share $EngineImage $Command > "$Output"
    fi
}

function engine_export()
{
    echo "${COL_GREEN}INFO: Save dock${COL_RESET}"
    mkdir -p images
    docker save $EngineImage | gzip -c
}

# Engine debug functions
function engine_run()
{
    echo "${COL_GREEN}INFO: Run linter dock${COL_RESET}"
    docker run -i -d --name $EngineInstance --volumes-from=$Share $EngineImage $Startup
}

function engine_exec()
{
    echo "${COL_GREEN}INFO: Execute command in linter dock${COL_RESET}"
    docker exec -it $EngineInstance $Command
}

function engine_destroy()
{
    echo "${COL_GREEN}INFO: Destroy linter dock${COL_RESET}"
    docker rm -f $EngineInstance
}

# Engine image functions
function engine_images()
{
    echo "docker images"
    #docker images | grep $Prefix
}

function engine_online()
{
    echo "docker search"
}

function engine_offline()
{
    echo "ls"
    # ls -d */ | sed 's#/##'
}

parse_args "$@"
main "$@"
exit $?