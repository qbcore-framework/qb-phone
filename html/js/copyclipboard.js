$(document).on(
    "click",
    "#phoneNumberSelect, #serialNumberSelect",
    function (e) {
        // get the text id myPhoneNumber or mySerialNumber
        var textToCopy =
            $(this).attr("id") == "phoneNumberSelect"
                ? $("#myPhoneNumber").text()
                : $("#mySerialNumber").text();
        // Get the text content of the clicked element
        // var textToCopy = $(this).text();

        // Copying the text to clipboard using Clipboard.js
        var clipboard = new ClipboardJS(this, {
            text: function () {
                return textToCopy;
            },
        });
    }
);
