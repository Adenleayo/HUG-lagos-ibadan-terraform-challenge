#!/bin/bash

sudo apt-get update -y

sudo apt-get install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

cat <<EOF >  /var/www/html/index.html

<!DOCTYPE html>
<html>
<head>
<title>HUG Terraform Challenge</title>
</head>

<body>

<h1>Adenle Ayomide</h1>

<h2>HUG Lagos/Ibadan Terraform Challenge</h2>

</body>

</html>

EOF

sudo systemctl restart nginx