
PAGE="sim-only-plans"
TIMESTAMP=123
SIGNATURE=123
CACHE_DOMAIN="cdn.ampproject.org"
ACTION="flush"

CACHE_CLEAR_URL="https://www.giffgaf-com.$CACHE_DOMAIN/update-cache/c/s/www.giffgaff.com/$PAGE?amp_action=$ACTION&amp_ts=$TIMESTAMP&amp_url_signature=$SIGNATURE"

echo $CACHE_CLEAR_URL
