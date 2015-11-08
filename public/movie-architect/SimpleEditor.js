window.onload = function () {
 document.querySelector("#open").addEventListener("click", openFile);
 document.getElementById("submit").addEventListener("click", execute);
}

fileList = [];

function openFile() {
   chrome.fileSystem.chooseEntry(
     {
       type: 'openDirectory'
     },
     function (de) {
       if (de) {
         directoryEntry = de;
        // show the selected folder
        
        document.getElementById('after-chosen').style.display = "block";
        chrome.fileSystem.getDisplayPath(de, 
          function(path)
          {
            document.getElementById('folder-path').innerHTML = path;
          });
        var dirReader = de.createReader();
         var readEntries = function() {
           
           dirReader.readEntries (function(results) {
             if (!results.length) {
               console.log("Could not find any entries inside the path");
             } else {
               results.forEach(
                 function(item, indx) {
                   console.log(item);
                   fileList.push(item.fullPath);
                  // listResults(fileList);
                 }
               );
               console.log("heerer");
              document.getElementById('submit_button').style.display = "block";
              // execute(fileList);
             }
             // console.log(fileList);
           }, errorHandler);
         };
         readEntries();
       } // end of if statement
     }
   );
}


function listResults(entries) {
 // Document fragments can improve performance since they're only appended
 // to the DOM once. Only one browser reflow occurs.
 var fragment = document.createDocumentFragment();
 entries.forEach(function(name, i) {
   var li = document.createElement('li');
   li.innerHTML = ['<span>', name, '</span>'].join('');
   fragment.appendChild(li);
 });
 document.querySelector('#filelist').appendChild(fragment);
}

function execute(){
 document.getElementById('loading').style.display = "block";
 document.getElementById('open').style.display = "none";
 document.getElementById('submit_button').style.display = "none";
 var xhr = new XMLHttpRequest();
 var url = 'http://localhost:3000/files?session='+session_id;
 xhr.open('post', url, true);
 // xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
 xhr.send(JSON.stringify(fileList), chrome_session_id: session_id);
 console.log(xhr.response);
 return xhr.response;
};

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
