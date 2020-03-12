#Check ubuntu version

lsb_release -a | grep "16.04" &> /dev/null
if [ $? == 0 ]; then
  echo "Compatible"
else
  echo "Error this version of Ubuntu is not comapatable, please use version 16.04!"
  exit 1
fi

#Install Prerequisits
apt install -y curl
apt install -y unzip
docker --version > /dev/null 2>&1
if [ $? == "The program 'docker' is currently not installed. You can install it by typing: sudo apt install docker.io" ]; then
  docker_installed=False
else
  docker_installed=True
fi
docker-compose --version > /dev/null 2>&1
if [ $? == "The program 'docker-compose' is currently not installed. You can install it by typing: sudo apt install docker-compose" ]; then
  docker_composed_installed=False
else
  docker_composed_installed=True
fi

if [ "$docker_installed" = true ] && [ "$docker_composed_installed" = true ]; then
  echo "Docker and Docker-compose installed!"
else
  apt update
  apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt-get update
  apt-get install docker-ce -y
  curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

#Clone repo's

curl -L https://github.com/bcgov/von-network/archive/master.zip > bcovrin.zip && \
    unzip bcovrin.zip && cd von-network-master && chmod a+w ./server/
./manage build
