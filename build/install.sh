install_main(){
    echo "installing"
}

upgrade_main(){
    echo "upgrading"

    if [ ! -e /var/log/nginx/steps.mograbi.info ]; then
        mkdir -p /var/log/nginx/steps.mograbi.info
    fi

    if [ ! -e /tmp/steps ]; then
        mkdir /tmp/steps
    fi

    cd /tmp/steps
    wget -O steps.tar.gz "https://dl.dropboxusercontent.com/s/x55nvcluv11663i/steps-project-manager-0.0.0.tgz?dl=1&token_hash=AAF2MN4D-TvZrYguMZ8phu6GAIHamyhbdi4LOAYnQdA66Q"
    tar -xzvf steps.tar.gz

    rm -rf /var/www/steps
    cp -r /tmp/steps/package /var/www/steps
    rm -rf /tmp/steps

    cp -f /var/www/steps/build/nginx.conf /etc/nginx/sites-enabled/steps.mograbi.info.conf
}

set -e

if [ "$1" == "upgrade" ];then
   upgrade_main
else
   install_main
fi