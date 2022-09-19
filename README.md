# brain.sh
A brain-replacement written for [zsh](https://www.zsh.org/).

## Usage
### Installation
```sh
git clone https://github.com/suxatcode/brain-sh
echo "source $PWD/brain-sh/all.sh" >> ~/.zshrc
```
### Configuration
See [conf.sh](./conf.sh).

## Development
### Testing
We use [shellspec](https://github.com/shellspec/shellspec).

```sh
make test
# or for development
# make test-watch
```
