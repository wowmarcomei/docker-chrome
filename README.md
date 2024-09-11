# Docker container for Chromium
[![Release](https://img.shields.io/github/release/yourusername/docker-chromium.svg?logo=github&style=for-the-badge)](https://github.com/yourusername/docker-chromium/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/yourusername/chromium/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/yourusername/chromium/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/yourusername/chromium?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/yourusername/chromium)
[![Docker Stars](https://img.shields.io/docker/stars/yourusername/chromium?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/yourusername/chromium)
[![Build Status](https://img.shields.io/github/actions/workflow/status/yourusername/docker-chromium/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/yourusername/docker-chromium/actions/workflows/build-image.yml)

This project implements a Docker container for [Chromium](https://www.chromium.org/Home), based on the [docker-firefox](https://github.com/jlesage/docker-firefox) project by jlesage.

The GUI of the application is accessed through a modern web browser (no
installation or configuration needed on the client side) or via any VNC client.

---

[![Chromium logo](https://raw.githubusercontent.com/chromium/chromium/master/chrome/app/theme/chromium/product_logo_256.png)](https://www.chromium.org/Home)

Chromium is a free and open-source web browser project, principally developed and maintained by Google.

---

## Quick Start

Launch the Chromium docker container with the following command:
```shell
docker run -d \
    --name=chrome \
    -p 5800:5800 \
    -v /docker/appdata/chrome:/config:rw \
    wowmarcomei/docker-chrome
```

Where:
  - `/docker/appdata/chrome`: This is where the application stores its configuration, states, log and any files needing persistency.

Browse to `http://your-host-ip:5800` to access the Chromium GUI.

## Usage

```shell
docker run [-d] \
    --name=chrome \
    [-e <VARIABLE_NAME>=<VALUE>]... \
    [-v <HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]]... \
    [-p <HOST_PORT>:<CONTAINER_PORT>]... \
    wowmarcomei/docker-chrome
```

| Parameter | Description |
|-----------|-------------|
| -d        | Run the container in the background. If not set, the container runs in the foreground. |
| -e        | Pass an environment variable to the container. See the [Environment Variables](#environment-variables) section for more details. |
| -v        | Set a volume mapping (allows to share a folder/file between the host and the container). See the [Data Volumes](#data-volumes) section for more details. |
| -p        | Set a network port mapping (exposes an internal container port to the host). See the [Ports](#ports) section for more details. |

### Environment Variables

To customize some properties of the container, the following environment
variables can be passed via the `-e` parameter (one for each variable). Value
of this parameter has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable       | Description                                  | Default |
|----------------|----------------------------------------------|---------|
|`USER_ID`| ID of the user the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | `1000` |
|`GROUP_ID`| ID of the group the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | `1000` |
|`SUP_GROUP_IDS`| Comma-separated list of supplementary group IDs of the application. | (no value) |
|`UMASK`| Mask that controls how permissions are set for newly created files and folders.  The value of the mask is in octal notation.  By default, the default umask value is `0022`, meaning that newly created files and folders are readable by everyone, but only writable by the owner.  See the online umask calculator at http://wintelguy.com/umask-calc.pl. | `0022` |
|`LANG`| Set the [locale](https://en.wikipedia.org/wiki/Locale_(computer_software)), which defines the application's language, **if supported**.  Format of the locale is `language[_territory][.codeset]`, where language is an [ISO 639 language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes), territory is an [ISO 3166 country code](https://en.wikipedia.org/wiki/ISO_3166-1#Current_codes) and codeset is a character set, like `UTF-8`.  For example, Australian English using the UTF-8 encoding is `en_AU.UTF-8`. | `en_US.UTF-8` |
|`TZ`| [TimeZone](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones) used by the container.  Timezone can also be set by mapping `/etc/localtime` between the host and the container. | `Etc/UTC` |
|`KEEP_APP_RUNNING`| When set to `1`, the application will be automatically restarted when it crashes or terminates. | `0` |
|`APP_NICENESS`| Priority at which the application should run.  A niceness value of -20 is the highest priority and 19 is the lowest priority.  The default niceness value is 0.  **NOTE**: A negative niceness (priority increase) requires additional permissions.  In this case, the container should be run with the docker option `--cap-add=SYS_NICE`. | `0` |
|`INSTALL_PACKAGES`| Space-separated list of packages to install during the startup of the container.  List of available packages can be found at https://mirrors.alpinelinux.org.  **ATTENTION**: Container functionality can be affected when installing a package that overrides existing container files (e.g. binaries). | (no value) |
|`PACKAGES_MIRROR`| Mirror of the repository to use when installing packages. List of mirrors is available at https://mirrors.alpinelinux.org. | (no value) |
|`CONTAINER_DEBUG`| Set to `1` to enable debug logging. | `0` |
|`DISPLAY_WIDTH`| Width (in pixels) of the application's window. | `1920` |
|`DISPLAY_HEIGHT`| Height (in pixels) of the application's window. | `1080` |
|`DARK_MODE`| When set to `1`, dark mode is enabled for the application. | `0` |
|`WEB_AUDIO`| When set to `1`, audio support is enabled, meaning that any audio produced by the application is played through the browser. Note that audio is not supported for VNC clients. | `0` |
|`WEB_AUTHENTICATION`| When set to `1`, the application' GUI is protected via a login page when accessed via a web browser.  Access is allowed only when providing valid credentials.  **NOTE**: This feature requires secure connection (`SECURE_CONNECTION` environment variable) to be enabled. | `0` |
|`WEB_AUTHENTICATION_USERNAME`| Optional username to configure for the web authentication.  This is a quick and easy way to configure credentials for a single user.  To configure credentials in a more secure way, or to add more users, see the [Web Authentication](#web-authentication) section. | (no value) |
|`WEB_AUTHENTICATION_PASSWORD`| Optional password to configure for the web authentication.  This is a quick and easy way to configure credentials for a single user.  To configure credentials in a more secure way, or to add more users, see the [Web Authentication](#web-authentication) section. | (no value) |
|`SECURE_CONNECTION`| When set to `1`, an encrypted connection is used to access the application's GUI (either via a web browser or VNC client).  See the [Security](#security) section for more details. | `0` |
|`SECURE_CONNECTION_VNC_METHOD`| Method used to perform the secure VNC connection.  Possible values are `SSL` or `TLS`.  See the [Security](#security) section for more details. | `SSL` |
|`SECURE_CONNECTION_CERTS_CHECK_INTERVAL`| Interval, in seconds, at which the system verifies if web or VNC certificates have changed.  When a change is detected, the affected services are automatically restarted.  A value of `0` disables the check. | `60` |
|`WEB_LISTENING_PORT`| Port used by the web server to serve the UI of the application.  This port is used internally by the container and it is usually not required to be changed.  By default, a container is created with the default bridge network, meaning that, to be accessible, each internal container port must be mapped to an external port (using the `-p` or `--publish` argument).  However, if the container is created with another network type, changing the port used by the container might be useful to prevent conflict with other services/containers.  **NOTE**: a value of `-1` disables listening, meaning that the application's UI won't be accessible over HTTP/HTTPs. | `5800` |
|`VNC_LISTENING_PORT`| Port used by the VNC server to serve the UI of the application.  This port is used internally by the container and it is usually not required to be changed.  By default, a container is created with the default bridge network, meaning that, to be accessible, each internal container port must be mapped to an external port (using the `-p` or `--publish` argument).  However, if the container is created with another network type, changing the port used by the container might be useful to prevent conflict with other services/containers.  **NOTE**: a value of `-1` disables listening, meaning that the application's UI won't be accessible over VNC. | `5900` |
|`VNC_PASSWORD`| Password needed to connect to the application's GUI.  See the [VNC Password](#vnc-password) section for more details. | (no value) |
|`ENABLE_CJK_FONT`| When set to `1`, open-source computer font `WenQuanYi Zen Hei` is installed.  This font contains a large range of Chinese/Japanese/Korean characters. | `0` |
|`FF_OPEN_URL`| The URL to open when Chrome starts. | (no value) |
|`FF_KIOSK`| Set to `1` to enable kiosk mode.  This mode launches Chrome in a very restricted and limited mode best suitable for public areas or customer-facing displays. | `0` |
|`FF_CUSTOM_ARGS`| Custom argument(s) to pass when launching Chrome. | `0` |

### Data Volumes

The following table describes data volumes used by the container. The mappings
are set via the `-v` parameter. Each mapping is specified with the following
format: `<HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]`.

| Container path  | Permissions | Description |
|-----------------|-------------|-------------|
|`/config`| rw | This is where the application stores its configuration, states, log and any files needing persistency. |

### Ports

Here is the list of ports used by the container.

When using the default bridge network, ports can be mapped to the host via the
`-p` parameter (one per port mapping). Each mapping is defined with the
following format: `<HOST_PORT>:<CONTAINER_PORT>`. The port number used inside
the container might not be changeable, but you are free to use any port on the
host side.

See the [Docker Container Networking](https://docs.docker.com/config/containers/container-networking)
documentation for more details.

| Port | Protocol | Mapping to host | Description |
|------|----------|-----------------|-------------|
| 5800 | TCP | Optional | Port to access the application's GUI via the web interface.  Mapping to the host is optional if access through the web interface is not wanted.  For a container not using the default bridge network, the port can be changed with the `WEB_LISTENING_PORT` environment variable. |
| 5900 | TCP | Optional | Port to access the application's GUI via the VNC protocol.  Mapping to the host is optional if access through the VNC protocol is not wanted.  For a container not using the default bridge network, the port can be changed with the `VNC_LISTENING_PORT` environment variable. |

### Changing Parameters of a Running Container

As can be seen, environment variables, volume and port mappings are all specified
while creating the container.

The following steps describe the method used to add, remove or update
parameter(s) of an existing container. The general idea is to destroy and
re-create the container:

  1. Stop the container (if it is running):
```shell
docker stop chrome
```

  2. Remove the container:
```shell
docker rm chrome
```

  3. Create/start the container using the `docker run` command, by adjusting
     parameters as needed.

> [!NOTE]
> Since all application's data is saved under the `/config` container folder,
> destroying and re-creating a container is not a problem: nothing is lost and
> the application comes back with the same state (as long as the mapping of the
> `/config` folder remains the same).

## Docker Compose File

Here is an example of a `docker-compose.yml` file that can be used with
[Docker Compose](https://docs.docker.com/compose/overview/).

Make sure to adjust according to your needs. Note that only mandatory network
ports are part of the example.

```yaml
version: '3'
services:
  chrome:
    image: wowmarcomei/docker-chrome
    ports:
      - "5800:5800"
    volumes:
      - "/docker/appdata/chrome:/config:rw"
```

## Accessing the GUI

Assuming that container's ports are mapped to the same host's ports, the
graphical interface of the application can be accessed via:

  * A web browser:

```text
http://<HOST IP ADDR>:5800
```

  * Any VNC client:

```text
<HOST IP ADDR>:5900
```

## Security

By default, access to the application's GUI is done over an unencrypted
connection (HTTP or VNC).

Secure connection can be enabled via the `SECURE_CONNECTION` environment
variable. See the [Environment Variables](#environment-variables) section for
more details on how to set an environment variable.

When enabled, application's GUI is performed over an HTTPs connection when
accessed with a browser. All HTTP accesses are automatically redirected to
HTTPs.

When using a VNC client, the VNC connection is performed over SSL. Note that
few VNC clients support this method. [SSVNC] is one of them.

[SSVNC]: http://www.karlrunge.com/x11vnc/ssvnc.html

### SSVNC

[SSVNC] is a VNC viewer that adds encryption security to VNC connections.

While the Linux version of [SSVNC] works well, the Windows version has some
issues. At the time of writing, the latest version `1.0.30` is not functional,
as a connection fails with the following error:
```text
ReadExact: Socket error while reading
```
However, for your convenience, an unofficial and working version is provided
here:

https://github.com/jlesage/docker-baseimage-gui/raw/master/tools/ssvnc_windows_only-1.0.30-r1.zip

The only difference with the official package is that the bundled version of
`stunnel` has been upgraded to version `5.49`, which fixes the connection
problems.

### Certificates

Here are the certificate files needed by the container. By default, when they
are missing, self-signed certificates are generated and used. All files have
PEM encoded, x509 certificates.

| Container Path                  | Purpose                    | Content |
|---------------------------------|----------------------------|---------|
|`/config/certs/vnc-server.pem`   |VNC connection encryption.  |VNC server's private key and certificate, bundled with any root and intermediate certificates.|
|`/config/certs/web-privkey.pem`  |HTTPs connection encryption.|Web server's private key.|
|`/config/certs/web-fullchain.pem`|HTTPs connection encryption.|Web server's certificate, bundled with any root and intermediate certificates.|

> [!TIP]
> To prevent any certificate validity warnings/errors from the browser or VNC
> client, make sure to supply your own valid certificates.

> [!NOTE]
> Certificate files are monitored and relevant daemons are automatically
> restarted when changes are detected.

### VNC Password

To restrict access to your application, a password can be specified. This can
be done via two methods:
  * By using the `VNC_PASSWORD` environment variable.
  * By creating a `.vncpass_clear` file at the root of the `/config` volume.
    This file should contain the password in clear-text.  During the container
    startup, content of the file is obfuscated and moved to `.vncpass`.

The level of security provided by the VNC password depends on two things:
  * The type of communication channel (encrypted/unencrypted).
  * How secure the access to the host is.

When using a VNC password, it is highly desirable to enable the secure
connection to prevent sending the password in clear over an unencrypted channel.

> [!CAUTION]
> Password is limited to 8 characters. This limitation comes from the Remote
> Framebuffer Protocol [RFC](https://tools.ietf.org/html/rfc6143) (see section
> [7.2.2](https://tools.ietf.org/html/rfc6143#section-7.2.2)). Any characters
> beyond the limit are ignored.

### Web Authentication

Access to the application's GUI via a web browser can be protected with a login
page. When web authentication is enabled, users have to provide valid
credentials, otherwise access is denied.

Web authentication can be enabled by setting the `WEB_AUTHENTICATION`
environment variable to `1`.

See the [Environment Variables](#environment-variables) section for more details
on how to set an environment variable.

> [!IMPORTANT]
> Secure connection must also be enabled to use web authentication.
> See the [Security](#security) section for more details.

#### Configuring Users Credentials

Two methods can be used to configure users credentials:

  1. Via container environment variables.
  2. Via password database.

Containers environment variables can be used to quickly and easily configure
a single user. Username and pasword are defined via the following environment
variables:
  - `WEB_AUTHENTICATION_USERNAME`
  - `WEB_AUTHENTICATION_PASSWORD`

See the [Environment Variables](#environment-variables) section for more details
on how to set an environment variable.

The second method is more secure and allows multiple users to be configured.
The usernames and password hashes are saved into a password database, located at
`/config/webauth-htpasswd` inside the container. This database file has the
same format as htpasswd files of the Apache HTTP server. Note that password
themselves are not saved into the database, but only their hash. The bcrypt
password hashing function is used to generate hashes.

Users are managed via the `webauth-user` tool included in the container:
  - To add a user password: `docker exec -ti <container name or id> webauth-user add <username>`.
  - To update a user password: `docker exec -ti <container name or id> webauth-user update <username>`.
  - To remove a user: `docker exec <container name or id> webauth-user del <username>`.
  - To list users: `docker exec <container name or id> webauth-user user`.
