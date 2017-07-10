#!/bin/bash

. colors.sh

# GLOBAL VARIABLES

CACHE_DOMAIN="cdn.ampproject.org"
TMP_DIR=".tmp"
DEFAULT_PRIVATE_KEY="/opt/gg/amp-private-key.pem"
DEFAULT_PUBLIC_KEY="/opt/gg/amp-public-key.pem"
PRIVATE_KEY=$DEFAULT_PRIVATE_KEY
PUBLIC_KEY=$DEFAULT_PUBLIC_KEY

printHeader() {
    COLUMNS=$(tput cols)
    clear
    echo -e "\n\n   ___________"
    echo -e "  < AMP CACHE >"
    echo -e "   -----------"
    echo -e "          \   ^__^"
    echo -e "           \  (oo)\_______"
    echo -e "              (__)\       )\/\\"
    echo -e "                  ||----w |"
    echo -e "                  ||     ||\n\n"
}

topMenu() {
    echo -e "${Yellow}Choose action you want to perform\n${Color_Off}"
    PS3='Choose an option: '
    options=("clear amp cache" "exit")
    select opt in "${options[@]}"
    do
        case $opt in
            "clear amp cache")
                clear
                printHeader
                clearCacheMenu
                ;;
            "exit")
                exit 1
                ;;
            *) echo invalid option;;
        esac
    done
}

clearCacheMenu() {
    echo -e "${Yellow}Choose page you want to clear\n${Color_Off}"
    PS3='Choose an option: '
    options=("sim-only-plans" "exit")
    select opt in "${options[@]}"
    do
         case $opt in
            "sim-only-plans")
                clear
                printHeader
                echo "Clearing amp cache"
                clearAmpPageCache "sim-only-plans"
                exit 0
                ;;
            "exit")
                exit 2
                ;;
            *) echo invalid option;;
        esac
    done
}

clearAmpPageCache() {
    PAGE=$1
    ACTION="flush"

    TIMESTAMP=`date +%s`
    UPDATE_CACHE_REQUEST="/update-cache/c/s/www.giffgaff.com/amp/$PAGE?amp_action=$ACTION&amp_ts=$TIMESTAMP"

    echo $CACHE_CLEAR_URL

    echo >$TMP_DIR/url.txt $UPDATE_CACHE_REQUEST
    cat $TMP_DIR/url.txt | openssl dgst -sha256 -sign $AMP_PRIVATE_KEY >$TMP_DIR/signature.bin

    echo "Verifing request signature"

    openssl dgst -sha256 -signature $TMP_DIR/signature.bin -verify $AMP_PUBLIC_KEY $TMP_DIR/url.txt

    if [[ $? -eq 0 ]]; then
        SIGNATURE=`base64 $TMP_DIR/signature.bin`

        CACHE_CLEAR_URL="https://www-giffgaf-com.$CACHE_DOMAIN$UPDATE_CACHE_REQUEST&amp_url_signature=$SIGNATURE"
        # echo $CACHE_CLEAR_URL

        HTTP_CODE=`curl --write-out '%{http_code}' -s --output /dev/null $CACHE_CLEAR_URL`

        if [[ HTTP_CODE -eq 200 ]]; then
            echo -e "\n${Green}Cache cleared${Color_Off}"
        else
            echo -e "\n${Red}Cache not cleared${Color_Off}"
        fi
        echo -e "\n"
    fi
}

printHelp() {
    echo "Amp cache utility"
    echo -e "\nUsage: amp-cache [options]"
    echo -e "\nOptions:\n"
    echo -e "--help \t\tPrints this help"
    echo -e "--private-key \tSpecifies the private key. Default value is /opt/gg/amp-private-key.pem"
    echo -e "--public-key \tSpecifies the public key. Default value is /opt/gg/amp-public-key.pem"
    echo -e "--version \tPrints amp cache version"
    echo ""
}

printVersion() {
    PACKAGE_VERSION=$(cat package.json \
      | grep version \
      | head -1 \
      | awk -F: '{ print $2 }' \
      | sed 's/[",]//g')

    echo $PACKAGE_VERSION
}

parseOptions() {
    while [[ $# -gt 0 ]]
    do
        key="$1"
        case $key in
            --private-key)
            PRIVATE_KEY="$2"
            shift # past argument
            ;;
            --public-key)
            PUBLIC_KEY="$2"
            shift # past argument
            ;;
            --version)
            printVersion
            exit
            ;;
            --help)
            printHelp
            exit 0
            ;;
            *)
                    # unknown option
            ;;
        esac
        shift # past argument or value
    done
}

# RUN
parseOptions $@

printHeader
topMenu
