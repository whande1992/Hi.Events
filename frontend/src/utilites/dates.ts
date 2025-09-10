/**
 * All dates are stored in UTC in the database. The timezone for the account or event should be used to
 * display the date in the correct timezone.
 */

import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';
import advanced from 'dayjs/plugin/advancedFormat';
import locale from 'dayjs/plugin/localizedFormat';
import 'dayjs/locale/pt-br'; // Importar locale português brasileiro
import {isSsr} from "./helpers.ts";

dayjs.extend(utc);
dayjs.extend(relativeTime);
dayjs.extend(timezone);
dayjs.extend(advanced);
dayjs.extend(locale);

// Configurar locale padrão como português brasileiro
dayjs.locale('pt-br');

// Função para interceptar e converter qualquer formato 12h para 24h
const convertTo24HourFormat = (formatString: string): string => {
    return formatString
        .replace(/h:mma/gi, 'HH:mm')
        .replace(/h:mm\s*a/gi, 'HH:mm')
        .replace(/hh:mma/gi, 'HH:mm')
        .replace(/hh:mm\s*a/gi, 'HH:mm')
        .replace(/h\s*a/gi, 'HH:mm')
        .replace(/ha/gi, 'HH:mm')
        .replace(/LT/g, 'HH:mm')
        .replace(/LTS/g, 'HH:mm:ss')
        .replace(/LLL/g, 'D [de] MMMM [de] YYYY [às] HH:mm')
        .replace(/LLLL/g, 'dddd, D [de] MMMM [de] YYYY [às] HH:mm')
        .replace(/lll/g, 'D [de] MMM [de] YYYY [às] HH:mm')
        .replace(/llll/g, 'ddd, D [de] MMM [de] YYYY [às] HH:mm');
};

// Sobrescrever a formatação global do dayjs para sempre usar 24h
const originalFormat = dayjs.prototype.format;
dayjs.prototype.format = function(template?: string) {
    if (!template) return originalFormat.call(this);
    const converted24h = convertTo24HourFormat(template);
    return originalFormat.call(this, converted24h);
};

export const prettyDate = (date: string, tz: string): string => {
    // eslint-disable-next-line lingui/no-unlocalized-strings
    return dayjs.utc(date).tz(tz).locale('pt-br').format('D [de] MMM [de] YYYY [às] HH:mm');
};

export const formatDate = (date: string, format: string, tz: string): string => {
    // Interceptar formatos que usam 12h e convertê-los para 24h
    let format24h = format
        .replace(/h:mma/g, 'HH:mm')
        .replace(/h:mm a/g, 'HH:mm')
        .replace(/hh:mma/g, 'HH:mm')
        .replace(/hh:mm a/g, 'HH:mm')
        .replace(/LT/g, 'HH:mm')          // Formato de hora local
        .replace(/LLL/g, 'D [de] MMMM [de] YYYY [às] HH:mm')  // Formato longo com hora em pt-BR
        .replace(/LLLL/g, 'dddd, D [de] MMMM [de] YYYY [às] HH:mm'); // Formato completo em pt-BR

    return dayjs.utc(date).tz(tz).locale('pt-br').format(format24h);
};

/**
 * We don't explicitly convert to the event timezone here as we want to
 * display the 'ago' time in the user's timezone.
 *
 * @param date string
 */
export const relativeDate = (date: string): string => {
    const dateInUTC = dayjs.utc(date);

    return dayjs().locale('pt-br').to(dateInUTC);
};

export const utcToTz = (date: undefined | string | Date, tz: string): string | undefined => {
    if (!date) {
        return undefined;
    }
    // eslint-disable-next-line lingui/no-unlocalized-strings
    return dayjs.utc(date).tz(tz).locale('pt-br').format('YYYY-MM-DDTHH:mm');
};

/**
 * Converts a datetime to the user's browser timezone, with a fallback timezone for SSR.
 *
 * @param date string
 * @param fallbackTz string
 */
export const dateToBrowserTz = (date: string, fallbackTz: string): string => {
    const userTimezone = !isSsr()
        ? Intl.DateTimeFormat().resolvedOptions().timeZone
        : fallbackTz;

    return dayjs.utc(date).tz(userTimezone).locale('pt-br').format('D [de] MMM [de] YYYY [às] HH:mm z');
};

// Função adicional para formatação de eventos públicos em português brasileiro
export const formatEventDate = (date: string, tz: string): string => {
    // eslint-disable-next-line lingui/no-unlocalized-strings
    return dayjs.utc(date).tz(tz).locale('pt-br').format('dddd, D [de] MMMM · HH:mm');
};
