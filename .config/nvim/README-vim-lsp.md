# Neovim Setting

## Setting
### ubuntu 18.04

``` bash
$ sudo apt-get update &&
sudo apt-get install wget software-properties-common &&
sudo add-apt-repository ppa:ubuntu-toolchain-r/test &&
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add - &&
sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main" &&
sudo apt-get update
```

```bash
$ sudo apt install clangd-9 clang-format-9 
```

```bash
$ sudo update-alternatives --install /usr/bin/clangd clangd /usr/lib/llvm-9/bin/clangd 170 &&
$ sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/lib/llvm-9/bin/clang-format 170
```