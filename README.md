docker-sybase / Sybase ASE Docker Image
=============
[![Build Status](https://travis-ci.org/ktklin/docker-sybase.svg?branch=master)](https://travis-ci.org/ktklin/docker-sybase)

### Building  Sybase ASE on Docker.
Using this docker file you will be able to build a Docker Image incl. the Sybase ASE Express edition
This build uses Centos but most of the steps are generic.


### 1) Build the image
After you cloned the repository, run the following command in the newly created directory

```
docker build -t sybase .
```

#### 2) Run the sybase image
```
docker run -i -t -p 5000:5000 -v sybase bash
```
