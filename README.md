# brain.sh
A brain-replacement written for [zsh](https://www.zsh.org/).

## Usage
### Installation
```sh
git clone https://github.com/suxatcode/brain-sh
echo "source $PWD/brain-sh/all.sh" >> ~/.zshrc
```
Note: A customized installation will add only the functions of brain, and add
your own configuration to your .zshrc, e.g.
```sh
. "$BRAIN_INSTALL_DIR/grep.sh"
. "$BRAIN_INSTALL_DIR/brain.sh"
. "$BRAIN_INSTALL_DIR/todo.sh"
```

### Configuration
[conf.sh](./conf.sh) provides configuration that you most likely want to
change, it is merely provided as an example configuration.

## Development
### Testing
We use [shellspec](https://github.com/shellspec/shellspec).

```sh
make test
# or for development
# make test-watch
```
