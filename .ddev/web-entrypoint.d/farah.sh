#!/usr/bin/env bash

set -eu

if [ ! -e /var/www/vendor ] && [ ! -L /var/www/vendor ]; then
    ln -s /var/www/html/vendor /var/www/vendor
fi
