#!/bin/sh
sed -e

CONFIG_PATH=/data/options.json

MEDIA_PATH=$(jq --raw-output ".media_path" $CONFIG_PATH)

: ${SQUEEZE_UID:=1000}
: ${SQUEEZE_GID:=1000}

groupadd -g $SQUEEZE_GID squeezeboxserver

if [ "$SQUEEZE_VOL" ] && [ -d "$SQUEEZE_VOL" ]; then
	for subdir in prefs logs cache media; do
		mkdir -p $SQUEEZE_VOL/$subdir
	done

    if [ "$MEDIA_PATH" ] && [ -d "$MEDIA_PATH" ]; then
        # Symlink media directory
        ln -sf $SQUEEZE_VOL/media $MEDIA_PATH
    fi
fi

useradd -u $SQUEEZE_UID -g $SQUEEZE_GID \
	-d $SQUEEZE_VOL \
	-c 'Logitech Media Server' \
	squeezeboxserver

# This has to happen every time in case our new uid/gid is different
# from what was previously used in the volume.
chown -R squeezeboxserver:squeezeboxserver $SQUEEZE_VOL

exec runuser -u squeezeboxserver -- /start-squeezebox.sh "$@"