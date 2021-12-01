# T2 SDE from scratch

This project builds a [T2 SDE](https://t2sde.org/) container image and
generates a Dockerfile based on the `scratch` reserved keyword which you
can then use to create custom docker files as you do with other projects.

This repo mostly exists as a convinience tool for people to try T2 from
within their current distribution without the need to spin up a full virtual
machine or install on real hardware.

The image is currently based on the latest published isos.

**Be aware that there isn't any official T2 SDE image on the docker hub
at the moment. If you find any then please report, those are fake.**

## Build

Just run the `build.sh` script and you are good to go.
After that, timply run `docker run -i -t t2sde` and you should have a shell
prompt to start playing around.

*Note that `build.sh` need to be run as root as some steps like `mount`
require root privileges.*

Feel free to modify variables inside to best suite your needs.

## Checksum

The script downloads an iso and verifies its checksum.

Checksums for all isos can be updated quickly as needed like so:

```sh
curl -L "https://dl.t2sde.org/binary/2021/" | grep sha224 \
| sed 's/[^"]*"\([^"]*\).*/\1/' \
| xargs -I@@ curl -L "https://dl.t2sde.org/binary/2021/@@" > checksums.sha224
```

## License

This project is licensed under the GNU AGPLv3.

Note that the license only applies to the assets belonging the this project, this
**does not** alter the original licenses used by the software installed using this
project.
*These of course belong to their original copyright owners and licenses
and we are not responsible for kind of modifications/interactions you would do
to those, as is the case with any software distribution/operating system*.
