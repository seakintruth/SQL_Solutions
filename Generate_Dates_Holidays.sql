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
-- the past 50 years, and 20 year into the future takes roughly 2 seconds
-- reducing to a 14 year range resolves in .5 seconds.
-- and a 8 year range in .3 seconds
-- the past 300 years, and 100 year into the future takes roughly 11 seconds
-- find replace all of 365.2524*6 and 365.2524*2 with previous and future days to generate 
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
         from Dual union
         select 2, 15, 2, 1, To_date('11-02-1983', 'mm-dd-yyyy'), 'Birthday of Martin Luther King, Jr.'  
         from Dual union
         select 3, 15, 2, 2, To_date('01-01-1879', 'mm-dd-yyyy'), 'Washingtons Birthday'                  
         from Dual union
         select 4, 25, 2, 5, To_date('01-01-1971', 'mm-dd-yyyy'), 'Memorial Day'                         
         from Dual union
         select 5, 19, 0, 6, To_date('06-14-2021', 'mm-dd-yyyy'), 'Juneteenth National Independence Day'   
         from Dual union
         select 6, 4, 0, 7, To_date('06-28-1870', 'mm-dd-yyyy'), 'Independence Day'
         from Dual union
         select 7, 1, 2, 9, To_date('06-28-1894', 'mm-dd-yyyy'), 'Labor Day'
         from Dual union
         select 8, 8, 2, 10, To_date('06-28-1937', 'mm-dd-yyyy'), 'Columbus Day'
         from Dual union
         select 9, 11, 0, 11, To_date('06-28-1938', 'mm-dd-yyyy'), 'Veterans Day'
         from Dual union
         select 10, 22, 5, 11, To_date('06-28-1941', 'mm-dd-yyyy'), 'Thanksgiving Day'
         from Dual union
         select 11, 25, 0, 12, To_date('06-28-1870', 'mm-dd-yyyy'), 'Christmas Day'
         from Dual                                                                    --
    ),
    GENERATED_DATE
    as
        ( /*
          The point of this SQL is to show how to generate a value for every date in the result set,
          this is sometimes needed for counting days, or to simplify charting results, use the fields you need.
          */
         select                   -- start at 10 years in the past adjust '10' as needed
                Trunc(Sysdate - Trunc((365.2524*6))) + (Level)                                  as A_DATE
              -- one way of determining what days are weekdays
              , case To_number(To_char(Trunc(Sysdate - Trunc((365.2524*6))) + (Level), 'D'))
                    when 7 then 0
                    when 1 then 0
                    else 1
                end                                                                              as IS_WEEKDAY
         from Dual
         connect by Level <= Trunc((365.2524*6)+(365.2524*2)) -- enough days for (365.2524*6) days in the past and the next (365.2524*2) days in the future
    ),
    GEN_DATES_IS_HOLIDAYS as (
        select case
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
