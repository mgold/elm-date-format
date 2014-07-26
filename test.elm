{- A simple test an example of the library. Does not test every option, working
on that!
-}
import FormatString (formatDate)
import Date

now = Date.fromTime <~ every second

main = asText <~ lift (formatDate "%a, %d %B, %Y  %I:%M:%S %p") now
