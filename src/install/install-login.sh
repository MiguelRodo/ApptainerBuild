#!/usr/bin/env bash

set -e

# add login-github script to
# enable plain-text credential store

cat > /usr/local/bin/login-github \
<< 'EOF'
#!/usr/bin/env bash

# Use plain-text credential store
git config --global credential.helper 'store'

# Get GitHub username
# username=$(gh api user | jq -r '.login')
username=$GITHUB_USERNAME

# Get GitHub PAT from environment variable
PAT=$GITHUB_PAT

# Create a credential string
credential_string="protocol=https
host=github.com
username=$username
password=$PAT"

# Write the credential string to a temporary file
temp_file=$(mktemp)
echo "$credential_string" > $temp_file

# Use the temporary file as the input for 'git credential approve'
git credential approve < $temp_file

# Delete the temporary file
rm $temp_file

EOF

chmod +x /usr/local/bin/login-github

## login to XetHub

cat > /usr/local/bin/login-xethub\
<< 'EOF'
#!/usr/bin/env bash
git xet login -u "$XETHUB_USERNAME" -e "$XETHUB_EMAIL" -p "$XETHUB_TOKEN"
EOF

chmod +x /usr/local/bin/login-xethub
