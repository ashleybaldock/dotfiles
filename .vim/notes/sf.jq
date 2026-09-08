[ ."versions"
  | to_entries | .[]
    | .["key"] as $v
    | .["value"] | to_entries | .[]
      | .["key"] == "r" as $r
      | .["value"]
        | (
            ([ .["s"], [ ({n: ."n"[], $v, $r }) ] ] | transpose
          | .[]) | {"key": .[0], "value": .[1]}
          )
] | reduce .[] as {$key,$value} ({}; if (.[$key] | length) == 0 then .[$key] = $value else .[$key] = [.[$key], $value] end)
#  | with_entries(.value |= (if length == 1 then .[0] else . end))

