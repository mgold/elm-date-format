module FormatString (formatDate) where
import Date
import Regex
import String (padLeft, show)

re : Regex.Regex
re = Regex.regex "(^|[^%])%(Y|m|B|d|e)"

formatDate : String -> Date.Date -> String
formatDate s d = Regex.replace Regex.All re (formatToken d) s

formatToken : Date.Date -> Regex.Match -> String
formatToken d m = let
    prefix = maybe " " id <| head m.submatches
    symbol : String
    symbol = maybe " " id <| (head . tail) m.submatches
        in prefix ++ case symbol of
            "Y" -> Date.year d |> show
            "m" -> Date.month d |> monthToIntString
            "B" -> Date.month d |> monthToFullName
            "d" -> Date.day d |> show |> padLeft 2 '0'
            "e" -> Date.day d |> show |> padLeft 2 ' '
            _ -> ""


monthToIntString m = case m of
    Date.Jan -> "01"
    Date.Feb -> "02"
    Date.Mar -> "03"
    Date.Apr -> "04"
    Date.May -> "05"
    Date.Jun -> "06"
    Date.Jul -> "07"
    Date.Aug -> "08"
    Date.Sep -> "09"
    Date.Oct -> "10"
    Date.Nov -> "11"
    Date.Dec -> "12"

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
