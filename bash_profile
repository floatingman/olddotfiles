#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export AWS_ACCESS_KEY_ID="AKIAJDJKVDADZFJTZCBA"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_KEYPAIR_NAME="git-server"
export MY_PUBLIC_SSH_KEY_PATH=$HOME/.ssh/id_rsa.pub
export MY_PRIVATE_AWS_SSH_KEY_PATH=$HOME/.ssh/git-server.pem
