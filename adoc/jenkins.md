Step 1: Setup Jenkins and GitHub Webhook
1.1 Install Required Plugins in Jenkins
Go to Manage Jenkins → Manage Plugins → Available Tab, install:

Pipeline
Git Plugin
GitHub Integration Plugin
HTML Publisher Plugin
SSH Agent Plugin


Create a GitHub Webhook
Go to your GitHub repository → Settings → Webhooks
Click Add webhook
Payload URL:

http://your-jenkins-server:8080/github-webhook/


Content Type: application/json
Trigger: Just the push event
Click Add Webhook

Step 3: Add the SSH Key to Jenkins Credentials
Go to Jenkins Dashboard → Click on Manage Jenkins

Select "Manage Credentials"

Choose the appropriate credential store:

If global: Select (global)
If per project: Choose the correct domain
Click "Add Credentials"

Choose "SSH Username with private key"

Enter Details:

Username: ubuntu (or the user for SSH)
Private Key:
Select "Enter directly"
Copy-paste the contents of ~/.ssh/jenkins_key

cat ~/.ssh/jenkins_key
ID: jenkins-ssh-key
Description: "SSH key for Jenkins to deploy"

# Generate SSH key:
# ssh-keygen -t rsa -b 4096 -f ~/.ssh/jenkins_key
# copy content of jenkins_key.pub manually to targetserver's (append) authorised_keys

in webserver or app giv jenks permissions to write files
sudo mkdir -p /var/www/react-app/
sudo chown -R ubuntu:ubuntu /var/www/react-app/
sudo chmod -R 775 /var/www/react-app/
