module namespace jwt="jwt";

declare variable $jwt:test-token := ``[eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ]``;

(:~
: Returns a map representation of a parsed token, if the parse succeeds.
: A parsed token only denotes that the JWT satisfies basic syntactic rules.
: To ensure the token has been issued by a valid party, you must make sure to `jwt:validate` it using a shared secret.
 :)
declare function jwt:parse($token-string as xs:string) as map(xs:string,item()){
  let $parts   := ($token-string =>tokenize("\."))
  let $parts   := if( count($parts) = 3 )
    then $parts
    else jwt:error("invalidStructure", "Token has invalid structure")
  let $header  := jwt:extract-base64-json($parts[1])
  let $payload := jwt:extract-base64-json($parts[2])
  let $token   := map {
    "header"    : $header,
    "header64"  : $parts[1],
    "payload"   : $payload,
    "payload64" : $parts[2],
    "signature" : $parts[3]
  } => jwt:validate-parse()
  return $token
};
(:~
: Checks if the token corresponds to some basic rules.
: For now only one rule is enforced:
: - [x] Algorithm has to be HS256
 :)
declare
  %private
function jwt:validate-parse($token as map(*)){
 let $token :=  if($token("header")/alg != "HS256")
   then jwt:error("unspportedAlgo", ``[`{$token/header/alg}` not supported ]``)
   else $token
 return $token
};

declare function jwt:error($code as xs:string, $message as xs:string){
  fn:error(QName("jwt.io", $code), "Token has invalid structure.")
};
(:~
: Validates a given token using the hmac function.
~:)
declare
  %public
function jwt:verify($token-string as xs:string, $key as xs:string) as xs:boolean{
 let $token := jwt:parse($token-string)
 let $sig := crypto:hmac(
  concat(
      $token("header64"), ".", $token("payload64")
    ),
    $key,
    "sha256"
  ) => replace("=+$","") (: "Remove Filling characters. " :)
    => replace("\+","-") (: base64url, replace + with - :)
    => replace("/","_") (: base64url, replace / with _ :)
  return $token("signature") = $sig
};

(:~
 : Converts a base64-encoded string to a JSON representation and extracts the body.
~ :)
declare
  %private
function jwt:extract-base64-json($string as xs:string) as element(json){
  let $strlen := string-length($string)
  let $string := concat($string, switch($strlen mod 4)

  case 1 return "="
  case 2 return "=="
  case 3 return "="
  default return "")
  return
   ($string
      => xs:base64Binary()
      => convert:binary-to-string()
      => json:parse()
    )/json
};

(: ~~~~~~~~~~~~~~~~~~~~:)

(: Unit Tests :)
declare  %unit:test function jwt:test-decode(){
  jwt:parse($jwt:test-token)
};

declare  %unit:test function jwt:test-validate(){
  jwt:verify($jwt:test-token, "secret") => unit:assert()
};

declare  %unit:test function jwt:test-validate-fail(){
  jwt:verify($jwt:test-token, "secre2")
  => not()
  => unit:assert()
};

(: Unit Tests :)
declare  %unit:test("expected", "jwt:invalidStructure") function jwt:fail-decode(){
  jwt:parse($jwt:test-token||".foo") => trace()
};
