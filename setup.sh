SOURCE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ARTIFACTS=${SOURCE}/artifacts

mkdir -p ${ARTIFACTS}

OPAE_SDK_REPO=${ARTIFACTS}/opae-sdk

git clone -b 2.0.9-4 --single-branch https://github.com/OPAE/opae-sdk.git ${SOURCE}/artifacts/opae-sdk
docker build ${SOURCE} -f ${SOURCE}/Build_RPMs.dockerfile -t opae_rpm:2.0.9-4
docker run --rm -v ${OPAE_SDK_REPO}:/opae-sdk opae_rpm:2.0.9-4 /opae-sdk/rpm_packages /opae-sdk