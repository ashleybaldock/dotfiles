[ ."versions"
  | to_entries | .[]
    | .["key"] as $v
    | .["value"] | to_entries | .[]
      | .["key"] == "r" as $r
      | .["value"]
        | (
            ([ .["s"], [ ({ n: ."n"[], $v, $r }) ] ]
            | transpose
            | .[]) | { "key": .[0], "value": .[1] }
          )
]
  | reduce .[] as { $key, $value } ({};
      # if (.[$key] | length) == 0 then .[$key] = $value else .[$key] = [.[$key], $value] end
      .[$key] += [$value]
    )
  | with_entries(.value |= (flatten | if length == 1 then .[0] else .[0] + {o: .[1:] | sort_by(.v)} end))
#  | with_entries(.value |= (if length == 1 then .[0] else . end))

