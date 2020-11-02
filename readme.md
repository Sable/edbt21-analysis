# HorsePower

## 1. Getting Started

The title of our paper submitted to EDBT21 is

**HorsePower: Accelerating Database Queries for Advanced Data Analytics**

This repository is created for showing the reproducibility of our experiments
in this paper.
There are mainly two systems: *HorsePower* and *RDBMS MonetDB*.
We supply instructions to configure and deploy both systems in the experiments.

On this page, you will see

- experiment setup ([Section 2](#sec2)),
- Experiment: TPC-H SQL Benchmarks ([Section 3](#sec3)), 
- Experiment: MATLAB benchmarks ([Section 4](#sec4)),
- Experiment: SQL and UDF benchmarks with TPC-H ([Section 5](#sec5))
- Experiment: SQL and UDF benchmarks with MATLAB ([Section 6](#sec6))


## <a name="sec2"></a> 2. Experiment Setup

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
- MATLAB: R2019a
- MonetDB: v11.35.9 (Nov2019-SP1)
- HorsePower


### Configurations for MonetDB

We first install MonetDB from its source code with all optimizations enabled.
Then, we create a new database `tpch8` which means the scale factor 8 (SF8)
for the TPC-H benchmark.

Download and install

```shell
# Download MonetDB Nov2019-SP1
wget https://www.monetdb.org/downloads/sources/Nov2019-SP1/MonetDB-11.35.9.tar.bz2
tar -xf MonetDB-11.35.9.tar.bz2
cd MonetDB-11.35.9

# Configure with performance flags enabled
./configure --prefix=<DIR_EXP>/monetdb19 --enable-debug=no --enable-assert=no --enable-optimize=yes

make
make install

# Post installation
export PATH="<DIR_EXP>/monetdb19/bin":$PATH
```

Create a configuration file `~/.monetdb` with the following content:

```no-highlight
user=monetdb
password=monetdb
language=sql
```

Then, type `mclient` to login MonetDB.
Please check if you see the version number `Nov2019-SP1` on the top of the
welcome message.
Moreover, try the following command to see if the database has been installed
successfully.


```no-highlight
sql>SELECT 'Hello world';
+-------------+
| L2          |
+=============+
| Hello world |
+-------------+
1 tuple (1.328ms)
```

Create and start a datafarm

    monetdbd create /path/to/datafarm
    monetdbd start /path/to/datafarm

Create and start a database `tpch8` (use all available threads)

    monetdb create tpch8
    monetdb release tpch8
    monetdb start tpch8

Login MonetDB using its client tool `mclient`

    mclient -d tpch8
    ## ... MonetDB version v11.35.9 (Nov2019-SP1)

    sql> SELECT 'Hello world';
    +-------------+
    | L2          |
    +=============+
    | Hello world |
    +-------------+
    1 tuple

Leave the session

    sql> \q

Load the schema and data

    mclient -d tpch8 configure/monetdb/dss.ddl
    mclient -d tpch8 configure/monetdb/initTPCH8.txt

Login tpch8 and display the list of tables in the current database

    sql> \d
    TABLE  sys.customer
    TABLE  sys.lineitem
    TABLE  sys.nation
    TABLE  sys.orders
    TABLE  sys.part
    TABLE  sys.partsupp
    TABLE  sys.region
    TABLE  sys.supplier

Stop MonetDB

    monetdb stop tpch8

Reference

- [How to install MonetDB and the introduction of server and client programs.](https://www.monetdb.org/Documentation/Guide/Installation)


### Configurations for HorsePower

The HorsePower project can be found with the following GitHub link:

    https://github.com/Sable/HorsePower

Step 1: Download HorsePower

    git clone https://github.com/Sable/HorsePower

Step 2: Set up environment

    cd HorsePower && source ./setup_env.sh

Step 3: Deploy library and data

    ./deploy.sh


### Configurations for MATLAB

We use an alias `matlab19` pointing to the MATLAB version `R2019a` in our scripts.

    alias matlab19="/path/to/matlab/R2019a/bin/matlab -nodesktop"

Note that MATLAB is a proprietary software owned by the company MathWorks.
You can download it from its [official website](https://www.mathworks.com/products/matlab.html).


### Configurations for NumPy

Install numpy

    pip install numpy

Check NumPy version

    >> python -c "import numpy; print(numpy.version.version)"
    1.13.3

If the version is not v1.13.3, you can install the specific version.

    pip install -Iv numpy==1.13.3 --force-reinstall


## <a name="sec3"></a> 3. Experiment: TPC-H SQL Benchmarks

Two variations

- MonetDB
- HorsePower

### MonetDB

Directory

    experiment/tpch/monetdb

Step 1: Run the server

    mserver5 --dbpath=/path/to/datafarm --set monet_vault_key=/path/to/datafarm/.vaultkey --set gdk_nr_threads=1

Step 2: Run the client in a new terminal

    (time ./runtest | mclient -d tpch8)  &> "log/sf8/log_thread_1.log"

Step 3: Fetch results (average execution time - ms)

    grep -A 3 avg_query log/sf8/log_thread_1.log | python cut.py

Step 4: Repeat for threads 2/4/8/16/32/64

    ## Repeat step 1/2/3 for different number of threads

Experiment results

    experiment/tpch/monetdb/paper-log.tar.gz


### HorsePower

Directory

    experiment/tpch/hir

Compilation time

    ./run.sh compile optn &> log/compile-optn-paper.txt

Then, fetch compilation time (ms)

    cat log/compile-optn-paper.txt | grep "TOTAL" | awk -F " " '{print $5}' | python report-all.py

Run all queries (about 149 minutes)

    time ./run_all.sh

Generate time for copy

    ./run.sh fetch log | python gen_for_copy.py

Experiment results

    paper/paper-log.tar.gz        # Execution time
    paper/compile-optn-paper.txt  # Compilation time


## <a name="sec4"></a> 4. Experiment: MATLAB Benchmarks

Two variations

- MATLAB
- HorsePower


### MATLAB

Directory

    experiment/bs/matlab

Execute the script

    time ./run.sh

Large input data files (about 1.15 GB)

    >> ls data/
    in_1M.txt  in_2M.txt  in_4M.txt  in_8M.txt

Note: We consider putting these large data files to a public site other than
GitHub due to the constraint of file sizes.

Experiment results

    paper/log_matlab-paper.txt

Fetch execution time

    cat paper/log_matlab-paper.txt  | grep -i "The average elapsed time"


## <a name="sec5"></a> 5. Experiment: SQL and UDF benchmarks with TPC-H

Two variations

- MonetDB
- HorsePower

Directory (MonetDB)

    experiment/tpch-froid/monetdb

Directory (HorsePower)

    experiment/tpch-froid/hir


## <a name="sec6"></a> 6. Experiment: SQL and UDF benchmarks with MATLAB

Two variations

- MonetDB
- HorsePower

Directory (MonetDB)

    experiment/bs-query/monetdb

Directory (HorsePower)

    experiment/bs-query/hir


