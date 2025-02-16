# Nginx Troubleshooting Guide

## 1️⃣ Check Nginx Status
```bash
sudo systemctl status nginx
```
- If inactive, start it:
```bash
sudo systemctl start nginx
```
- Enable on boot:
```bash
sudo systemctl enable nginx
```

## 2️⃣ Check Nginx Configuration
```bash
sudo nginx -t
```
- If errors exist, fix them and restart:
```bash
sudo systemctl restart nginx
```

## 3️⃣ Check Firewall (UFW)
```bash
sudo ufw status
```
- If active, allow HTTP & HTTPS:
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload
```

## 4️⃣ Check AWS Security Group Rules
- Go to **AWS EC2 Dashboard → Instances**.
- Select your instance → **Security Groups**.
- Ensure **Inbound Rules** allow:
  - **TCP 80 (HTTP)** from `0.0.0.0/0`
  - **TCP 443 (HTTPS)** from `0.0.0.0/0`

## 5️⃣ Check If Nginx Is Listening on Ports
```bash
sudo netstat -tulnp | grep nginx
```
- Expected output:
  ```
  tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      <nginx-pid>
  tcp6       0      0 :::80                   :::*                    LISTEN      <nginx-pid>
  ```
- If **port 80 or 443 is missing**, check Nginx config.

## 6️⃣ Check Nginx Virtual Host Configuration
```bash
cat /etc/nginx/sites-enabled/default
```
Ensure it contains:
```nginx
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html index.htm;
}
```
Restart Nginx:
```bash
sudo systemctl restart nginx
```

## 7️⃣ Check Public IP Access
```bash
curl -4 ifconfig.co
```
- Try opening `http://your-public-ip` in a browser.

## 8️⃣ Fix SSL (HTTPS) Issues
#### **Check If Nginx Listens on Port 443**
```bash
sudo netstat -tulnp | grep nginx
```
#### **Option 1: Install Let’s Encrypt SSL**
If using a domain, run:
```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d yourdomain.com
```
#### **Option 2: Use a Self-Signed SSL Certificate**
```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
```
Add this to your Nginx config:
```nginx
server {
    listen 443 ssl;
    server_name _;
    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
    root /var/www/html;
    index index.html index.htm;
}
```
Restart Nginx:
```bash
sudo systemctl restart nginx
```

## 9️⃣ Check Nginx Logs for Errors
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## 🔟 Force HTTP Instead of HTTPS (Temporary Fix)
If you don’t need HTTPS:
```nginx
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html index.htm;
}
```
Restart Nginx:
```bash
sudo systemctl restart nginx
```

## ✅ Final Step: Test Access
- Open `http://your-public-ip` or `https://yourdomain.com`
- Use `curl` to test:
```bash
curl -I http://your-public-ip



