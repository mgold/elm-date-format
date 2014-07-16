import FormatString (formatDate)
import Date

aDate = 1405480764 * second |> Date.fromTime

main = asText <| formatDate "%d %B, %Y %%d" aDate
