{- A simple test an example of the library. Does not test every option, working
on that!
-}

import Date
import FormatString (formatDate)
import ElmTest.Test (test, Test, suite)
import ElmTest.Assertion (assertEqual)
import ElmTest.Runner.Element (runDisplay)

type TestTriple = (String, String, String)

testData : [TestTriple]
testData = [ ("numeric date", "12/08/2014","%d/%m/%Y")
           , ("spelled out date", "Tuesday, August 12, 2014","%A, %B %d, %Y")
           , ("time", "10:53:51 AM","%I:%M:%S %p")
           ]

sampleDate : Date.Date
sampleDate = Date.fromTime 1407833631116.0

formatSampleDate : String -> String
formatSampleDate fstring = formatDate fstring sampleDate

formatTest : TestTriple -> TestTriple
formatTest (a, b, format) = (a, b, formatSampleDate format)

makeTest : (String, String, String) -> Test
makeTest (described, expected, actual) = test described <| assertEqual expected actual

tests : Test
tests = suite "Formatting" <| map (makeTest . formatTest) testData

main : Element
main = runDisplay tests
