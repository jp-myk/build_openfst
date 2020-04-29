# build_openfst
- Enviroment
  - OS CentOS 7.7
  - g++ (GCC) 4.8.5 20150623 (Red Hat 4.8.5-39)

- OpenFST version(The latest version with C++11 support)
  - openfst-1.6.9
  - thrax-1.2.9
  - opengrm-ngram-1.3.4

## build
A install path is defined the variable 'INSTALL_PATH' in Makefile
```
$ make download
$ make INSTALL_PATH=${PWD}/local
```