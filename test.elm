
import FormatString (formatDate)
import Date

now = Date.fromTime <~ every second

main = asText <~ lift (formatDate "%a, %d %B, %Y  %I:%M:%S %p") now
