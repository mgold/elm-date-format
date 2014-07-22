module FormatString (formatDate) where
import Date
import Regex
import String (padLeft, show)

re : Regex.Regex
re = Regex.regex "(^|[^%])%(Y|m|B|b|d|e|a|A|H|k|I|l|p|P|M|S)"

formatDate : String -> Date.Date -> String
formatDate s d = Regex.replace Regex.All re (formatToken d) s

formatToken : Date.Date -> Regex.Match -> String
formatToken d m = let
    prefix = maybe " " id <| head m.submatches
    symbol : String
    symbol = maybe " " id <| (head . tail) m.submatches
        in prefix ++ case symbol of
            "Y" -> d |> Date.year |> show
            "m" -> d |> Date.month |> monthToInt |> show |> padLeft 2 '0'
            "B" -> d |> Date.month |> monthToFullName
            "b" -> d |> Date.month |> show
            "d" -> d |> Date.day |> show |> padLeft 2 '0'
            "e" -> d |> Date.day |> show |> padLeft 2 ' '
            "a" -> d |> Date.dayOfWeek |> show
            "A" -> d |> Date.dayOfWeek |> fullDayOfWeek
            "H" -> d |> Date.hour |> show |> padLeft 2 '0'
            "k" -> d |> Date.hour |> show |> padLeft 2 ' '
            "I" -> d |> Date.hour |> mod12 |> show |> padLeft 2 '0'
            "l" -> d |> Date.hour |> mod12 |> show |> padLeft 2 ' '
            "p" -> if Date.hour d < 13 then "AM" else "PM"
            "P" -> if Date.hour d < 13 then "am" else "pm"
            "M" -> d |> Date.minute |> show |> padLeft 2 '0'
            "S" -> d |> Date.second |> show |> padLeft 2 '0'
            _ -> ""


monthToInt m = case m of
    Date.Jan -> 1
    Date.Feb -> 2
    Date.Mar -> 3
    Date.Apr -> 4
    Date.May -> 5
    Date.Jun -> 6
    Date.Jul -> 7
    Date.Aug -> 8
    Date.Sep -> 9
    Date.Oct -> 10
    Date.Nov -> 11
    Date.Dec -> 12

monthToFullName m = case m of
    Date.Jan -> "January"
    Date.Feb -> "February"
    Date.Mar -> "March"
    Date.Apr -> "April"
    Date.May -> "May"
    Date.Jun -> "June"
    Date.Jul -> "July"
    Date.Aug -> "August"
    Date.Sep -> "September"
    Date.Oct -> "October"
    Date.Nov -> "November"
    Date.Dec -> "December"

fullDayOfWeek dow = case dow of
    Date.Mon -> "Monday"
    Date.Tue -> "Tuesday"
    Date.Wed -> "Wednesday"
    Date.Thu -> "Thursday"
    Date.Fri -> "Friday"
    Date.Sat -> "Saturday"
    Date.Sun -> "Sunday"

mod12 h = h `mod` 12
