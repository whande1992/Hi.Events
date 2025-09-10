@php use Carbon\Carbon; use HiEvents\Helper\Currency; use HiEvents\Helper\DateHelper; @endphp
@php /** @var \HiEvents\DomainObjects\OrderDomainObject $order */ @endphp
@php /** @var \HiEvents\DomainObjects\EventDomainObject $event */ @endphp
@php /** @var \HiEvents\DomainObjects\OrganizerDomainObject $organizer */ @endphp
@php /** @var \HiEvents\DomainObjects\EventSettingDomainObject $eventSettings */ @endphp
@php /** @var string $orderUrl */ @endphp

@php /** @see \HiEvents\Mail\Order\OrderSummary */ @endphp

<x-mail::message>
# {{ __('Seu pedido foi confirmado! ') }} 🎉

@if($order->isOrderAwaitingOfflinePayment() === false)

<p>
{{ __('Parabéns! Seu pedido para :eventTitle em :eventDate às :eventTime foi bem-sucedido. Encontre os detalhes do seu pedido abaixo.', ['eventTitle' => $event->getTitle(), 'eventDate' => (new Carbon(DateHelper::convertFromUTC($event->getStartDate(), $event->getTimezone())))->format('d/m/Y'), 'eventTime' => (new Carbon(DateHelper::convertFromUTC($event->getStartDate(), $event->getTimezone())))->format('H:i')]) }}
</p>

@else

<div>
<p>
{{ __('Seu pedido está aguardando pagamento. Os ingressos foram emitidos, mas não serão válidos até que o pagamento seja recebido.') }}
</p>

<div style="border-radius: 4px; background-color: #d7e8f8; color: #204e84; margin-bottom: 1.5rem; padding: 1rem;">
<h2>{{ __('Instruções de Pagamento') }}</h2>
{{ __('Siga as instruções abaixo para concluir seu pagamento.') }}
{!! $eventSettings->getOfflinePaymentInstructions() !!}
</div>
</div>

@endif

<p>

# {{ __('Detalhes do Evento') }}
**{{ __('Nome do Evento:') }}** {{ $event->getTitle() }}
    <br>
**{{ __('Data & Hora:') }}** {{ (new Carbon(DateHelper::convertFromUTC($event->getStartDate(), $event->getTimezone())))->format('d/m/Y') }} às {{ (new Carbon(DateHelper::convertFromUTC($event->getStartDate(), $event->getTimezone())))->format('H:i') }}

</p>

@if($eventSettings->getPostCheckoutMessage() && $order->isOrderCompleted())
<p>

# {{ __('Informações Adicionais') }}

{!! $eventSettings->getPostCheckoutMessage() !!}

</p>
@endif

# {{ __('Resumo do Pedido') }}
- **{{ __('Número do Pedido:') }}** {{ $order->getPublicId() }}
- **{{ __('Valor Total:') }}** {{ Currency::format($order->getTotalGross(), $event->getCurrency()) }}

<x-mail::button :url="$orderUrl">
    {{ __('Ver Resumo do Pedido & Ingressos') }}
</x-mail::button>

{{ __('Se você tiver alguma dúvida ou precisar de assistência, entre em contato pelo') }} <a href="mailto:{{ $organizer->getEmail() }}">{{ $organizer->getEmail() }}</a>.

{{ __('Atenciosamente,') }}<br>
{{ $organizer->getName() ?: config('app.name') }}
</x-mail::message>
