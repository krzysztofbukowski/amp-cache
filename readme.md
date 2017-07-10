# AMP CACHE TOOL

This is a simple bash script for managing AMP cache.

##### USAGE
```bash
Usage: amp-cache [options]

Options:

--help          Prints this help
--private-key   Specifies the private key. Default value is /opt/gg/amp-private-key.pem
--public-key    Specifies the public key. Default value is /opt/gg/amp-public-key.pem
--version       Prints amp cache version
```

## DEVELOPMENT

The whole tool is implemented using bash scripting (see the `run.sh` file). All relevant code is grouped into functions for better readability and maintainability.

## BUILD

The final artifact for this project is an rpm package. To build it we use `grunt` and `grunt-rpm`

The build requires nodejs installed on the machine. You can get it with `nvm`.
Then install required dependencies with `npm install`. You'll also need globally installed `grunt-cli`. Install it by running `npm i -g grunt-cli`.
Finally you can build the rpm. Run `grunt build`.

You should get output like this:

```bash
grunt build
Running "rpm:main" (rpm) task
Spawning rpmbuild: {"cmd":"rpmbuild","args":["-bb","--target","noarch","--buildroot","/Users/krzysztof/Development/amp-cache/dist/rpm/tmp","/Users/krzysztof/Development/amp-cache/dist/rpm/SPECS/amp-cache.spec"]}

Done, without errors.
```

## INSTALLATION

To install the distribution package use `rpm`.

`rpm -Uvh amp-cache-1.0.0-1.noarch.rpm`

After successful installation you should be able to use the tool.

`amp-cache --version`
