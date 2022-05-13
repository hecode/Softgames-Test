window.onerror = function(error) {
  alert(error); // Fire when errors occur. Just a test.
};

function syncFunction() {

    var names = {
    fname: document.getElementById("fname").value,
    lname: document.getElementById("lname").value,
    };

    if (window.webkit && window.webkit.messageHandlers) {
        try {
            webkit.messageHandlers.NativeJavascriptInterface.postMessage(names);
        } catch(err) {
            console.log(err);
        }
    } else {
        console.log("No interface APIs found.");
    }
}

function asyncFunction() {
    document.getElementById("frm1").submit();
}

function setFullName(fullName) {
    document.getElementById("fullName").innerText = fullName;
}
