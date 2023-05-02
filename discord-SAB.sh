#!/bin/bash

# Debug only.
# Set this to 1 to just echo out to console for testing.
DEBUG=0

# The name that the message shows as from in Discord.
CLIENT="SABnzbd"

# The channel webhook you created to post to.
WEBHOOK="https://discord.com/api/webhooks/......"

# You can also create a thread within the above channel and post
# The message to that. This is the ID of that thread channel.
# Uncomment if you want the message to go to the channel.
#THREAD_ID="1234567890"

# If you wish to change the icon image change this.
AVATAR="https://static-00.iconduck.com/assets.00/sabnzbd-text-icon-256x256-k89vgimn.png"

######################################################
#
#	No editing needed below this line.
#
######################################################

CATEGORY=$1
TITLE=$2
MESSAGE=$3

ISO_DATE=$(date +"%Y-%m-%dT%H:%M:%S%z")

case $CATEGORY in
	complete)
		COLOR=65336
		;;
	failed)
		COLOR=16711711
		;;
	*)
		COLOR=16752384
		;;
esac

if [ ! -z "${THREAD_ID}" ]; then
	WEBHOOK=${WEBHOOK}?thread_id=${THREAD_ID}
fi

POST_JSON() {
  cat <<EOF
{
  "username": "${CLIENT}",
  "avatar_url": "${AVATAR}",
  "embeds": [
    {
      "color": ${COLOR},
      "fields": [
        {
          "name": "Categorys",
          "value": "\`\`\`${CATEGORY}\`\`\`",
          "inline": false
        },
        {
          "name": "Torrent Download Finished",
          "value": "\`\`\`${MESSAGE}\`\`\`",
          "inline": true
        },
        {
          "name": "Message",
          "value": "\`\`\`${MESSAGE}\`\`\`",
          "inline": true
        }
      ],
      "author": {
        "name": "${CLIENT}",
        "icon_url": "${AVATAR}"
      },
      "footer": {
        "text": "${CLIENT}"
      },
      "timestamp": "${ISO_DATE}"
    }
  ]
}
EOF
}

if [ "${DEBUG}" == "1" ]; then
	echo ""
	echo "Post to URL:"
	echo $WEBHOOK
	echo ""
	echo "Post JSON content:"
	echo "$(POST_JSON)"
	exit;
fi

echo "$(POST_JSON)" >> json.out
curl -H "Content-Type: application/json" -X POST -d "$(POST_JSON)" $WEBHOOK


