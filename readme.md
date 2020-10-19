# HorsePower

## 1. Getting Started

The title of our paper submitted to EDBT21 is

**HorsePower: Accelerating Database Queries for Advanced Data Analytics**

This repository is created for showing the reproducibility of our experiments
in this paper.
There are mainly two systems: *HorsePower* and *RDBMS MonetDB*.
Instead of using step-by-step instructions to configure and deploy both systems
in the experiments, we deliver [a docker image][docker-online] to increase the
quality of reproducibility while reducing the time spent on software/system
configurations.
In this GitHub repository, we provide the details of scripts and original data
used in the experiments.

[docker-online]: https://hub.docker.com/r/wukefe/edbt21-analysis

On this page, you will see

- experiment setup (Section 2),
- the experiments on MonetDB (Section 3),
- the experiments on HorsePower (Section 4), and
- the results used in the paper (Section 5).


## 2. Experiments

All experiments were run on a server called `sable-intel` equipped with

- 4 Intel Xeon E7-4850 2.00GHz
- total 40 cores with 80 threads
- 24 MB of shared L3 CPU cache
- 128 GB RAM
- Ubuntu 18.04.4 LTS

Required software

- TPC-H: version v2.17.0
- GCC-8: version v8.1.0
- Python: v2.7.17 (NumPy v1.13.3)
- MonetDB: v11.35.9 (Nov2019-SP1)
- HorsePower

### Docker setup

Download the docker image (*It will be released no later than Oct 25, 2020*)

    docker pull wukefe/edbt21-analysis

Generate a named container (then exit)

    docker run --hostname sableintel -it --name=container-edbt21 wukefe/edbt21-analysis
    exit

Then, you can run the container

    docker start -ai container-edbt21

Open a new terminal to access the container (optional)

    docker exec -it container-edbt21 /bin/bash


### Introduction to MonetDB

Work directory for MonetDB

    /home/hanfeng/edbt21/monetdb

Start MonetDB (use all available threads)

    ./run.sh start

Login MonetDB using its client tool, `mclient`

    mclient -d tpch1
    ## ... MonetDB version v11.35.9 (Nov2019-SP1)

    sql> SELECT 'Hello world';
    +-------------+
    | L2          |
    +=============+
    | Hello world |
    +-------------+
    1 tuple

Show the list of tables in the current database

    sql> \d
    TABLE  sys.customer
    TABLE  sys.lineitem
    TABLE  sys.nation
    TABLE  sys.orders
    TABLE  sys.part
    TABLE  sys.partsupp
    TABLE  sys.region
    TABLE  sys.supplier

Leave the session

    sql> \q

Stop MonetDB before we can continue our experiments

    ./run.sh stop

Reference: [How to install MonetDB and the introduction of server and client
programs.](https://www.monetdb.org/Documentation/Guide/Installation)


## 3. Experiments on MonetDB

### Scripts and Execution - MonetDB

### Result retrieval - MonetDB


## 4. Experiments on HorsePower

The HorsePower project can be found with the following GitHub link:

    https://github.com/Sable/HorsePower

In the docker image, it has been placed in `/home/hanfeng/edbt21/horse`.


### Execution Time - HorsePower


### Compilation Time - HorsePower



## 5. Results

**Coming soon.**


