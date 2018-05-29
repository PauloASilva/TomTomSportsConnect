TomTom Sports Connect Container
===============================

This is an effort to run TomTom Sports Connect from within a Docker container.

TomTom Sports Connect is a desktop application required to update TomTom
Adventurer sports watch, which is available and maintained for Microsoft
Windows and MacOS operating systems.

There's also an [unofficial Linux version][1] (`.deb`) tested on Ubuntu 14.04
and 16.04. It was also reported to work on Ubuntu 17.04, 17.10, 18.04 and
Mint 18 ([follow the discussion][2]).

This is my effort to make TomTom Sports Connect run on all Linux systems.

![TomTom Sports Connect running containerized][screenshot]

## How it works

Host machine `/tmp/.X11-unix` socket and `/dev/bus/usb` devices are shared with
a docker container runnnig [TomTom Sports Connect unofficial Linux version][1]
allowing TomTom Sports Connect usage wherever there's a running docker instance.

## How to use

1. Clone this repo
    ```
    $ git clone https://github.com/PauloASilva/TomTomSportsConnect && cd TomTomSportsConnect
    ```
2. Build docker image
    ```
    $ docker build -t tomtomsc:latest .
    ```
3. Run TomTom Sports Connect
    ```
    $ ./TomTomSportsConnect
    ```

    optionally you can run the container yourself
    ```
    $ docker run -it \
        --privileged \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /dev/bus/usb:/dev/bus/usb \
        -e DISPLAY=unix$DISPLAY \
        --name tomtomsc \
        --rm \
        TomTomSportsConnect
    ```

    **Note**: you may have to disable X access control to get the X11 forwarded.
    To do so run `$ xhost +` before running `TomTomSportsConnect` or
    `docker run`

## Caveats

* X access control (`xhost` needs to be disabled)
    ```
    $ xhost +
    ```

## License

Copyright (c) 2018

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

**Note**:
* Linux® is the registered trademark of Linus Torvalds in the U.S. and other
countries;
* TomTom Sports Connect is property of TomTom International BV.

[screenshot]: ./screenshot.png

[1]: https://uk.support.tomtom.com/app/answers/detail/a_id/24741
[2]: https://en.discussions.tomtom.com/sports-connect-apps-website-389/tomtom-sports-connect-for-linux-1021269

