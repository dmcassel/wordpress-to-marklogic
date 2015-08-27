xquery version "1.0-ml";

import module namespace rss = "http://marklogic.com/rss" at "/task/feed-lib.xqy";

rss:load-page('post', 1)
