####
#
# This is the main bootstrap script that you should launch to use my task setup.
# Of course, you can change all this stuff as much as you like, this is just the
# way I like to run things.
#
####


gnome-terminal  -e "./daily_tasks.sh"

while :
do
    gnome-terminal -e "./hourly_tasks.sh"
    echo "Taking a nap until the next run..."
    ruby -e "sleep 60 * 60"
done
