function Player(tableid, controlsid, calls) {
    var labels = ["ID", "Start", "End", "Frequency", "Talkgroup", "Audio"];
    var table, current;

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
                                                           $(getCurrent()).attr("preload", "auto");
                                                           return "ready";
                                                       }
                                             },
                                    ready: { play: play,
                                             pause: ignore,
                                             next: next,
                                             prev: prev,
                                             loaded: ignore
                                           },
                                    playing: { play: ignore,
                                               pause: pause,
                                               next: next,
                                               prev: prev,
                                               loaded: ignore
                                             },
                                    paused: { play: play,
                                              pause: ignore,
                                              next: next,
                                              prev: prev,
                                              loaded: ignore
                                            }
                                  });

    var controls = $(controlsid);
    var buttons = { play: controls.find(".play"),
                    pause: controls.find(".pause"),
                    next: controls.find(".next"),
                    prev: controls.find(".prev")
                  };
    buttons.play.on("click", player.play);
    buttons.pause.on("click", player.pause);
    buttons.next.on("click", player.next);
    buttons.prev.on("click", player.prev);

    if (calls)
        player.loaded(calls);
    else
        fetcher.fetch();

    function getCurrent() {
        if (typeof current === "undefined") {
            current = $("audio:first").get(0);
            $(current).parent().parent().addClass("current");
        }
        return current;
    }
    
    function getNext(current, dir) {
        var idx = $(current).data("idx") + dir;
        if (idx >= 0 && idx < calls.length)
            return $("#audio-"+ calls[idx].id).get(0);
        return null;
    }

    function setCurrent(v) {
        $(current).parent().parent().removeClass("current");
        $(v).parent().parent().addClass("current");
        return current = v;
    }
    
    function getTable() {
        if (!table)
            table = makeTable(labels,
                              { "class": "tracks" }).appendTo(tableid);
        return table;
    };

    function displayCalls(calls) {
        getTable().append(calls.map(function (call, idx) {
            var audio = $("<audio>",
                          { preload: "none",
                            src: "/calls/"+ call.id +".oga",
                            controls: "true",
                            id: "audio-"+ call.id
                          });
            audio.data("idx", idx)
                 .on('ended', player.next);
            return makeRow([ makeTextCell(call.id),
                             makeTextCell(formatDate(call.start)),
                             makeTextCell(formatDate(call.end)),
                             makeTextCell(call.frequency),
                             makeTextCell(call.group_name),
                             makeCell(audio)],
                           { id: "call-"+ call.id });
        }));
    }

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
        player.loaded(data);
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

    function play(event, state) {
        var current = getCurrent();
        current.play();
        buttons.play.hide();
        buttons.pause.show();
        $(getNext(current, 1)).attr("preload", "auto");
        return "playing";
    }

    function pause(event, state) {
        var current = getCurrent();
        current && current.pause();
        buttons.pause.hide();
        buttons.play.show();
        return "paused";
    }

    function advance(event, state, dir) {
        var current = getCurrent();
        current.pause();
        current.currentTime = 0;
        var next = getNext(current, dir);
        if (next) {
            setCurrent(next);
            if (state === "playing")
                return play(event, state);
            return state;
        }
        setCurrent();
        return "ready";
    }

    function next(event, state) {
        return advance(event, state, 1);
    }
    
    function prev(event, state) {
        return advance(event, state, -1);
    }
}
