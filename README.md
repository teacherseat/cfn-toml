### What is Cfn-Toml?

cfn-toml will read a toml file that is designed to be used with CloudFormation CLI commands within a bash script.

## How to install

```sh
gem install cfn-toml
```

### How to use

Cfn-Toml automatically looks for a file called `conf.toml` in the working directory.

You can then use the following CLI commands to copy configuration variables into enviroment variables.

### Toml file example
```
[deploy]
profile = 'myprofile'
bucket = 'mybucket'
region = 'us-east-1'
stack_name = 'stack_name'

[parameters]
ArtifactName = 'myartifact'
InstanceType = 't2.micro'
```

### Bash sciprt example
```
#!/usr/bin/env bash

PROFILE=$(cfn-toml key deploy.profile)
BUCKET=$(cfn-toml key deploy.bucket)
REGION=$(cfn-toml key deploy.region)
STACK_NAME=$(cfn-toml key deploy.stack_name)
PARAMETERS=$(cfn-toml params v2)


# deploying stack
echo "== Deploying stack..."
# -----------------
aws cloudformation deploy \
--profile $PROFILE \
--region $REGION \
--stack-name $STACK_NAME \
--s3-bucket $BUCKET \
--template-file template.yaml" \
--parameter-overrides $PARAMETERS \
--capabilities CAPABILITY_NAMED_IAM
```

## Parameters Versions

There are two versions of parameters based on the AWS CLI syntax

### Version1 

When you are using commands like `aws cloudformation create-stack`

```
cfn-toml parameters v1
```

It will output as such:

```
ParameterKey=MyKey,ParameterValue=MyValue ParameterKey=MyKey2,ParameterValue=MyValue2
```

### Version2

When you are using commands like `aws cloudformation deploy`

```
cfn-toml parameters v2
```

It will output as such:

```
MyKey1=MyValue1 MyKey2=MyValue2
```

## Specify Toml Filepath

You can override the default path for toml
cfn-toml parameters v1 --toml /path/to/myconfig.dev.toml
