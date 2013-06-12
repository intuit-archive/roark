# Roark

Howard Roark, master architect and builder of images.

## Installation

Add this line to your application's Gemfile:

    gem 'roark'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roark

## Usage

Roark builds AMIs from and Instance provided by a Cloud Formation Stack.

Roark expects to be provided with a Cloud Formation Template that can be used to instantiate a stack in the given region.  This stack needs to provide the ID of the instance to be imaged (IE. i-1234abcd) as the output **InstanceId**.

### CLI

Once you have a working templated, set your AWS Access and Secret Keys for the target account:

    export AWS_ACCESS_KEY=xxx
    export AWS_SECRET_KEY=yyy

Create Image

    roark create -n NAME_OF_IMAGE
                 -r AWS_REGION \
                 -t PATH_TO_CLOUD_FORMATION_TEMPLATE \
                 -p 'Parameter1=value1,Parameter2=value2' \
                 --aws-access-key $AWS_ACCESS_KEY \
                 --aws-secret-key $AWS_SECRET_KEY

Destroy Image

    roark destroy -i IMAGE_ID \
                  -r AWS_REGION \
                  --aws-access-key $AWS_ACCESS_KEY \
                  --aws-secret-key $AWS_SECRET_KEY

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
