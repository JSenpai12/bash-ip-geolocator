# IP Geolocation Lookup

A bash script that looks up geolocation information (country, city, region) for a given IP address, using the [ip-api.com](http://ip-api.com/) API and `jq` for JSON parsing.

## What it does

`geolocation.sh` (rename as needed) takes a single IP address as an argument, queries `ip-api.com` for its geolocation data, and prints out the **country**, **city**, and **region**.

Before running the actual lookup, it also checks that `jq` is installed, since the script depends on it to parse the API's JSON response.

## Requirements

- **Linux/Unix-based OS** (tested on Ubuntu)
- `bash`
- `curl`
- [`jq`](https://stedolan.github.io/jq/download/) — the script checks for this automatically and will tell you if it's missing

> **Note:** This script will not run natively on Windows. Windows users need WSL (Windows Subsystem for Linux) or Git Bash to run it.

## Usage

```bash
./geolocation.sh <ip_address>
```

### Examples

```bash
$ ./geolocation.sh 8.8.8.8
✅ jq is installed.
Country: United States
City: Ashburn
Region: Virginia

$ ./geolocation.sh 127.0.0.1
✅ jq is installed.
127.0.0.1 is not a valid address

$ ./geolocation.sh
✅ jq is installed.
The script is expected a single argument only, but got 0.

$ ./geolocation.sh 8.8.8.8 1.1.1.1
✅ jq is installed.
The script is expected a single argument only, but got 2.
```

If `jq` isn't installed:

```bash
$ ./geolocation.sh 8.8.8.8
❌ jq is not installed.
👉 You can download it here: https://stedolan.github.io/jq/download/
```

## How it works

1. **Dependency check** — uses `command -v jq` to confirm `jq` is available before doing anything else; exits with a download link if it's missing.
2. **Argument validation** — requires exactly one argument (the IP address); exits with an error message otherwise.
3. **Loopback guard** — rejects `127.0.0.1` specifically, since it isn't a meaningful address to geolocate.
4. **API request** — sends a request to `http://ip-api.com/json/<ip_address>` via `curl` and captures the raw JSON response.
5. **Status check** — parses the `status` field from the response with `jq`; if it isn't `"success"`, the script reports a failure and exits.
6. **Output** — extracts and prints `country`, `city`, and `regionName` from the JSON response.

## Exit codes

| Code | Meaning |
|------|---------|
| `0`  | Geolocation data retrieved and printed successfully |
| `1`  | `jq` missing, invalid argument count, loopback address given, or API lookup failed |

## Notes / possible improvements

- Currently uses plain HTTP (`http://ip-api.com`) — the free tier of ip-api.com doesn't support HTTPS, so this is expected, but worth knowing if you swap providers later.
- No IP format validation is performed beyond rejecting `127.0.0.1` — invalid or malformed input is left to the API to reject via the `status` check.