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

SEEDFILENAME="watchtower.seed"

if [ ! -f "/lnd/$SEEDFILENAME" ] ; then
    docker run --rm --entrypoint /bin/lndinit lightninglabs/lndinit:v0.1.7-beta-lnd-v0.15.4-beta gen-seed > "/lnd/$SEEDFILENAME"
fi

# 3. https://github.com/lightninglabs/lndinit#init-wallet
docker run --rm --entrypoint /bin/lndinit -v $LND_PATH/lnd:/.lnd lightninglabs/lndinit:v0.1.7-beta-lnd-v0.15.4-beta init-wallet -v --secret-source=file --init-type=file --file.seed="/.lnd/$SEEDFILENAME" --file.wallet-password="/.lnd/watchtower.password" --init-file.output-wallet-dir=/.lnd/data/chain/bitcoin/mainnet --init-file.validate-password