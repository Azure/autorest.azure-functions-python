# coding=utf-8
# --------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is regenerated.
# --------------------------------------------------------------------------

from typing import Any, Optional

from azure.core import AsyncPipelineClient
from msrest import Deserializer, Serializer

from ._configuration_async import AutoRestRequiredOptionalTestServiceConfiguration
from .operations_async import ImplicitOperations
from .operations_async import ExplicitOperations
from .. import models


class AutoRestRequiredOptionalTestService(object):
    """Test Infrastructure for AutoRest.

    :ivar implicit: ImplicitOperations operations
    :vartype implicit: requiredoptional.aio.operations_async.ImplicitOperations
    :ivar explicit: ExplicitOperations operations
    :vartype explicit: requiredoptional.aio.operations_async.ExplicitOperations
    :param required_global_path: number of items to skip.
    :type required_global_path: str
    :param required_global_query: number of items to skip.
    :type required_global_query: str
    :param optional_global_query: number of items to skip.
    :type optional_global_query: int
    :param str base_url: Service URL
    :keyword int polling_interval: Default waiting time between two polls for LRO operations if no Retry-After header is present.
    """

    def __init__(
        self,
        required_global_path: str,
        required_global_query: str,
        optional_global_query: Optional[int] = None,
        base_url: Optional[str] = None,
        **kwargs: Any
    ) -> None:
        if not base_url:
            base_url = 'http://localhost:3000'
        self._config = AutoRestRequiredOptionalTestServiceConfiguration(required_global_path, required_global_query, optional_global_query, **kwargs)
        self._client = AsyncPipelineClient(base_url=base_url, config=self._config, **kwargs)

        client_models = {k: v for k, v in models.__dict__.items() if isinstance(v, type)}
        self._serialize = Serializer(client_models)
        self._deserialize = Deserializer(client_models)

        self.implicit = ImplicitOperations(
            self._client, self._config, self._serialize, self._deserialize)
        self.explicit = ExplicitOperations(
            self._client, self._config, self._serialize, self._deserialize)

    async def close(self) -> None:
        await self._client.close()

    async def __aenter__(self) -> "AutoRestRequiredOptionalTestService":
        await self._client.__aenter__()
        return self

    async def __aexit__(self, *exc_details) -> None:
        await self._client.__aexit__(*exc_details)