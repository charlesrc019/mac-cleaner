#!/bin/bash

# Wait 2 mintues after boot to start.
echo "Starting mac-cleaner.sh on $(date) as $(whoami)..." > /Library/Logs/mac-cleaner.log
echo " " >> /Library/Logs/mac-cleaner.log
echo "Waiting for initialization before working..." >> /Library/Logs/mac-cleaner.log
sleep 120

# Define user and paths.
USER="christensen"
HOME="/Users/$USER"
DESK_LOC="$HOME/Desktop"
DOWN_LOC="$HOME/Downloads"
DOCS_LOC="$HOME/Documents"
TRASH="$HOME/.Trash"

# Move files from Desktop.
echo "Removing files from Desktop." >> /Library/Logs/mac-cleaner.log
find "$DESK_LOC" -maxdepth 1 -mindepth 1 -type f ! -name ".DS_Store" ! -name ".localized" -exec mv -f {} "$DOWN_LOC" \;

# Move files from Documents.
echo "Removing files from Documents..." >> /Library/Logs/mac-cleaner.log
excludes_docs=("# Jay" "# Karla" "# William" "Arduino" "calibre" "Zoom")
exclude_opts_docs=""
for exc in "${excludes_docs[@]}"; do
  exclude_opts_docs="$exclude_opts_docs ! -iname \"$exc\""
done
eval "find \"$DOCS_LOC\" -maxdepth 1 -mindepth 1 ! -name \".DS_Store\" ! -name \".localized\" $exclude_opts_docs -exec mv -f {} \"$DOWN_LOC\" \;"

# Move files from root.
#echo "Remocing files from root..." >> /Library/Logs/mac-cleaner.log
#excludes_root=(".file" ".nofollow" ".resolve" ".vol" ".VolumeIcon.icns" "Applications" "bin" "cores" "dev" "etc" "home" "Library" "opt" "private" "sbin" "System" "tmp" "usr" "Users" "var" "Volumes")
#exclude_opts_root=""
#for exc in "${excludes_root[@]}"; do
#  exclude_opts_root="$exclude_opts_root ! -iname \"$exc\""
#done
#eval "find / -maxdepth 1 -mindepth 1 ! -name \".DS_Store\" ! -name \".localized\" $exclude_opts_root -exec chown -R christensen:staff {} \; #-exec mv -f {} \"$DOWN_LOC\" \;"

# Trash downloads older than 30 days.
echo "Moving expired Downloads to Trash..." >> /Library/Logs/mac-cleaner.log
find "$DOWN_LOC" -maxdepth 1 -mindepth 1 -type f -ctime +30 ! -name ".DS_Store" ! -name ".localized" -exec mv -f {} "$TRASH" \;

echo "All complete!" >> /Library/Logs/mac-cleaner.log
