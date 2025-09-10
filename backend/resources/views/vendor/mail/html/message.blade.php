<x-mail::layout>
    {{-- Header --}}
    <x-slot:header>
        <x-mail::header :url="config('app.email_logo_link_url')">
            @if($appLogo = config('app.email_logo_url'))
                <img src="{{ $appLogo }}" class="logo" alt="{{ config('app.name') }}"
                     style="max-width: 300px;">
            @else
                <img src="{{ config('app.frontend_url') }}/logo-dark.png" class="logo" alt="{{ config('app.name') }}"
                     style="max-width: 300px;">
            @endif
        </x-mail::header>
    </x-slot:header>

    {{-- Body --}}
    {{ $slot }}

    {{-- Subcopy --}}
    @isset($subcopy)
        <x-slot:subcopy>
            <x-mail::subcopy>
                {{ $subcopy }}
            </x-mail::subcopy>
        </x-slot:subcopy>
    @endisset

    {{-- Footer --}}
    <x-slot:footer>
        <x-mail::footer>
            @if($appEmailFooter = config('app.email_footer_text'))
                {{ $appEmailFooter }}
            @else
                {{-- (c) Meu Ingresso 2025 --}}
                {{-- --}}
                {{-- Meu Ingresso é licenciado sob a GNU Affero General Public License (AGPL) versão 3. --}}
                {{-- --}}
                {{-- Em conformidade com a Seção 7(b) da AGPL, pedimos que você mantenha o aviso "Powered by Meu Ingresso". --}}
                {{-- --}}
                {{-- Para mais informações, visite: https://github.com/HiEventsDev/Hi.Events/blob/main/LICENCE --}}
                © {{ date('Y') }} {{ config('app.name') }}
            @endif
        </x-mail::footer>
    </x-slot:footer>
</x-mail::layout>
