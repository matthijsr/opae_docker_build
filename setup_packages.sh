SOURCE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ARTIFACTS=${SOURCE}/artifacts
OPAE_TAG=$1

mkdir -p ${ARTIFACTS}

OPAE_SDK_REPO=${ARTIFACTS}/opae-sdk

# Build the OPAE SDK RPM packages
git clone https://github.com/OPAE/opae-sdk.git ${SOURCE}/artifacts/opae-sdk
cd ${OPAE_SDK_REPO}
git checkout ${OPAE_TAG}
docker build ${SOURCE} -f ${SOURCE}/Build_RPMs.dockerfile -t opae_rpm:${OPAE_TAG}
docker run --rm -v ${OPAE_SDK_REPO}:/opae-sdk --build-arg OPAE_TAG=${OPAE_TAG} opae_rpm:${OPAE_TAG} /opae-sdk/rpm_packages /opae-sdk