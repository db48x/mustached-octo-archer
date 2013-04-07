function Player(id, calls) {    
    var labels = ["start", "end", "frequency", "group_id", "id"];
    var props = ["start", "end", "frequency", "group_id", "id"];

    var getTable = (function () {
                        var table;
                        return function getTable() {
                                   if (table) return table;
                                   return table = makeTable(labels,
                                                            { "class": "tracks" }).appendTo("#"+id);
                               };
                    })();

    var displayCalls = (function () {
                            var idx = 0;
                            return function displayCalls(calls) {
                                       getTable().append(calls.map(function (call) {
                                                                       var cells = props.map(function (prop) {
                                                                                                 return makeTextCell(call[prop],
                                                                                                                     { "class": prop });
                                                                                             });
                                                                       return makeRow(cells, { id: "track-"+ idx });
                                                                   }));
                            };
                        })();

    var fetcher = new StateMachine("fetcher",
                                   "quiescent",
                                   { quiescent: { fetch: fetchMore },
                                     requesting: { success: fetchSuccess,
                                                   failure: fetchFailure,
                                                   timeout: fetchTimeout
                                                 }
                                   });

    var player = new StateMachine("player",
                                  "initial",
                                  { initial: { play: ignore,
                                               pause: ignore,
                                               next: ignore,
                                               prev: ignore,
                                               loaded: function (state, event, calls) {
                                                           displayCalls(calls);
                                                           return "ready";
                                                       }
                                             },
                                    ready: { play: ignore,
                                             pause: ignore,
                                             next: ignore,
                                             prev: ignore,
                                             loaded: ignore
                                           },
                                    playing: { play: ignore,
                                               pause: ignore,
                                               next: ignore,
                                               prev: ignore,
                                               loaded: ignore
                                             },
                                    paused: { play: ignore,
                                              pause: ignore,
                                              next: ignore,
                                              prev: ignore,
                                              loaded: ignore
                                            }
                                  });

    if (calls)
        player.loaded(calls);
    else
        fetcher.fetch();

    function ignore(event, state) { return state; }
    function fetchMore(event, state, query) {
        $.ajax("/calls/recent.json",
               { cache: false,
                 timeout: 30000,
                 success: fetcher.success,
                 error: function (xhr, status, error) {
                            return fetcher[(status == "timeout") ? "timeout" : "failure"]
                                          .apply(null, arguments);
                        }
               });
        return "requesting";
    }
    function fetchSuccess(event, state, data, status, error) {
        displayCalls(data);
        return "quiescent";
    }
    function fetchFailure(event, state, data, status, error) {
        console.log(status, error);
        // TODO: retries and stuff
        return "quiescent";
    }
    function fetchTimeout(event, state, data, status, error) {
        return fetcher.fetch();
    }
}
