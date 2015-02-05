
[SharePlugin]

Usage:

SharePlugin.show(function () {
        console.log("success");
    }, function () {
        console.log("fail");
    }, {
        text: "My text",
        urlAttach: "My Url",
        imageAttach: "My Image Url",
    });

The three parameters, text, urlAttach & imageAttach are opcional.
This displays an UIActionSheet with Twitter, Facebook and Cancel options
Todo
	-it has Spanish strings... make them optional from js
	-make Twitter, Facebook and Cancel optional.