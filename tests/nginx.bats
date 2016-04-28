@test "provides access to nginx" {
  docker run -t "${DOCKER_IMAGE_NAME}${BUILD_TAG}" nginx -v
}

@test "passes config test" {
  docker run -t "${DOCKER_IMAGE_NAME}${BUILD_TAG}" nginx -t
}
