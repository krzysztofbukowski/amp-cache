
TMP_DIR=".tmp"

PAGE="sim-only-plans"
TIMESTAMP=`date +%s`
SIGNATURE=123
CACHE_DOMAIN="cdn.ampproject.org"
ACTION="flush"
UPDATE_CACHE_REQUEST="/update-cache/c/s/www.giffgaff.com/amp/$PAGE?amp_action=$ACTION&amp_ts=$TIMESTAMP"

CACHE_CLEAR_URL="https://www-giffgaf-com.$CACHE_DOMAIN$UPDATE_CACHE_REQUEST&amp_url_signature=$SIGNATURE"

echo $CACHE_CLEAR_URL

echo >$TMP_DIR/url.txt $UPDATE_CACHE_REQUEST
cat $TMP_DIR/url.txt | openssl dgst -sha256 -sign amp-private-key.pem >$TMP_DIR/signature.bin

echo "Verifing request signature"

openssl dgst -sha256 -signature $TMP_DIR/signature.bin -verify amp-public-key.pem $TMP_DIR/url.txt
