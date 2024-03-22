printf "\n"
printf "==============================================================\n"
printf "*************** CBI INSTALL C MODBUS *************************\n"
printf "==============================================================\n"
printf "Note : Please backup folder app first!!!!!!!!!!!!!!!!!!!!!!!!!\n"
printf "\n"
read -p "Personal Access Token: " token
if [ -z "$token" ]
then
  token="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"
fi

read -p "Branch (main): " branch
if [ -z "$branch" ]
then
  branch="main"
fi

read -p "Username (cbi): " username
if [ -z "$username" ]
then
  username="cbi"
fi

read -s -p "Password (cbipa55word): " password
if [ -z "$password" ]
then
  password="cbipa55word"
fi

printf "\n"
printf "Module :\n"
printf "1. WQMS Onlimo\n"
printf "2. AQMS\n"
printf "Select Module (1):"
read module

if [ -z "$module" ] || [ $module == "1" ]
then
  selected_module="wqms_onlimo"
elif [ $module == "2" ]
then
  selected_module="aqms"
else
  selected_module="invalid module"
fi

printf "\n"
if [[ $selected_module != "invalid module" ]]; then
  cd ~
  rm -fr dtlogger
  git clone "https://${token}@github.com/acepahmads/dtlogger.git"
  cd dtlogger
  git checkout "${branch}"
  pip3 install -r requirements.txt
  printf "change permission\n"
  echo "$password" | sudo -S chmod +x *
  echo "$password" | sudo -S ln -fs ~/dtlogger/runmodbus /bin/runmodbus
  echo "$password" | sudo -S ln -fs ~/dtlogger/killmodbus /bin/killmodbus
  echo "$password" | sudo -S ln -fs ~/dtlogger/checkmodbus /bin/checkmodbus
  echo "$password" | sudo -S ln -fs ~/dtlogger/runmodbus1 /bin/runmodbus1
  echo "$password" | sudo -S ln -fs ~/dtlogger/killmodbus1 /bin/killmodbus1
  cd ~/.config
  mkdir -p autostart
  cp -f ~/dtlogger/runmodbus.desktop ~/.config/autostart
  if [[ $selected_module == "wqms_onlimo" ]]; then
    cp -f ~/dtlogger/models.py ~/app/instrumen/datalogger/models/
  elif [ $selected_module == "aqms" ];
  then
    cp -f ~/dtlogger/aqms/models.py ~/app/instrumen/datalogger/models/
  else
    echo "no module found"
  fi
else
  echo "$selected_module"
fi
