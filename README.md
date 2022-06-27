# NodeJS High Availability
Example HA infrastructure for simple NodeJS applications implemented in Terraform.

## Prerequisites
1. Terraform Cloud account (Free or better).
2. AWS account with `AmazonEC2FullAccess` and `AutoScalingFullAccess` permissions.
3. Access key with ID and secret for the above account.

## How to run
1. Create a workspace in Terraform Cloud.
2. Connect it to GitHub repository https://github.com/pawelpesz/nodejs-high-availability.git.
3. Configure `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` environment variables in Terraform Cloud.
4. Optionally overwrite variable defaults.
5. Start a run, first one will set up the infrastructure and fire the benchmark. Subsequent applies will trigger the benchmark again.

## Architecture overview
![Architecture overview](architecture.jpg)
