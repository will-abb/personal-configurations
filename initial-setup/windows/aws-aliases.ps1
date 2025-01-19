# AWS aliases and functions in PowerShell

# 1. Simple Aliases
Set-Alias sts 'aws sts get-caller-identity'
Set-Alias sso 'aws sso login --profile play'
Set-Alias ec2 'aws ec2 describe-instances --instance-id'
Set-Alias ssm 'aws ssm start-session --target'

# 2. Function to unset AWS environment variables
function unset-aws {
    Remove-Item Env:AWS_ACCESS_KEY_ID
    Remove-Item Env:AWS_SECRET_ACCESS_KEY
    Remove-Item Env:AWS_REGION
    Remove-Item Env:AWS_PROFILE
}

# 3. Functions to set AWS profiles
function dev { $env:AWS_PROFILE = "dev" }
function play { $env:AWS_PROFILE = "play" }
function prod { $env:AWS_PROFILE = "prod" }
function uat { $env:AWS_PROFILE = "uat" }

function devr { $env:AWS_PROFILE = "dev-read" }
function playr { $env:AWS_PROFILE = "play-read" }
function prodr { $env:AWS_PROFILE = "prod-read" }
function uatr { $env:AWS_PROFILE = "uat-read" }
