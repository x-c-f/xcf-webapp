(:~
 : This module contains some basic examples for RESTXQ annotations
 : @author BaseX Team
 :)
module namespace page = 'http://basex.org/modules/web-page';

import module namespace subcheck = "subcheck"  at "../repo/subcheck.xqm";


declare variable $page:xslt-cache := map { 'cache': true() };

declare variable $page:CONFIG := let $doc := fetch:xml('config.xml')
return $doc update (
  insert node attribute constraint { $doc/config/xcf-rules || "constraints.xml" } as first into config,
  replace node config/xcf-engine with element xcf-engine {fetch:xml(config/xcf-engine || "reportview.xsl")},
  insert node element xcf-constraints { fetch:xml(config/xcf-rules|| "constraints.xml") } as last into config,
  insert node element xcf-rules       {
    fetch:xml(config/xcf-rules || "rules_compiled.xslt") update {
   for $href in .//Q{http://www.w3.org/1999/XSL/Transform}include[@href]
   return replace value of node $href/@href with (
     $doc/config/xcf-rules || $href/@href
   )
  }
  } as last into config
);


declare function page:decorate-report($report as element(result), $doc-path as xs:string) as element(json){
  let $foo := $report//@type/../name()
  return
  element json {
    attribute type {"object"},
    element report {
      attribute type {"array"},
      for $ec in $report//errorCategory
      return element _ {
        attribute type {"object"},
        element uuid { random:uuid() },
        $ec update {
           insert node attribute type {"object"} into .,
           delete node errors,
           insert node element errors {
             attribute type {"array"},
             for $error in errors/error
             return element _ {
               attribute type {"object"},
                 $error/*
             }
           } into .
         }
       }
       update {
          for $messages in .//messages return insert node attribute type {"object"} into $messages
        }
       update {
         for $specs in .//specs return insert node attribute type {"array"} into $specs,
         for $spec in .//spec return (
           rename node $spec as "_",
           insert node attribute type {"object"} into $spec
         )
       }
       update {
         for $tags in .//tags return insert node attribute type {"array"} into $tags,
         for $tag in .//tag return (
           rename node $tag as "_",
           delete node $tag//@type,
           insert node attribute type {"object"} into $tag,
           insert node element type { $tag//@type/string() } as last into $tag
         )
       }
       update {
         for $locations in .//locations return insert node attribute type {"object"} into $locations,
         for $locations in .//locations return insert node element preview {
           let $path := $locations/location[@locationType="humanXPATH"]
            => replace("/(@)?([^/@:])+:",'/$1*:') (: replace namespaces with '*' :)
            => tokenize("/")
            => for-each(function($it){
              if(matches($it, ":") or matches($it, "@") or $it = "") then $it
              else concat("*:", $it)
            })
            => string-join("/")
            => replace('/\*:span(\[[0-9]+\])?$','') (: Srip last step if it is a span step :)
           return try {
             (xquery:eval(``[fetch:xml('`{$doc-path}`', map{'stripns':false(), "intparse": true()})`{$path}`]``))/ancestor-or-self::element()[1]
              => serialize()
              => replace(
                ``[\sxmlns(:[^:=]+=|=)['"][^'"]+['"]]``,
                "" (: drop ns :)
              )
              => (function($str as xs:string) as xs:string{
                if(string-length($str)>300) then
                  concat(substring($str, 1,300),"[…]")
                else $str
                })()
           } catch err:foo {
             $err:description
           }
         } into $locations,
        for $location in .//location[@locationType]
        return (
          rename node $location as $location/@locationType/string(),
          delete node $location/@*
        )
       }
     }
    }
  };

(:
 : Validate a document.
:)
declare function page:val($output as xs:string, $filename as xs:string){
  try {
    let $config := $page:CONFIG
    let $output_doc := doc($output)
    let $report :=  xslt:transform(
      $output_doc,
      $page:CONFIG/config/xcf-rules/child::*
    )

    let $xml_report := xslt:transform(
       $report,
       $page:CONFIG/config/xcf-engine/*,
       map {
         "constraints_path" : $page:CONFIG/config/@constraint
       },
       $page:xslt-cache
     )
   let $report := page:decorate-report($xml_report/result, $output)
   let $wpm := try {
     subcheck:get-reading-speeds( $output_doc/*:tt ) => avg()
     } catch * {
       -1
      }
   return $report update {
     insert node element filename { $filename } into .,
     insert node element totalWords {
       $output_doc//*:p
              => for-each(tokenize(?,"\s+"))
              => filter(function($it){
               matches($it,"^.+$")
             })
             => count() } into .
     ,

     insert node element filesize { $output => file:size() => prof:human() } into .,
     insert node element wpm {
       format-number( $wpm, "0.00")
      } into .
   }
  }catch err:bar {
    <json type="object">
      <fail>"Failed"</fail>
      <code>{$err:code}</code>
      <desc>{$err:description}</desc>
      <value>{$err:value}</value>
      <line>{$err:line-number}</line>
      <stack>{$err:additional}</stack>
    </json>
  }

};

(:~
 : Endpoint for form data validation.
 : Will validate the first uploaded document.
 : @return JSON validation result
 :)

declare
  %rest:path("/validate-form-data")
  %rest:POST
  %rest:form-param("subtitle", "{$files}")
  %rest:form-param("token", "{$token}")
  %output:method("json")
  function page:validate-form-data(
    $files,
    $token as xs:string?
  ){
  let $config := $page:CONFIG
  let $verified := true()
  let $name := map:keys($files) => head()
  let $body := $files($name)
  let $output := file:create-temp-file("SVRL-", ".xml")
  let $up := file:write-binary($output, $body)
  return if($verified) then page:val($output, $name) else ()

};

(:~
  : Endpoint for XML body data validation.
  : Will validate the first uploaded document.
  : @return JSON validation result
 :)

declare
  %rest:path("/validate")
  %rest:POST("{$body}")
  %rest:consumes("text/plain")
  %output:method("json")
  function page:validate(
    $body
){
  let $output := file:create-temp-file("SVRL-", ".xml")
  let $up := file:write-text($output, $body)
  return page:val($output, "File")
};


declare
  %rest:path('/tags')
  %rest:GET
  %output:method("json")
function page:tags(){
  element json {
    attribute type { "object" },
    attribute objects {"Data  Level TagGroup _"},
    attribute arrays {"Tags TagList"},
    attribute booleans {"selectFilterInitial"},
  <Data>
     <Tags>
     <_>
        <TagGroup>
           <TagList>
           {
             $page:CONFIG/config/xcf-constraints//Specification[empty(.//disableFilter)]/Acronym
             => for-each(function($it){
                  element _ {
                    element Long  { $it/string() },
                    element Short { $it/string() },
                    element ID    { $it/string() },
                    element selectFilterInitial { exists($it/../Config/selectFilterInitial)}
                  }
               })
           }
           </TagList>
           <type>Specifications</type>
        </TagGroup>
     </_>
     <_>
        <TagGroup>
           <TagList>
           {
             $page:CONFIG/config/xcf-constraints//Error_Level
             => distinct-values()
             => filter(function($it){$it != "NONE"})
             => for-each(function($it){
                  element _ {
                    element Long  { $it },
                    element Short { $it },
                    element ID    { $it }
                  }

               })

           }
           </TagList>
           <type>Error Level</type>
        </TagGroup>
     </_>

     {
       for $tag in $page:CONFIG/config/xcf-constraints//Tags/Tag
       group by $type := $tag/@type
       return element _ {
         element TagGroup {
           element TagList {
           for $tag in $tag

           return element _ {
             element Long  { $tag/DisplaynameLong/string() },
             element Short { $tag/DisplaynameShort/string() },
             element ID    { $tag/DisplaynameShort/string() }
           }
         },
        element type { $type }
       }
     }}
     </Tags>
  </Data>
  }
};
