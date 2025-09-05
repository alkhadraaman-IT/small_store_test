<?php

return [
    'paths' => ['api/*', 'storage/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],   // أو حط http://localhost:xxxx تبع Flutter
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'supports_credentials' => false,
];

