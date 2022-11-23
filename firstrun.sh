PASSWORDLENGTH=32
PASSWORDFILE="/lnd/watchtower.password"
# 0. Check if a password file exists
if [ ! -f $PASSWORDFILE ] || [ $(wc -c $PASSWORDFILE | sed "s/  */ /g"  | cut -d " " -f 2 || echo 0) -ne $PASSWORDLENGTH ]; then

    # tr needs to operate on binary input from urandom
    export LC_CTYPE=C

    # 1. generate a password file for the lnd wallet if it doesnt exist already
    < /dev/urandom tr -dc "[:alnum:]" | head -c$PASSWORDLENGTH > $PASSWORDFILE

    # 2. generate tor control password and set up lnd and tor
    TORPASSWORD=$(< /dev/urandom tr -dc "[:alnum:]" | head -c$PASSWORDLENGTH)
    HASHED_TOR_PASSWORD=$(docker run --rm lncm/tor:0.4.7.9 --hash-password $TORPASSWORD)
    echo "tor.password=$TORPASSWORD" >> /lnd/lnd.conf
    echo "HashedControlPassword $HASHED_TOR_PASSWORD" >> /tor/torrc-lnd
fi 
