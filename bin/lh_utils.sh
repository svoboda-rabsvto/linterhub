# Colors

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"

# Disable colors for Windows
case "$(uname -s)" in
    CYGWIN*|MINGW*|MSYS*)
		ESC_SEQ=""
		COL_RESET=""
		COL_RED=""
		COL_GREEN=""
		COL_YELLOW=""
		COL_BLUE=""
		;;
esac

# Logs
ERROR=8
WARN=4
INFO=2
TRACE=1
RUN=$TRACE

LOG_LEVEL=1

function log ()
{
    level=$1
    if [ ${!level} -lt $LOG_LEVEL ]; then
        return 0
    fi

    case $level in
        ERROR)  echo "${COL_RED}ERROR: $2${COL_RESET}"
                ;;
        WARN)   echo "${COL_YELLOW}WARN : $2${COL_RESET}"
                ;;
        INFO)   echo "${COL_GREEN}INFO : $2${COL_RESET}"
                ;;
        TRACE)  echo "${COL_BLUE}TRACE: $2${COL_RESET}"
                ;;
        RUN)    log TRACE "Start: $0"
                log TRACE "Cmd  : $*"
                ;;
        *)      
                echo $*
                ;;
    esac
}