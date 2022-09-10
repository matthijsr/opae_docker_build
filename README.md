# Basic OPAE dev environment
The purpose of this repository is to establish a minimal environment which builds and installs the OPAE SDK and simulator (ASE) from source into containers.
To be extended with any other requirements (e.g., Quartus) as needed.

# Usage
## Building the OPAE SDK/Libraries
The `setup_packages.sh $1` script creates a CentOS Stream 8 Docker container suitable for building OPAE's RPM packages, then uses it to build the `opae-sdk` RPM packages for the tag, commit, or branch supplied as the first argument.

The resulting packages are stored through a shared volume in `artifacts/opae-sdk/rpm_packages`, with an image/container `opae_rpm` tagged with the provided argument.

Example:
```
./setup_packages.sh 76db48ba3c702185a69663ffe831ee191672b003
```

Known issues: Some versions of `opae-sdk` have issues building RPM packages due to conflicting targets (fpgaperf_counter) with the legacy repository (`opae-libs`).

## Building the OPAE simulator (ASE)
After cloning the `opae-sdk` and building the packages, the `setup_simulator.sh $1` script can be used to build ASE, using the supplied argument to choose a specific tag, commit, or branch from `opae-sim`.

The resulting image will be tagged `opae_ase:$1`.

Example:
```
./setup_simulator.sh f8e7bd5e876a5b913fb53d6fc85653211eb7af3f
```

Note that it is possible to specify different versions between the OPAE SDK and simulator (in fact, this may be necessary, as their respective versions do not necessarily align), though correct behavior cannot be guaranteed.

Known issues: The vast majority of `opae-sim` versions do not build or install correctly with versions of OPAE newer than 2.0.1. The commits used in the examples are rare exceptions.