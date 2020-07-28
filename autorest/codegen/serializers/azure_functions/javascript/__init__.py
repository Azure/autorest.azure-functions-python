import logging
from pathlib import Path

from jinja2 import ChoiceLoader, Environment, PackageLoader

from autorest import AutorestAPI
from autorest.codegen import CodeModel
from autorest.codegen.serializers.azure_functions import \
    AzureFunctionsSerializer


_LOGGER = logging.getLogger(__name__)


class AzureFunctionsJavaScriptSerializer(AzureFunctionsSerializer):
    def __init__(self, autorest_api: AutorestAPI, code_model: CodeModel,
                 function_app_path: Path, async_mode: bool):
        super().__init__(autorest_api, code_model, function_app_path,
                         async_mode)
        self.azure_functions_templates_env: Environment = Environment(
            loader=ChoiceLoader([PackageLoader(
                "autorest.codegen.azure_functions_templates", "javascript"),
                PackageLoader(
                "autorest.codegen.azure_functions_templates.javascript",
                "templates")]), keep_trailing_newline=True,
            line_statement_prefix="##",
            line_comment_prefix="###", trim_blocks=True, lstrip_blocks=True)

    def serialize(self):
        _LOGGER.debug("Generating Functions")
        # self._serialize_and_write_functions(code_model=self.code_model,
        # env=self.azure_functions_templates_env,
        # function_app_path=self.function_app_path)

        _LOGGER.debug("Generating Function App contents")
        self._serialize_and_write_function_app_contents(
                env=self.azure_functions_templates_env,
                code_model=self.code_model,
                function_app_path=self.function_app_path)

        # Writes the model folder
        _LOGGER.debug("Generating python model folders")
        # if self.code_model.schemas or self.code_model.enums:
        # self._serialize_and_write_models_folder(code_model=self.code_model,
        # env=self.azure_functions_templates_env, function_app_path=self.function_app_path)
        

    def _serialize_and_write_function_app_contents(self, env, code_model,
                                                   function_app_path):
        pass