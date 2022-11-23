PASSWORDLENGTH=32
PASSWORDFILE="/lnd/watchtower.password"
# 0. Check if a password file exists
if [ ! -f $PASSWORDFILE ] ; then

    # tr needs to operate on binary input from urandom
    export LC_CTYPE=C

    # 1. generate a password file for the lnd wallet
    < /dev/urandom tr -dc "[:alnum:]" | head -c$PASSWORDLENGTH > $PASSWORDFILE

    # 2. generate tor control password and set up lnd and tor
    TORPASSWORD=$(< /dev/urandom tr -dc "[:alnum:]" | head -c$PASSWORDLENGTH)
    HASHED_TOR_PASSWORD=$(docker run --rm lncm/tor:0.4.7.9 --hash-password $TORPASSWORD)
    echo "tor.password=$TORPASSWORD" >> /lnd/lnd.conf
    echo "HashedControlPassword $HASHED_TOR_PASSWORD" >> /tor/torrc-lnd
fi 
