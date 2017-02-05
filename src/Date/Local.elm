module Date.Local exposing (..)

{-| Record to store localized time format.

Time zones and default formats are not implemented,
but included to avoid possible version conflicts in the future.
-}

type alias Local =
  { date :
    { months : Months
    , monthsAbbrev : Months
    , wdays : WDays
    , wdaysAbbrev : WDays
    , defaultFormat : Maybe String
    }
  , time :
    { am : String
    , pm : String
    , defaultFormat : Maybe String
    }
  , timeZones : Maybe TimeZones
  , defaultFormat : Maybe String
  }

type alias Months =
  { jan : String
  , feb : String
  , mar : String
  , apr : String
  , may : String
  , jun : String
  , jul : String
  , aug : String
  , sep : String
  , oct : String
  , nov : String
  , dec : String
  }

type alias WDays =
  { mon : String
  , tue : String
  , wed : String
  , thu : String
  , fri : String
  , sat : String
  , sun : String
  }

type alias TimeZones = Never

international : Local
international =
  { date =
    { months =
      { jan = "January"
      , feb = "February"
      , mar = "March"
      , apr = "April"
      , may = "May"
      , jun = "June"
      , jul = "July"
      , aug = "August"
      , sep = "September"
      , oct = "October"
      , nov = "November"
      , dec = "December"
      }
    , monthsAbbrev =
      { jan = "Jan"
      , feb = "Feb"
      , mar = "Mar"
      , apr = "Apr"
      , may = "May"
      , jun = "Jun"
      , jul = "Jul"
      , aug = "Aug"
      , sep = "Sep"
      , oct = "Oct"
      , nov = "Nov"
      , dec = "Dec"
      }
    , wdays =
      { mon = "Monday"
      , tue = "Tuesday"
      , wed = "Wednesday"
      , thu = "Thursday"
      , fri = "Friday"
      , sat = "Saturday"
      , sun = "Sunday"
      }
    , wdaysAbbrev =
      { mon = "Mon"
      , tue = "Tue"
      , wed = "Wed"
      , thu = "Thu"
      , fri = "Fri"
      , sat = "Sat"
      , sun = "Sun"
      }
    , defaultFormat = Nothing
    }
  , time =
    { am = "am"
    , pm = "pm"
    , defaultFormat = Nothing
    }
  , timeZones = Nothing
  , defaultFormat = Nothing
  }
