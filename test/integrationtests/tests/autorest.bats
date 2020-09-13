#!/usr/bin/env bats

load test_helper

####
# Test setup related
####

TEST_CONTAINER=testautorestazfunction

setup_file(){
    build_docker_image
    docker container stop $(docker container list -q) 2>1 1>/dev/null 
    docker container rm $(docker container list -q -a) 2>1 1>/dev/null
}

function setup() {
  start_run_container $TEST_CONTAINER
    # docker container stop $(docker container list -q) 2>1  1>/dev/null
    # docker container rm $(docker container list -q -a) 2>1  1>/dev/null
}

function teardown() {
  rm_container $TEST_CONTAINER
}

teardown_file(){
  docker container stop $(docker container list -q) 2>1 1>/dev/null 
  docker container rm $(docker container list -q -a) 2>1 1>/dev/null
  docker system prune --force 2>1 1>/dev/null
} 

####
# Validating the setup is correct
####

@test "meta: docker is installed" {
    run docker version
    echo "$output">&2
    [ "$status" -eq 0 ]
}

@test "meta: can build the test container image" {
    run build_docker_image
    echo "$output"
    [ "$status" -eq 0 ]
}

# @test "meta: can start the test container" {
#     run in_tmp_container autorest
#     echo "$output"
#     [ "$output" ==! ^AutoRest* ]
#     [ "$status" -eq 2 ]
# }

@test "meta: can create a temporary file" {
    run save_tmp_file "foobar"
    echo "$output"
    [ "$status" -eq 0 ]
    [ -f "$output" ]
    [[ "$(cat "$output")" == "foobar" ]]
}

####
# Tests
####

@test "Test Contoso HR Swagger File to validate if it generated a correct Functions App" {
  run autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/service-description-jsons/contoso-hr-swagger.json"

  run ping_functions_endpoint "employee" "GET"
  echo "$output"
  [[ "$output" = *"Return stuff here."* ]]

}

@test "Test Covid Swagger File to validate if it generated a correct Functions App" {
  run autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/service-description-jsons/covid-apis.json"
  
  run ping_functions_endpoint "PortsOfEntry" "GET"
  echo "$output"
  [[ "$output" = *"Return stuff here."* ]]

  run ping_functions_endpoint "RepresentativeData" "GET"
  echo "$output"
  [[ "$output" = *"Return stuff here."* ]]
  
  run ping_functions_endpoint "ScreeningDataTable" "GET"
  echo "$output"
  [[ "$output" = *"Return stuff here."* ]]
}

@test "Test Petstore Swagger File to validate if it generated a correct Functions App" {
  run autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/service-description-jsons/petstore-swagger.json"
  run ping_functions_endpoint "pet/1" "GET"
  echo "$output"
  [[ "$output" = *"Return stuff here."* ]]

  run ping_functions_endpoint "store/order/1" "GET"
  echo "$output"
  [[ "$output" = *"Return stuff here."* ]]
  
  run ping_functions_endpoint "user/1" "GET"
  echo "$output"
  [[ "$output" = *"Return stuff here."* ]]
}

@test "Test Petstore OpenAPI 3.0 File to validate if it generated a correct Functions App" {
  run autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/service-description-jsons/petstore-3.0.0.json"
  run ping_functions_endpoint "pets" "GET"
  echo "$output"
  [[ "$output" = *"Return stuff here."* ]]
}

@test "Test Petstore  OpenAPI 3.0 YAML File to validate if it generated a correct Functions App" {
  run autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/service-description-jsons/petstore-3.0.0.yaml"
  run ping_functions_endpoint "pets" "GET"
  echo "$output"
  [[ "$output" = *"Return stuff here."* ]]
}

# @test "Test autorest.testserver case: additionalProperties.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/additionalProperties.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: azure-parameter-grouping.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/azure-parameter-grouping.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: azure-report.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/azure-report.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: azure-resource-x.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/azure-resource-x.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: azure-resource.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/azure-resource.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: azure-special-properties.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/azure-special-properties.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-array.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-array.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-boolean.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-boolean.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-boolean.quirks.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-boolean.quirks.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-byte.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-byte.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-complex.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-complex.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-date.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-date.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-datetime-rfc1123.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-datetime-rfc1123.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-datetime.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-datetime.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-dictionary.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-dictionary.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-duration.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-duration.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-file.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-file.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-formdata-urlencoded.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-formdata-urlencoded.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-formdata.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-formdata.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-integer.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-integer.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-number.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-number.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-number.quirks.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-number.quirks.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-string.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-string.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-string.quirks.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-string.quirks.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: body-time.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/body-time.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: complex-model.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/complex-model.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: constants.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/constants.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: custom-baseUrl-more-options.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/custom-baseUrl-more-options.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: custom-baseUrl-paging.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/custom-baseUrl-paging.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: custom-baseUrl.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/custom-baseUrl.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: examples" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/examples"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: extensible-enums-swagger.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/extensible-enums-swagger.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: head-exceptions.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/head-exceptions.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: head.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/head.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: header.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/header.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: httpInfrastructure.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/httpInfrastructure.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: httpInfrastructure.quirks.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/httpInfrastructure.quirks.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: lro.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/lro.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: media_types.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/media_types.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: model-flattening.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/model-flattening.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: multiapi-v1-custom-base-url.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/multiapi-v1-custom-base-url.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: multiapi-v1.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/multiapi-v1.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: multiapi-v2-custom-base-url.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/multiapi-v2-custom-base-url.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: multiapi-v2.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/multiapi-v2.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: multiapi-v3.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/multiapi-v3.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: multiple-inheritance.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/multiple-inheritance.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: non-string-enum.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/non-string-enum.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: object-type.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/object-type.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: paging.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/paging.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: parameter-flattening.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/parameter-flattening.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: report.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/report.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: required-optional.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/required-optional.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: storage.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/storage.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: subscriptionId-apiVersion.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/subscriptionId-apiVersion.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: url-multi-collectionFormat.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/url-multi-collectionFormat.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: url.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/url.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: validation.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/validation.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: xml-service.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/xml-service.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }

# @test "Test autorest.testserver case: xms-error-responses.json" {
#   run_autorest_in_container $TEST_CONTAINER "/home/autorest.azure-functions-python/test/data/swagger/xms-error-responses.json"
  
#   run ping_functions_endpoint "user/1" "GET"
#   echo "$output"
#   [[ "$output" = *"Return stuff here."* ]]
# }
