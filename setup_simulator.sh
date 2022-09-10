SOURCE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ARTIFACTS=${SOURCE}/artifacts
OPAE_TAG=$1

docker build --build-arg OPAE_TAG=${OPAE_TAG} ${SOURCE} -f ${SOURCE}/ASE.dockerfile -t opae_ase:${OPAE_TAG}