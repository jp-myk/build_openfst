# build_openfst
- Enviroment
  - OS CentOS 7.7   
    g++ (GCC) 4.8.5 20150623 (Red Hat 4.8.5-39)
  - OS Ubuntu 8.04.3   
    g++ (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0
 
- OpenFST version
 ```
# OS CentOS 7.7   
OPENFST_VERSION=1.6.9
THRAX_VERSION=1.2.9
NGRAM_VERSION=1.3.4

# OS Ubuntu 8.04.3
OPENFST_VERSION=1.7.7
THRAX_VERSION=1.3.3
NGRAM_VERSION=1.3.10

```

## build
A install path is defined the variable 'INSTALL_PATH' in Makefile
```
$ make download
$ make INSTALL_PATH=${PWD}/local
```