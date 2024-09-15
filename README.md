# STV Management

STV Management is a sourcemod plugin for TF2 servers (and probably also other sourcemod servers) that provides functionality to kick players from STV and lock the STV server down to prevent further players from joining, even with the correct password.


- [Installation](#installation)
- [Usage](#usage)
- [Building](#building)
- [License](#license)
- [Contributing](#contributing)

## Installation

Copy the `stv-management.smx` file to your `addons/sourcemod/plugins` directory on your server. Then restart your server or load the plugin using `sm plugins load stv-management` in the server console.

## Usage

To kick a client, use `tv_spectators` to get a list of connected clients and their indexes, then use `tv_kick <userid> <reason>` to kick the client from the STV server.

To lock the STV server, use `sm_stv_lockdown 1` to lock the server. This will prevent any further clients from joining the STV server, even if they have the correct password. To unlock, use `sm_stv_lockdown 0`.

## Building

Build with any sourcemod version on the 1.11 branch. Requires [SourceTV Manager](https://github.com/peace-maker/sourcetvmanager) natives to build.

## Contributing

Feel free to open an issue or pull request if you have any suggestions or improvements.

## License

GNU General Public License v3.0. See the [LICENSE](LICENSE) file.
