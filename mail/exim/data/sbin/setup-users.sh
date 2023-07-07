#/bin/ash

echo "SETUP-USERS"
echo "Users (mkpasswd -m sha-512 xxx)"

id user1 && echo "User user1 already created" || {
  echo "Setup user user1.."
  mdp='$6$B.OAXOaGNyped6TD.......'
  echo 'user1:x:2001:2001:Prenom NOM1,,,:/home/user1:/sbin/nologin' >> /etc/passwd
  echo 'user1:'$mdp':16950:0:99999:7:::' >> /etc/shadow
  mkdir /home/user1
  chmod 750 /home/user1
  addgroup -g 2001 user1
  chown user1:root /home/user1
}

id cloud && echo "User user2 already created" || {
  echo "Setup user user2.."
  mdp='$6$B.OAXOaGNyped6T.............'
  echo 'user2:x:2002:2002:Prenom NOM2,,,:/home/user2:/sbin/nologin' >> /etc/passwd
  echo 'user2:'$mdp':16950:0:99999:7:::' >> /etc/shadow
  mkdir /home/user2
  chmod 750 /home/user2
  addgroup -g 2002 user2
  chown user2:root /home/user2
}

echo FIN SCRIPT SETUP-USER
