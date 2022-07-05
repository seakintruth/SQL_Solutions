/*
SQL, PL/SQL and comments Authored 2022 by Jeremy Dean Gerdes <jeremy.d.gerdes.civ@us.navy.mil>
Public Domain in the United States of America,
    any international rights are waived through the CC0 1.0 Universal public domain dedication <https://creativecommons.org/publicdomain/zero/1.0/legalcode>
    http://www.copyright.gov/title17/
    In accrordance with 17 U.S.C. § 105 This work is ' noncopyright' or in the ' public domain'
        Subject matter of copyright: United States Government works
        protection under this title is not available for
        any work of the United States Government, but the United States
        Government is not precluded from receiving and holding copyrights
        transferred to it by assignment, bequest, or otherwise.
    as defined by 17 U.S.C § 101
        ...
        A “work of the United States Government” is a work prepared by an
        officer or employee of the United States Government as part of that
        person’s official duties.
        ...
*/

-- This SQL generates results for all dates for 
-- the past 50 years, and 20 year into the future takes roughly 3 seconds
-- reducing to a 14 year range resolves in .7 seconds.
-- the past 300 years, and 100 year into the future takes roughly 18 seconds
-- find replace all of 365.2524*10 and 365.2524*4 with previous and future days to generate 
-- it also identifies workdays, holidays and holiday leave days based on the FEDERAL_HOLIDAY CTE immediatly following
-- see notes section of https://www.law.cornell.edu/uscode/text/5/6103
with
    FEDERAL_HOLIDAY
    as
        (select                               -- converted from excel table with formula
                -- ="from dual union select "&A2&" as START_DAY, "&B2&" AS END_DAY, "&C2&" AS DAY_OF_WEEK, "&D2&" AS HOLIDAY_MONTH, to_date('"&E2&"','mm-dd-yyyy') as DATE_JOINED, '"&F2&"' as OFFICIAL_NAME"
                1                                       as HOLIDAY_SA_ID
              , 1                                       as START_DAY
              , 0                                       as DAY_OF_WEEK
              , 1                                       as HOLIDAY_MONTH
              , To_date('06-28-1870', 'mm-dd-yyyy')     as DATE_JOINED
              , 'New Years Day'                         as OFFICIAL_NAME
         from Dual
         union
         select 2                                         as HOLIDAY_SA_ID
              , 15                                        as START_DAY
              , 2                                         as DAY_OF_WEEK
              , 1                                         as HOLIDAY_MONTH
              , To_date('11-02-1983', 'mm-dd-yyyy')       as DATE_JOINED
              , 'Birthday of Martin Luther King, Jr.'     as OFFICIAL_NAME
         from Dual
         union
         select 3                                       as HOLIDAY_SA_ID
              , 15                                      as START_DAY
              , 2                                       as DAY_OF_WEEK
              , 2                                       as HOLIDAY_MONTH
              , To_date('01-01-1879', 'mm-dd-yyyy')     as DATE_JOINED
              , 'Washingtons Birthday'                  as OFFICIAL_NAME
         from Dual
         union
         select 4                                       as HOLIDAY_SA_ID
              , 25                                      as START_DAY
              , 2                                       as DAY_OF_WEEK
              , 5                                       as HOLIDAY_MONTH
              , To_date('01-01-1971', 'mm-dd-yyyy')     as DATE_JOINED
              , 'Memorial Day'                          as OFFICIAL_NAME
         from Dual
         union
         select 5                                          as HOLIDAY_SA_ID
              , 19                                         as START_DAY
              , 0                                          as DAY_OF_WEEK
              , 6                                          as HOLIDAY_MONTH
              , To_date('06-14-2021', 'mm-dd-yyyy')        as DATE_JOINED
              , 'Juneteenth National Independence Day'     as OFFICIAL_NAME
         from Dual
         union
         select 6                                       as HOLIDAY_SA_ID
              , 4                                       as START_DAY
              , 0                                       as DAY_OF_WEEK
              , 7                                       as HOLIDAY_MONTH
              , To_date('06-28-1870', 'mm-dd-yyyy')     as DATE_JOINED
              , 'Independence Day'                      as OFFICIAL_NAME
         from Dual
         union
         select 7                                       as HOLIDAY_SA_ID
              , 1                                       as START_DAY
              , 2                                       as DAY_OF_WEEK
              , 9                                       as HOLIDAY_MONTH
              , To_date('06-28-1894', 'mm-dd-yyyy')     as DATE_JOINED
              , 'Labor Day'                             as OFFICIAL_NAME
         from Dual
         union
         select 8                                       as HOLIDAY_SA_ID
              , 8                                       as START_DAY
              , 2                                       as DAY_OF_WEEK
              , 10                                      as HOLIDAY_MONTH
              , To_date('06-28-1937', 'mm-dd-yyyy')     as DATE_JOINED
              , 'Columbus Day'                          as OFFICIAL_NAME
         from Dual
         union
         select 9                                       as HOLIDAY_SA_ID
              , 11                                      as START_DAY
              , 0                                       as DAY_OF_WEEK
              , 11                                      as HOLIDAY_MONTH
              , To_date('06-28-1938', 'mm-dd-yyyy')     as DATE_JOINED
              , 'Veterans Day'                          as OFFICIAL_NAME
         from Dual
         union
         select 10                                      as HOLIDAY_SA_ID
              , 22                                      as START_DAY
              , 5                                       as DAY_OF_WEEK
              , 11                                      as HOLIDAY_MONTH
              , To_date('06-28-1941', 'mm-dd-yyyy')     as DATE_JOINED
              , 'Thanksgiving Day'                      as OFFICIAL_NAME
         from Dual
         union
         select 11                                      as HOLIDAY_SA_ID
              , 25                                      as START_DAY
              , 0                                       as DAY_OF_WEEK
              , 12                                      as HOLIDAY_MONTH
              , To_date('06-28-1870', 'mm-dd-yyyy')     as DATE_JOINED
              , 'Christmas Day'                         as OFFICIAL_NAME
         from Dual                                                                    --
                  ),
    GENERATED_DATE
    as
        ( /*
          The point of this SQL is to show how to generate a value for every date in the result set,
          this is sometimes needed for counting days, or to simplify charting results, use the fields you need.
          */
         select                   -- start at 10 years in the past adjust '10' as needed
                Trunc(Sysdate - Trunc((365.2524*10))) + (Level)                                  as A_DATE
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'DAY')                  as DAY_FULL
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'Day')                  as DAY_FULL_CAPITAL_CASE
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'day')                  as DAY_FULL_LOWER_CASE
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'DY')                   as DAY_ABBREV
              -- one way of determining what days are weekdays
              , case To_number(To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'D'))
                    when 7 then 0
                    when 1 then 0
                    else 1
                end                                                                   as IS_WEEKDAY
              -- another way of determining what days are weekdays, by abbreviated days that contain a 'S' (in english) example of using REGEX
              , case
                    when Regexp_substr(
                             To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'DY')
                           , 'S'
                           , 1
                           , 1
                           , 'i'
                         ) = 'S'
                    then
                        0
                    else
                        1
                end                                                                   as IS_WEEKDAY_BY_REGEX
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'D')                    as DAY_OF_WEEK
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'DD')                   as DAY_OF_MONTH
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'DDD')                  as DAY_OF_YEAR
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'W')                    as WEEK_OF_MONTH
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'Month')                as MONTH_FULL
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'Mon')                  as MONTH_ABBREV
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'MM')                   as MONTH_NUMBER
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'Q')                    as QUARTER
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'YY')                   as YEAR_SHORT
              , To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'YYYY')                 as YEAR_FULL
              -- Fiscal quarter and year of Date
              , Mod(To_char(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 'Q') + 4, 4) + 1    as FISCAL_QUARTER
              , To_char(Add_months(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 3), 'YY')    as FISCAL_YEAR
              , To_char(
                    Extract(
                        year from Add_months(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 3)
                    )
                )                                                                     as FISCAL_YEAR_FULL
              , Trunc(Sysdate - Trunc((365.2524*10))) + (Level) + 7                              as TOMORROW
              , Trunc(Sysdate - Trunc((365.2524*10))) + (Level) + 7                              as ONE_WEEK_LATER
              , Add_months(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 1)                   as ONE_MONTH_LATER
              , Add_months(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 3)                   as THREE_MONTHS_LATER -- a quarter
              , Add_months(Trunc(Sysdate - Trunc((365.2524*10))) + (Level), 12)                  as ONE_YEAR_LATER
         from Dual
         connect by Level <= Trunc((365.2524*10)+(365.2524*4)) -- enough days for (365.2524*10) days in the past and the next (365.2524*4) days in the future
                                       ),
    GEN_DATES_IS_HOLIDAYS
    as
        (select case
                    when To_number(To_char(A_DATE, 'MM')) in
                             (select HOLIDAY_MONTH from FEDERAL_HOLIDAY)
                    then
                        case
                            when To_number(To_char(A_DATE, 'DD')) in
                                     -- fixed date holidays
                                     (select START_DAY
                                      from FEDERAL_HOLIDAY
                                      where HOLIDAY_MONTH =
                                            To_number(To_char(A_DATE, 'MM'))
                                            and DAY_OF_WEEK = 0
                                            and A_DATE > DATE_JOINED)
                                 or To_number(To_char(A_DATE, 'DD')) in
                                        -- floating days by DAY_OF_WEEK is allways 7 days
                                        (           --98,98 -- testing return no extra..
                                         select START_DAY
                                         from FEDERAL_HOLIDAY
                                         where To_number(To_char(A_DATE, 'MM')) =
                                               HOLIDAY_MONTH
                                               and To_char(A_DATE, 'D') = DAY_OF_WEEK
                                               and A_DATE > DATE_JOINED
                                         union all
                                         select START_DAY + 1
                                         from FEDERAL_HOLIDAY
                                         where To_number(To_char(A_DATE, 'MM')) =
                                               HOLIDAY_MONTH
                                               and To_char(A_DATE, 'D') = DAY_OF_WEEK
                                               and A_DATE > DATE_JOINED
                                         union all
                                         select START_DAY + 2
                                         from FEDERAL_HOLIDAY
                                         where To_number(To_char(A_DATE, 'MM')) =
                                               HOLIDAY_MONTH
                                               and To_char(A_DATE, 'D') = DAY_OF_WEEK
                                               and A_DATE > DATE_JOINED
                                         union all
                                         select START_DAY + 3
                                         from FEDERAL_HOLIDAY
                                         where To_number(To_char(A_DATE, 'MM')) =
                                               HOLIDAY_MONTH
                                               and To_char(A_DATE, 'D') = DAY_OF_WEEK
                                               and A_DATE > DATE_JOINED
                                         union all
                                         select START_DAY + 4
                                         from FEDERAL_HOLIDAY
                                         where To_number(To_char(A_DATE, 'MM')) =
                                               HOLIDAY_MONTH
                                               and To_char(A_DATE, 'D') = DAY_OF_WEEK
                                               and A_DATE > DATE_JOINED
                                         union all
                                         select START_DAY + 5
                                         from FEDERAL_HOLIDAY
                                         where To_number(To_char(A_DATE, 'MM')) =
                                               HOLIDAY_MONTH
                                               and To_char(A_DATE, 'D') = DAY_OF_WEEK
                                               and A_DATE > DATE_JOINED
                                         union all
                                         select START_DAY + 6
                                         from FEDERAL_HOLIDAY
                                         where To_number(To_char(A_DATE, 'MM')) =
                                               HOLIDAY_MONTH
                                               and To_char(A_DATE, 'D') = DAY_OF_WEEK
                                               and A_DATE > DATE_JOINED 
                                       /* rather than 7 copies of the same thing would prefer to use something like this couldn't get it working...
                                            select
                                                START_DAY+(Level)-1 as holiday_day_range
                                            from FEDERAL_HOLIDAY
                                            where
                                                To_number(To_char(A_DATE, 'MM')) = HOLIDAY_MONTH
                                                and To_char(A_DATE, 'D') = DAY_OF_WEEK
                                            connect by Level <=  7
                                      */
                                        )
                            then
                                1
                            else
                                0
                        end
                    else
                        0
                end    as IS_HOLIDAY
              , A_DATE
         from GENERATED_DATE),
    HOLIDAY_DATES
    as
        (select *
         from GEN_DATES_IS_HOLIDAYS
         where IS_HOLIDAY = 1),
    HOLIDAY_LEAVE_DATES
    as
        (select A_DATE
              , case To_number(To_char(A_DATE, 'D'))
                    when 1 then A_DATE + 1
                    when 7 then A_DATE - 1
                    else A_DATE
                end    as HOLIDAY_LEAVE_DATE
              , IS_HOLIDAY
         from HOLIDAY_DATES),
    ALL_DATES
    as
        (select HOLIDAY_DATES.IS_HOLIDAY
              , HOLIDAY_LEAVE_DATES.IS_HOLIDAY     as IS_HOLIDAY_LEAVE
              , GENERATED_DATE.*
         from GENERATED_DATE
              left join HOLIDAY_DATES
                   on GENERATED_DATE.A_DATE = HOLIDAY_DATES.A_DATE
              left join HOLIDAY_LEAVE_DATES
                   on GENERATED_DATE.A_DATE = HOLIDAY_LEAVE_DATES.HOLIDAY_LEAVE_DATE
         order by GENERATED_DATE.A_DATE asc)

select 
    case 
        when ALL_DATES.IS_HOLIDAY_LEAVE = 1 then 0
        when ALL_DATES.IS_WEEKDAY = 0 then 0
        else 1
    end
        as IS_WORKDAY
    , ALL_DATES.*
from ALL_DATES
