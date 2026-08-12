#!/bin/sh
set -e

aws_account="$(aws sts get-caller-identity --query Account --output text)"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_account}.dkr.ecr.us-east-1.amazonaws.com
