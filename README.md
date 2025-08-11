# Terraform
.terraform/
*.tfstate
*.tfstate.backup
*.tfstate.lock.info

# Build artifacts
backend/target/
frontend/dist/
frontend/node_modules/

# Docker
*.log
*.tar.gz

# IDE files
.idea/
*.iml
.vscode/

# Local environment
.env
*.local
my-key 
my-key.pub

# Test outputs
tests/integration/*.log
tests/terratest/*.log
tests/checkov/*.json
tests/terrascan/*.json