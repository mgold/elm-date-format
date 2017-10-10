module Tests exposing (all)

{- A simple test an example of the library.
   Does not test every option, you can submit PRs for that.
-}

import Date
import Date.Format
import Expect
import String exposing (join, padLeft)
import Test exposing (..)
import Time
import Time.Format


-- test name, expected value, format string


all : Test
all =
    describe "Format tests" <|
        [ describe "Date Format tests" <|
            List.map (makeTest << formatDateTest) dateTestData
        , describe "Time Format tests" <|
            List.map (makeTest << formatTimeTest) timeTestData
        ]


type alias TestTriple =
    ( String, String, String )


dateTestData : List TestTriple
dateTestData =
    [ ( "numeric date", "12/08/2014", "%d/%m/%Y" )
    , ( "spelled out date", "Tuesday, August 12, 2014", "%A, %B %d, %Y" )
    , ( "time", expectedTime, "%I:%M:%S %p" )
    , ( "time no spaces", expectedTimeNoSpace, "%H%M%S" )
    , ( "literal %", expectedTimeWithLiteral, "%H%%%M" )
    , ( "padding modifiers", "08|8| 8|08", "%m|%-m|%_m|%0m" )
    ]


timeTestData : List TestTriple
timeTestData =
    [ ( "time no spaces", expectedTimeNoSpace, "%H%M%S" )
    , ( "literal %", expectedTimeWithLiteral, "%H%%%M" )
    , ( "time colons", expectedTimeColons, "%H:%M" )
    , ( "time full colons", expectedFullTimeColons, "%H:%M:%S" )
    ]


expectedTimeWithLiteral =
    join "%" [ sampleHour, sampleMinute ]


expectedTimeNoSpace =
    join "" [ sampleHour, sampleMinute, sampleMinute ]


expectedTimeColons =
    join ":" [ sampleHour, sampleMinute ]


expectedFullTimeColons =
    join ":" [ sampleHour, sampleMinute, sampleSecond ]


expectedTime =
    join ":" [ sampleHour, sampleMinute, sampleMinute ]
        ++ (case Date.hour sampleDate < 12 of
                True ->
                    " AM"

                False ->
                    " PM"
           )


sampleDate : Date.Date
sampleDate =
    "2014-08-12T04:53:53Z"
        |> Date.fromString
        |> Result.withDefault (Date.fromTime 1.407833631116e12)


sampleTime : Time.Time
sampleTime =
    Date.toTime sampleDate


pad : Int -> String
pad =
    toString >> padLeft 2 '0'


sampleHour : String
sampleHour =
    Date.hour sampleDate
        |> pad


sampleMinute : String
sampleMinute =
    Date.minute sampleDate
        |> pad


sampleSecond : String
sampleSecond =
    Date.second sampleDate
        |> pad


formatSampleDate : String -> String
formatSampleDate fstring =
    Date.Format.format fstring sampleDate


formatSampleTime : String -> String
formatSampleTime fstring =
    Time.Format.format fstring sampleTime


formatDateTest : TestTriple -> TestTriple
formatDateTest ( a, b, format ) =
    ( a, b, formatSampleDate format )


formatTimeTest : TestTriple -> TestTriple
formatTimeTest ( a, b, format ) =
    ( a, b, formatSampleTime format )


makeTest : TestTriple -> Test
makeTest ( described, expected, actual ) =
    test described <| \() -> Expect.equal actual expected
