while true; do    
  res=$(vmstat --stats | grep IO-wait | awk '{print $1}')
  date "+%s $res" >> /tmp/stats
  sleep 1
done
