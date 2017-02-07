module Date.Format exposing (format, localFormat, formatISO8601)

{-| Format strings for dates.

@docs format, localFormat, formatISO8601
-}

import Date
import Regex
import String exposing (padLeft, right, toUpper)
import Maybe exposing (andThen, withDefault)
import List exposing (head, tail)
import Date.Local exposing (Local, international)


re : Regex.Regex
re =
    Regex.regex "%(%|Y|y|m|B|b|d|e|a|A|H|k|I|l|p|P|M|S)"


{-| Use a format string to format a date. See the
[README](https://github.com/mgold/elm-date-format/blob/master/README.md) for a
list of accepted formatters.
-}
format : String -> Date.Date -> String
format s d =
    localFormat international s d


{-| Use a localization record and a format string to format a date. See the
[README](https://github.com/mgold/elm-date-format/blob/master/README.md) for a
list of accepted formatters.
-}
localFormat : Local -> String -> Date.Date -> String
localFormat loc s d =
    Regex.replace Regex.All re (formatToken loc d) s


{-| Formats a UTC date acording to
[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601). This is commonly used to
send dates to a server. For example: `2016-01-06T09:22:00Z`.
-}
formatISO8601 : Date.Date -> String
formatISO8601 =
    format "%Y-%m-%dT%H:%M:%SZ"


formatToken : Local -> Date.Date -> Regex.Match -> String
formatToken loc d m =
    let
        symbol =
            case m.submatches of
                [ Just x ] ->
                    x

                _ ->
                    " "
    in
        case symbol of
            "%" ->
                "%"

            "Y" ->
                d |> Date.year |> toString

            "y" ->
                d |> Date.year |> toString |> right 2

            "m" ->
                d |> Date.month |> monthToInt |> toString |> padLeft 2 '0'

            "B" ->
                d |> Date.month |> monthToWord loc.date.months

            "b" ->
                d |> Date.month |> monthToWord loc.date.monthsAbbrev

            "d" ->
                d |> Date.day |> padWith '0'

            "e" ->
                d |> Date.day |> padWith ' '

            "a" ->
                d |> Date.dayOfWeek |> dayOfWeekToWord loc.date.wdaysAbbrev

            "A" ->
                d |> Date.dayOfWeek |> dayOfWeekToWord loc.date.wdays

            "H" ->
                d |> Date.hour |> padWith '0'

            "k" ->
                d |> Date.hour |> padWith ' '

            "I" ->
                d |> Date.hour |> mod12 |> zero2twelve |> padWith '0'

            "l" ->
                d |> Date.hour |> mod12 |> zero2twelve |> padWith ' '

            "p" ->
                if Date.hour d < 12 then
                    toUpper loc.time.am
                else
                    toUpper loc.time.pm

            "P" ->
                if Date.hour d < 12 then
                    loc.time.am
                else
                    loc.time.pm

            "M" ->
                d |> Date.minute |> padWith '0'

            "S" ->
                d |> Date.second |> padWith '0'

            _ ->
                ""


monthToInt m =
    case m of
        Date.Jan ->
            1

        Date.Feb ->
            2

        Date.Mar ->
            3

        Date.Apr ->
            4

        Date.May ->
            5

        Date.Jun ->
            6

        Date.Jul ->
            7

        Date.Aug ->
            8

        Date.Sep ->
            9

        Date.Oct ->
            10

        Date.Nov ->
            11

        Date.Dec ->
            12


monthToWord loc m =
    case m of
        Date.Jan ->
            loc.jan

        Date.Feb ->
            loc.feb

        Date.Mar ->
            loc.mar

        Date.Apr ->
            loc.apr

        Date.May ->
            loc.may

        Date.Jun ->
            loc.jun

        Date.Jul ->
            loc.jul

        Date.Aug ->
            loc.aug

        Date.Sep ->
            loc.sep

        Date.Oct ->
            loc.oct

        Date.Nov ->
            loc.nov

        Date.Dec ->
            loc.dec


dayOfWeekToWord loc dow =
    case dow of
        Date.Mon ->
            loc.mon

        Date.Tue ->
            loc.tue

        Date.Wed ->
            loc.wed

        Date.Thu ->
            loc.thu

        Date.Fri ->
            loc.fri

        Date.Sat ->
            loc.sat

        Date.Sun ->
            loc.sun


mod12 h =
    h % 12


zero2twelve n =
    if n == 0 then
        12
    else
        n


padWith : Char -> a -> String
padWith c =
    padLeft 2 c << toString
