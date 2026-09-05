[ ."versions"
  | to_entries | .[]
    | .["key"] as $v
    | .["value"] | to_entries | .[]
      | .["key"] == "r" as $r
      | .["value"]
        | (
            ([ .["s"], [ ({n: ."n"[], $v, $r }) ] ] | transpose
          | .[]) | {"key": .[0], "value": .[1]}
          )]

