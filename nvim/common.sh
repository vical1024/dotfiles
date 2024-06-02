RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

echo_blue() {
    echo -e "${BLUE}$1${NO_COLOR}"
}

echo_green() {
    echo -e "${GREEN}$1${NO_COLOR}"
}

echo_red() {
    echo -e "${RED}$1${NO_COLOR}"
}

echo_yellow() {
    echo -e "${YELLOW}$1${NO_COLOR}"
}

check_status() {
    if [ $? -eq 0 ]; then
        echo_green "$1"
    else
        echo_red "$2"
        exit 1
    fi
}

create_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        check_status "Created $1" "Failed to create $1"
    fi
}
