black=0;
red=0;
blank=0;
kindIP=$(docker inspect bookstio-control-plane | egrep '"IPAddress"':' \"[0-9]' | awk -F':' '{print $2}'| awk -F\" '{print $2}');
for i in {0..999};
  do
    color=$(curl ${kindIP}:30001/productpage 2>/dev/null | grep '<font color="' |awk -F'"' '{print $2} ' | head -1); 
    if [ "$color" = "" ];
      then blank=$[$blank+1];
    elif [ $color = "black" ];
      then black=$[$black+1]; 
    elif [ $color = "red" ]; 
      then red=$[$red+1];
    fi; 
  done
if [ $red -gt 650 -a $red -lt 750 -a $black -gt 120 -a $black -lt 180 -a $blank -gt 120 -a $blank -lt 180 ];
  then echo pass;
else echo failed;
fi;
echo red:$red
echo black:$black
echo blank:$blank
