# search-app

# ShiftCare Take Home Project
## Project: Simple Command Line JSON crawler app

### Installation
1. Clone the repository
```
git clone https://github.com/nicholodominguez/search-app.git
```

2. Run `bundle install` on the project's main folder and install dependecies.

### Usage:

```bash
./search_cli.rb [OPTIONS]
```

Options:
* `-f FILENAME`
  * This will use the json file supplied as data, otherwise it will resort to `clients.json`

> [!WARNING]
> You may need to run `chmod +x search_cli.rb` to grant execute permissions

### Testing
1. Run the spec for `Search`
```bash
rspec spec/search_spec.rb
```