xquery version "1.0-ml";

module namespace rss = "http://marklogic.com/rss";

declare function rss:load-page($feed, $page-num) {
  let $log := xdmp:log("loading page " || $page-num)
  let $url :=
   'http://www.marklogic.com/feed/?post_type=' || $feed ||
      (if ($page-num gt 1) then
       '&amp;paged=' || $page-num
       else
         ())
  let $response :=
    xdmp:http-get(
      $url,
      <options xmlns="xdmp:document-get">
        <repair>full</repair>
      </options>)
  let $items := $response[2]/rss/channel/item
  let $insert :=
    $items ! xdmp:document-insert(
      ./link/fn:string() || ".xml",
      .,
      xdmp:default-permissions(),
      "www.marklogic.com"
    )
  return
    if (fn:count($items) gt 0) then
      rss:load-page($feed, $page-num + 1)
    else ()
};
