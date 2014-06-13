
gnome-terminal  -e "./daily_tasks.sh"

while :
do
    gnome-terminal -e "./hourly_tasks.sh"
    echo "Taking a nap until the next run..."
    ruby -e "sleep 60 * 60"
done
