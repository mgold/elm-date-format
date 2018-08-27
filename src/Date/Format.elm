module Date.Format exposing (format, localFormat, formatISO8601)

{-| Format strings for dates.

@docs format, localFormat, formatISO8601

-}

import Date.Local exposing (Local, international)
import List exposing (head, tail)
import Maybe exposing (andThen, withDefault)
import Regex
import String exposing (padLeft, right, toUpper)
import Time


re : Maybe Regex.Regex
re =
    Regex.fromString "%(_|-|0)?(%|Y|y|m|B|b|d|e|a|A|H|k|I|l|L|p|P|M|S)"


type Padding
    = NoPadding
    | Space
    | Zero
    | ZeroThreeDigits


{-| Use a format string to format a date. See the
[README](https://github.com/mgold/elm-date-format/blob/master/README.md) for a
list of accepted formatters.
-}
format : String -> Time.Posix -> String
format s d =
    localFormat international s d


{-| Use a localization record and a format string to format a date. See the
[README](https://github.com/mgold/elm-date-format/blob/master/README.md) for a
list of accepted formatters.
-}
localFormat : Local -> String -> Time.Posix -> String
localFormat loc s d =
    case re of
        Just goodRe ->
            Regex.replace goodRe (formatToken loc d) s

        Nothing ->
            s


{-| Formats a UTC date acording to
[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601). This is commonly used to
send dates to a server. For example: `2016-01-06T09:22:00Z`.
-}
formatISO8601 : Time.Posix -> String
formatISO8601 =
    format "%Y-%m-%dT%H:%M:%SZ"


formatToken : Local -> Time.Posix -> Regex.Match -> String
formatToken loc d m =
    let
        ( padding, symbol ) =
            case m.submatches of
                [ Just "-", Just x ] ->
                    ( Just NoPadding, x )

                [ Just "_", Just x ] ->
                    ( Just Space, x )

                [ Just "0", Just x ] ->
                    ( Just Zero, x )

                [ Nothing, Just x ] ->
                    ( Nothing, x )

                _ ->
                    ( Nothing, " " )
    in
    case symbol of
        "%" ->
            "%"

        "Y" ->
            d |> Time.toYear Time.utc |> String.fromInt

        "y" ->
            d |> Time.toYear Time.utc |> String.fromInt |> right 2

        "m" ->
            d |> Time.toMonth Time.utc |> monthToInt |> String.fromInt |> padWith (withDefault Zero padding)

        "B" ->
            d |> Time.toMonth Time.utc |> monthToWord loc.date.months

        "b" ->
            d |> Time.toMonth Time.utc |> monthToWord loc.date.monthsAbbrev

        "d" ->
            d |> Time.toDay Time.utc |> String.fromInt |> padWith (withDefault Zero padding)

        "e" ->
            d |> Time.toDay Time.utc |> String.fromInt |> padWith (withDefault Space padding)

        "a" ->
            d |> Time.toWeekday Time.utc |> dayOfWeekToWord loc.date.wdaysAbbrev

        "A" ->
            d |> Time.toWeekday Time.utc |> dayOfWeekToWord loc.date.wdays

        "H" ->
            d |> Time.toHour Time.utc |> String.fromInt |> padWith (withDefault Zero padding)

        "k" ->
            d |> Time.toHour Time.utc |> String.fromInt |> padWith (withDefault Space padding)

        "I" ->
            d |> Time.toHour Time.utc |> mod12 |> zero2twelve |> String.fromInt |> padWith (withDefault Zero padding)

        "l" ->
            d |> Time.toHour Time.utc |> mod12 |> zero2twelve |> String.fromInt |> padWith (withDefault Space padding)

        "p" ->
            if Time.toHour Time.utc d < 12 then
                toUpper loc.time.am

            else
                toUpper loc.time.pm

        "P" ->
            if Time.toHour Time.utc d < 12 then
                loc.time.am

            else
                loc.time.pm

        "M" ->
            d |> Time.toMinute Time.utc |> String.fromInt |> padWith (withDefault Zero padding)

        "S" ->
            d |> Time.toSecond Time.utc |> String.fromInt |> padWith (withDefault Zero padding)

        "L" ->
            d |> Time.toMillis Time.utc |> String.fromInt |> padWith (withDefault ZeroThreeDigits padding)

        _ ->
            ""


monthToInt m =
    case m of
        Time.Jan ->
            1

        Time.Feb ->
            2

        Time.Mar ->
            3

        Time.Apr ->
            4

        Time.May ->
            5

        Time.Jun ->
            6

        Time.Jul ->
            7

        Time.Aug ->
            8

        Time.Sep ->
            9

        Time.Oct ->
            10

        Time.Nov ->
            11

        Time.Dec ->
            12


monthToWord loc m =
    case m of
        Time.Jan ->
            loc.jan

        Time.Feb ->
            loc.feb

        Time.Mar ->
            loc.mar

        Time.Apr ->
            loc.apr

        Time.May ->
            loc.may

        Time.Jun ->
            loc.jun

        Time.Jul ->
            loc.jul

        Time.Aug ->
            loc.aug

        Time.Sep ->
            loc.sep

        Time.Oct ->
            loc.oct

        Time.Nov ->
            loc.nov

        Time.Dec ->
            loc.dec


dayOfWeekToWord loc dow =
    case dow of
        Time.Mon ->
            loc.mon

        Time.Tue ->
            loc.tue

        Time.Wed ->
            loc.wed

        Time.Thu ->
            loc.thu

        Time.Fri ->
            loc.fri

        Time.Sat ->
            loc.sat

        Time.Sun ->
            loc.sun


mod12 h =
    modBy 12 h


zero2twelve n =
    if n == 0 then
        12

    else
        n


padWith : Padding -> String -> String
padWith padding =
    let
        padder =
            case padding of
                NoPadding ->
                    identity

                Zero ->
                    padLeft 2 '0'

                ZeroThreeDigits ->
                    padLeft 3 '0'

                Space ->
                    padLeft 2 ' '
    in
    padder
