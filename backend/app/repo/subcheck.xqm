module namespace subcheck = "subcheck";
declare namespace tt  = "http://www.w3.org/ns/ttml";
declare namespace ttp = "http://www.w3.org/ns/ttml#parameter";

declare function subcheck:subtitle-duration($p as element(tt:p)) as xs:double? {
  if(
    $p/@begin and
    subcheck:timecode-valid($p/@begin, root($p)/tt:tt) and
    $p/@end and subcheck:timecode-valid($p/@end, root($p)/tt:tt)
  ) then subcheck:tc2secs($p/@end, root($p)/tt:tt) - subcheck:tc2secs($p/@begin, root($p)/tt:tt)
  else if (
    $p/@dur and subcheck:timecode-valid($p/@dur, root($p)/tt:tt)
  ) then subcheck:tc2secs($p/@dur, root($p)/tt:tt)
  else ()
};

declare function subcheck:tc2secs($tc as xs:string, $tt as element(tt:tt)) as xs:double {
  let $tc-value          := $tc => normalize-space()
  let $clock_time_begin  := '^\d{2,}:\d\d:\d\d'
  let $offset_time_begin := '^\d+(\.\d+)?'
  let $offset_time_end   := '([hmsft]|ms)$'
  return
  if( matches($tc, $clock_time_begin) ) then (
    let $parts        := tokenize($tc, ':|\.')
    let $tc_remainder := replace($tc, $clock_time_begin, '')
    let $int_seconds  := number($parts[1]) * 3600 + number($parts[2]) * 60 + number($parts[3])
    return if ( $tc_remainder eq '') then $int_seconds
      else if (matches($tc_remainder, '^\.\d+$'))   then $int_seconds + number(concat('0.', $parts[4]))
      else if (matches($tc_remainder, '^:\d{2,}$')) then $int_seconds + number($parts[4]) div number($tt/@ttp:frameRate)
      else error(xs:QName('ERR001'),``[The value '`{$tc}`' is not a valid timecode.]``)
  ) else if( matches($tc, concat($offset_time_begin, $offset_time_end))) then (
    let $tc_value := replace($tc, $offset_time_end, '')
    let $tc_unit  := replace($tc, $offset_time_begin, '')
    return
           if($tc_unit eq 'h')  then number($tc_value) * 3600
      else if($tc_unit eq 'm')  then number($tc_value) * 60
      else if($tc_unit eq 's')  then number($tc_value)
      else if($tc_unit eq 'ms') then number($tc_value) * 0.001
      else if($tc_unit eq 'f')  then number($tc_value) div number($tt/@ttp:frameRate)
      else if($tc_unit eq 't')  then number($tc_value) div subcheck:tick-rate($tt)
      else error(xs:QName('ERR001'),``[The value '`{$tc}`' is not a valid timecode.]``)
  )else
    error(xs:QName('ERR001'),``[The value '`{$tc}`' is not a valid timecode.]``)

};


declare function subcheck:tick-rate($tt as element(tt:tt)) {
  (
    $tt/@ttp:tickRate/number(),
    $tt/@ttp:frameRate/number(),
    1
  ) => head()
};

(:~
:  *TODO*
:)
declare function subcheck:timecode-valid($tc as xs:string, $tt as element(tt:tt)) {
  true()
};

declare function subcheck:get-reading-speeds($tt as element(tt:tt)?) as xs:double* {
  for $p in $tt/tt:body//tt:p
  return subcheck:get-reading-speed($p)
};

declare function subcheck:get-reading-speed($p as element(tt:p)) as xs:double? {
  let $seconds := subcheck:subtitle-duration($p)
  return if($seconds) then
    let $chars := $p//text() =>string-join(" ") => tokenize("\s+") => filter(function($it){
      matches($it,"^.+$")
    }) => count()
    return ($chars div $seconds) * 60
    else ()
};
