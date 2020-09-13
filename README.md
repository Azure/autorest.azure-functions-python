# OpenAPI Code Generator for Azure Functions (Python)
## (part of project-stencil)

### Autorest plugin configuration
- Please don't edit this section unless you're re-configuring how the azure-functions-python extension plugs in to AutoRest
AutoRest needs the below config to pick this up as a plug-in - see [AutoRest-extension.md](https://github.com/Azure/autorest/blob/master/docs/developer/architecture/AutoRest-extension.md) for more information.

#### Azure Functions Python code generation configuration

```yaml
pass-thru:
  - model-deduplicator
  - subset-reducer

use-extension:
  "@autorest/modelerfour": "4.15.414"

modelerfour:
  group-parameters: true
  flatten-models: true
  flatten-payloads: true
  resolve-schema-name-collisons: true
  always-create-content-type-parameter: true
  multiple-request-parameter-flattening: false
  naming:
    parameter: snakecase
    property: snakecase
    operation: snakecase
    operationGroup:  pascalcase
    choice:  pascalcase
    choiceValue:  snakecase
    constant:  snakecase
    constantParameter:  snakecase
    type:  pascalcase
    local: _ + snakecase
    global: snakecase
    preserve-uppercase-max-length: 6
    override:
      $host: $host
      base64: base64
      IncludeAPIs: include_apis

pipeline:
  python:
    # doesn't process anything, just makes it so that the 'python:' config section loads early, 
    # for the modelerfour plugin to get the input
    pass-thru: true
    input: openapi-document/multi-api/identity

  modelerfour:
    # in order that the modelerfour/flattener/grouper/etc picks up
    # configuration nested under python: in the user's config,
    # we have to make modeler four pull from the 'python' task.
    input: python

  python/m2r:
    input: modelerfour/identity

  python/namer:
    input: python/m2r

  python/codegen:
    input: python/namer
    output-artifact: python-files

  python/codegen/emitter:
    input: codegen
    scope: scope-codegen/emitter

scope-codegen/emitter:
    input-artifact: python-files
    output-uri-expr: $key

output-artifact: python-files
```

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
