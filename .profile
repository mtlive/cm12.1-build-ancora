#Fixes stdin: is not a tty
if `tty -s`
then
    mesg y
    TTY=`tty`
else`
    TTY='not a tty'
fi
#https://unix.stackexchange.com/questions/250945/why-do-i-see-the-error-stdin-is-not-a-tty-when-using-x2go-to-remotely-connect

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

