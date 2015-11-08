window.onload = function () {
 document.querySelector("#open").addEventListener("click", openFile);
}

var directoryEntry;
 function openFile() {
     chrome.fileSystem.chooseEntry(
       {
         type: 'openDirectory'
       },
       function (de) {
        fileList = [];
         if (de) {
           directoryEntry = de;
           
           var dirReader = de.createReader();
           var readEntries = function() {
             dirReader.readEntries (function(results) {
              // console.log(results);
               results.forEach(
                  function(item, indx, arr) {
                    console.log(item.name);
                    fileList.push(item.name);
                  }
                )
               if (!results.length) {
                 console.log(entries);
                 listResults(entries.sort());
               } else {
                 entries = entries.concat(toArray(results));
                entries.forEach(
                  function(item, indx, arr){
                    console.log(item.name);
                  }  
                )
                 readEntries();
               }
             }, errorHandler);
           };
           console.log("outside");
           readEntries();
           console.log(fileList);
         } // end of if statement
       }
     );
       request();
 }

function request() {
  console.log("Calling rails");
  var xmlhttp = new XMLHttpRequest();
  var url = "http://localhost:3000/files?session="+session_id;
  // var token = $("meta[name='csrf-token']").attr("content");
  // xmlhttp.setRequestHeader("X-CSRF-Token", token);

  xmlhttp.open("POST", url, true);
  xmlhttp.onreadystatechange = function(){
    if(xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        console.log(xmlhttp.responseText);
    }
  }
  xmlhttp.send();
}

 function listResults(entries) {
   // Document fragments can improve performance since they're only appended
   // to the DOM once. Only one browser reflow occurs.
   var fragment = document.createDocumentFragment();

   entries.forEach(function(entry, i) {
     var img = entry.isDirectory ? '<img src="folder-icon.gif">' :
                                   '<img src="file-icon.gif">';
     var li = document.createElement('li');
     li.innerHTML = [img, '<span>', entry.name, '</span>'].join('');
     fragment.appendChild(li);
   });

   document.querySelector('#filelist').appendChild(fragment);
 }
 
 
 chrome.runtime.onMessageExternal.addListener(
    function(request, sender, sendResponse) {
      alert("request");
        if (request) {
            if (request.message) {
                if (request.message == "version") {
                    
                    sendResponse({version: 1.0});
                }
            }
        }
        return true;
    });

 function errorHandler(e) {
   var msg = '';

   switch (e.code) {
     case FileError.QUOTA_EXCEEDED_ERR:
       msg = 'QUOTA_EXCEEDED_ERR';
       break;
     case FileError.NOT_FOUND_ERR:
       msg = 'NOT_FOUND_ERR';
       break;
     case FileError.SECURITY_ERR:
       msg = 'SECURITY_ERR';
       break;
     case FileError.INVALID_MODIFICATION_ERR:
       msg = 'INVALID_MODIFICATION_ERR';
       break;
     case FileError.INVALID_STATE_ERR:
       msg = 'INVALID_STATE_ERR';
       break;
     default:
       msg = 'Unknown Error';
       break;
   };
   console.log('Error: ' + msg);
}
