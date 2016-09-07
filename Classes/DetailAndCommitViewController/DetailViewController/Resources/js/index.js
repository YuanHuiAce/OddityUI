$(function() {

    var windowWidth = $(window).width() - 36;

    $("#body_section img").click(function() {
        var index = $("img").index(this);
        window.webkit.messageHandlers.JSBridge.postMessage({
            "type": 1,
            "index": index
        });
    })

    $('img').load(function() {
        window.webkit.messageHandlers.JSBridge.postMessage({
            "type": 0
        });
    });

    fixedImageHeightAndWidth()

    $("#video iframe").width($(window).width() - 40);
    $("#video iframe").height($("#video iframe").width() * 3 / 5);
    $("#video iframe").addClass("center-block");
});

var ajaxUrl = []


function fixedImageHeightAndWidth(){

    $("img").each(function(index, img) {
                  
                  var width = $(this).attr("w");
                  if (width > windowWidth) {
                  width = windowWidth
                  }
                  $(this).height(width * $(this).attr("h") / $(this).attr("w"))
                  $(this).width(width)
                  $(this).css("background-color", "#f6f6f6");
                  })
}

function scrollMethod(offesty) {

    $("img").each(function(index, img) {

        var datasrc = $(this).attr("data-src")

        if ($(this).offset().top < offesty+200 && ajaxUrl.indexOf(index) == -1) {
                  
            ajaxUrl.push(index)
                  
            window.webkit.messageHandlers.JSBridge.postMessage({
                "type": 3,
                "index": index,
                "url": datasrc
            });
        }
    })
}
