<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Formatos de Data e Hora Brasileiros
    |--------------------------------------------------------------------------
    |
    | Configurações de formato de data e hora específicas para o Brasil.
    | Usa o padrão brasileiro: DD/MM/AAAA e horário 24h (HH:mm)
    |
    */

    'date_format' => 'd/m/Y',
    'time_format' => 'H:i',
    'datetime_format' => 'd/m/Y H:i',
    'datetime_with_seconds' => 'd/m/Y H:i:s',
    
    'long_date_format' => 'l, d \d\e F \d\e Y',
    'long_datetime_format' => 'l, d \d\e F \d\e Y \à\s H:i',
    
    'invoice_date_format' => 'd/m/Y',
    'invoice_datetime_format' => 'd/m/Y \à\s H:i',
    
    'email_date_format' => 'd \d\e F \d\e Y',
    'email_datetime_format' => 'd \d\e F \d\e Y \à\s H:i',
];
