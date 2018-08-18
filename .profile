# Bash doesn't load its interactive initialization file if it's invoked as
# a login shell, so do it manually.
case $- in
  *i*) if [ -n "$BASH" ]; then . ~/.bashrc;; fi
esac
#source: https://unix.stackexchange.com/questions/109549/stdin-is-not-a-tty-mails-for-running-scripts-as-cron-jobs
