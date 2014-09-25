[![Build Status](https://secure.travis-ci.org/intuit/roark.png)](http://travis-ci.org/intuit/roark)

**Roark has been deprecated. We will not be merging any pull requests or providing updates.**

**We recommend you leverage [Packer](http://packer.io) to build AMIs**

-----

# Roark

Howard Roark, master architect and builder of AMIs.

## Overview

Roark was built to solve the challenge of automating AMI builds across multiple AWS accounts and regions.

* Roark builds AMIs from an Instance created by a Cloud Formation Stack.
* Roark expects to be provided with a Cloud Formation Template that can be used to create this stack.
* This template should create an Instance that is fully configured at bootstrap (via userdata, CloudInit, etc).
* The stack must provide the ID of the Instance to be converted to an AMI (IE. i-1234abcd) as a Cloud Formation Output named **InstanceId**.
* Once the stack is created, Roark will read the Instance ID from the Cloud Formation Output, stop the Instance, convert it into an AMI and destroy the stack.

## Installation

Add this line to your application's Gemfile:

    gem 'roark'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roark

## Usage

### CLI

Once you have a working templated, set your AWS Access and Secret Keys for the target account:

    export AWS_ACCESS_KEY_ID=xxx
    export AWS_SECRET_ACCESS_KEY=yyy

Create AMI

    roark create -n NAME_OF_AMI
                 -r AWS_REGION \
                 -c PATH_TO_CLOUD_FORMATION_TEMPLATE \
                 -p 'Parameter1=value1' \
                 -p 'Parameter2=value2' \
                 -a '123456789012' \
                 -a '123456789013' \
                 -t 'AMITag1=val1' \
                 -t 'AMITag2=val2'

Destroy AMI

    roark destroy -i AMI_ID -r AWS_REGION

## Example

The Cloud Formation Template [example.json](https://raw.github.com/intuit/roark/master/examples/example.json) in the /examples directory will create an AMI based off of the public Amazon Linux AMI.

It will write the file hello\_world.txt as part of bootstraping via userdata.

To create an AMI using this template, set your AWS Access Key and Secret Key:

    export AWS_ACCESS_KEY_ID=xxx
    export AWS_SECRET_ACCESS_KEY=yyy

Download the template:

    wget https://raw.github.com/intuit/roark/master/examples/example.json

Create an AMI:

    roark create -n roark-example-ami -c example.json

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
