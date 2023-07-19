# Define variables for image names and tags
NODE_IMAGE=ghcr.io/chainflip-io/chainflip-backend/chainflip-node
BROKER_API_IMAGE=ghcr.io/chainflip-io/chainflip-backend/chainflip-broker-api
LP_API_IMAGE=ghcr.io/chainflip-io/chainflip-backend/chainflip-lp-api
TAG=partnernet

# Pull the images
docker pull --platform=linux/amd64 $NODE_IMAGE:$TAG
docker pull --platform=linux/amd64 $BROKER_API_IMAGE:$TAG
docker pull --platform=linux/amd64 $LP_API_IMAGE:$TAG

# Tag the images with the new tag
docker tag $NODE_IMAGE:$TAG chainfliplabs/chainflip-node:$TAG
docker tag $BROKER_API_IMAGE:$TAG chainfliplabs/chainflip-broker-api:$TAG
docker tag $LP_API_IMAGE:$TAG chainfliplabs/chainflip-lp-api:$TAG

# Push the tagged images
docker push chainfliplabs/chainflip-node:$TAG
docker push chainfliplabs/chainflip-broker-api:$TAG
docker push chainfliplabs/chainflip-lp-api:$TAG