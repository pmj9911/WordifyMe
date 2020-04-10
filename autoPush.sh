#!/bin/bash
LOCAL_REPO="/home/parthjardosh/GRE/WordifyMe"
cd $LOCAL_REPO
backup_date=$(date +'%m/%d/%Y')
commit_message="removed redundant files" # database update for $backup_date"
echo ${commit_message}
git add .
git commit -m ${commit_message}
git push