{- A simple test an example of the library. Does not test every option, working
on that!
-}

import FormatString (formatDate)
import Date

-- Date patterns taken from
-- http://msdn.microsoft.com/en-us/library/az4se3k1%28v=vs.110%29.aspx

shortDate = "%d/%m/%Y"
longDate  = "%A, %B %d, %Y"

shortTime = "%I:%M %p"
longTime  = "%I:%M:%S %p"

shortDateTime = shortDate ++ " " ++ shortTime
longDateTime  = longDate  ++ " " ++ longTime

datePatterns = [ shortDate
               , longDate
               , shortTime
               , longTime
               , shortDateTime
               , longDateTime ]


sampleDate : Date.Date
sampleDate = Date.fromTime 1407833631116.0

shortDateExpected = "12/08/2014"
longDateExpected = "Tuesday, August 12, 2014"
shortTimeExpected = "10:53 AM"
longTimeExpected = "10:53:51 AM"
shortDateTimeExpected = "12/08/2014 10:53 AM"
longDateTimeExpected = "Tuesday, August 12, 2014 10:53:51 AM"

expectedDates = [ shortDateExpected
                , longDateExpected
                , shortTimeExpected
                , longTimeExpected
                , shortDateTimeExpected
                , longDateTimeExpected ]

formatDateReversed : String -> String
formatDateReversed = flip formatDate sampleDate

formattedDates : [String]
formattedDates = map formatDateReversed datePatterns

dates : [Element]
dates =  map asText <| map formatDateReversed datePatterns

verify : String -> String -> String
verify actual expected = case actual == expected of
                           True -> "OK: " ++ actual
                           _    -> "NOK actual:  [" ++  actual ++ "] expected [" ++  expected ++ "]"
                         
testResult : [String]
testResult = zipWith (verify) formattedDates expectedDates


main = flow down <| map asText <| zipWith (\x y -> x ++ " (" ++ y ++ ")") testResult datePatterns
