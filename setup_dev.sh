SOURCE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ARTIFACTS=${SOURCE}/artifacts
OPAE_SDK=$1
OPAE_SIM=$2

docker build --build-arg OPAE_SDK=${OPAE_SDK} --build-arg OPAE_SIM=${OPAE_SIM} ${SOURCE} -f ${SOURCE}/Dev.dockerfile -t opae_dev:sdk_${OPAE_SDK}-sim_${OPAE_SIM}