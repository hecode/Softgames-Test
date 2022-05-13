function syncFunction() {

    var names = {
    fname: document.getElementById("fname").value,
    lname: document.getElementById("lname").value,
    };

    if (window.webkit && window.webkit.messageHandlers) {
        try {
            webkit.messageHandlers.NamesJSInterface.postMessage(names);
        } catch(err) {
            console.log(err);
        }
    } else {
        console.log("No interface APIs found.");
    }
}

function asyncFunction() {
    var dob = document.getElementById("dob").value;
    if (window.webkit && window.webkit.messageHandlers) {
        try {
            webkit.messageHandlers.DobJSInterface.postMessage(dob);
        } catch(err) {
            console.log(err);
        }
    } else {
        console.log("No interface APIs found.");
    }
}

function localNotificationFunction() {
    if (window.webkit && window.webkit.messageHandlers) {
        try {
            webkit.messageHandlers.LocalNotificationJSInterface.postMessage("");
        } catch(err) {
            console.log(err);
        }
    } else {
        console.log("No interface APIs found.");
    }
}



function setFullName(fullName) {
    document.getElementById("fullName").innerText = fullName;
}

function setAge(age) {
    document.getElementById("age").innerText = age;
}

