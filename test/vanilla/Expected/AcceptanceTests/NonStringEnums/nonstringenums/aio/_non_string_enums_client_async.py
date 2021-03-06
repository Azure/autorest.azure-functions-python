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

from ._configuration_async import NonStringEnumsClientConfiguration
from .operations_async import IntOperations
from .operations_async import FloatOperations


class NonStringEnumsClient(object):
    """Testing non-string enums.

    :ivar int: IntOperations operations
    :vartype int: nonstringenums.aio.operations_async.IntOperations
    :ivar float: FloatOperations operations
    :vartype float: nonstringenums.aio.operations_async.FloatOperations
    :param str base_url: Service URL
    :keyword int polling_interval: Default waiting time between two polls for LRO operations if no Retry-After header is present.
    """

    def __init__(
        self,
        base_url: Optional[str] = None,
        **kwargs: Any
    ) -> None:
        if not base_url:
            base_url = 'http://localhost:3000'
        self._config = NonStringEnumsClientConfiguration(**kwargs)
        self._client = AsyncPipelineClient(base_url=base_url, config=self._config, **kwargs)

        client_models = {}
        self._serialize = Serializer(client_models)
        self._deserialize = Deserializer(client_models)

        self.int = IntOperations(
            self._client, self._config, self._serialize, self._deserialize)
        self.float = FloatOperations(
            self._client, self._config, self._serialize, self._deserialize)

    async def close(self) -> None:
        await self._client.close()

    async def __aenter__(self) -> "NonStringEnumsClient":
        await self._client.__aenter__()
        return self

    async def __aexit__(self, *exc_details) -> None:
        await self._client.__aexit__(*exc_details)
