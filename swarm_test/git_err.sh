email="$1"
hostname="$2"
hostalias="$hostname"
keypath="$HOME/.ssh/${hostname}_rsa"
ssh-keygen -t rsa -C $email -f $keypath
if [ $? -eq 0 ]; then
cat >> ~/.ssh/config <<EOF
Host $hostalias
        Hostname $hostname
        User git
    IdentitiesOnly yes
        IdentityFile $keypath
EOF
fi
