## GMAIL-INDICATOR FOR GNOME AND UBUNTU LINUX

Gmail-indicator is a small and efficient background utility for GNOME or
Ubuntu which highlights a panel icon with a count of unread emails in
your Gmail inbox. Notification messages for new emails are also output.
Gmail-indicator integrates into the Ubuntu panel messaging menu in Unity
or GNOME-classic, etc. On GNOME 3, gmail-indicator drives an icon in the
panel.

New mail notifications are pushed immediately from the gmail server
using IMAP idle.

### INSTALLATION ON UBUNTU LINUX

Make sure IMAP access is enabled in the settings on your gmail account.
Then do:

    sudo apt-get install python-pip git gir1.2-appindicator3-0.1
    sudo pip install imapclient
    git clone http://github.com/bulletmark/gmail-indicator
    cd gmail-indicator
    make install  # Do this as your normal user, NOT as sudo/root.

Edit your gmail *username* & *password* in `~/.gmail-indicator-rc`. Also
change the *command* option there to something that works on your system
if you want an audible sound on new emails. Test that command manually
first. Disable, i.e. comment out, the *command* option if you don't want
new email sound. You can also use the *folder* command to check another
label/folder, e.g, *[Gmail]/Important*, rather than the default *INBOX*.

IMPORTANT: Test the program. Check for reported errors, missing packages, etc:

    ~/bin/gmail-indicator -di  # to test
    (<ctrl-c> to stop application)

Search for, and then start, the gmail-indicator app in Ubuntu or GNOME
It will start automatically at log in and run in the
background checking for new mail. On Ubuntu, you can also start
gmail-indicator from the Ubuntu messaging menu.

### REMOVAL

    cd gmail-indicator  # Source dir, as above
    make uninstall      # Do this as your normal user, NOT as sudo/root.

Log out and back in to your Ubuntu or GNOME shell session to complete
removal.

### UPGRADE

    cd gmail-indicator  # Source dir, as above
    git pull
    make install        # Do this as your normal user, NOT as sudo/root.

Log out and back in to your Ubuntu or GNOME shell session to
complete installation.

### LICENSE

Copyright (C) 2013 Mark Blakeney. This program is distributed under the
terms of the GNU General Public License.
This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later
version.
This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License at <http://www.gnu.org/licenses/> for more details.

<!-- vim: se ai syn=markdown: -->
