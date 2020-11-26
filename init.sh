#!/bin/sh

sudo yum install -y docker git
sudo systemctl start docker
sudo docker run -it --rm \
  --expose 80 \
  -p 80:80 \
  --name letsencrypt \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  quay.io/letsencrypt/letsencrypt:latest \
    certonly \
    --standalone \
    --register-unsafely-without-email \
    --renew-by-default \
    -d mt-ftpd.qa.sixapart.info \
    --agree-tos
sudo mkdir -p /etc/vsftpd/private
sudo cat /etc/letsencrypt/live/mt-ftpd.qa.sixapart.info/privkey.pem /etc/letsencrypt/live/mt-ftpd.qa.sixapart.info/cert.pem | sudo tee /etc/vsftpd/private/vsftpd.pem
git clone git@github.com:usualoma/docker-vsftpd.git
cd docker-vsftpd
git checkout docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo /usr/local/bin/docker-compose up
